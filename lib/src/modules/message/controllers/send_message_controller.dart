import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import '../../../enums/message_type.dart';
import '../../../enums/room_typing_type.dart';
import '../../../models/v_chat_message_attachment.dart';
import '../../../models/v_chat_room_typing.dart';
import '../../../services/socket_controller.dart';
import '../../../services/socket_service.dart';
import '../../../services/vchat_app_service.dart';
import '../../../utils/api_utils/dio/custom_dio.dart';
import '../../../utils/api_utils/server_config.dart';
import '../../../utils/custom_widgets/custom_alert_dialog.dart';
import '../../../utils/file_utils.dart';
import '../../room/controllers/rooms_controller.dart';
import 'message_controller.dart';

class SendMessageController extends GetxController {
  final textController = TextEditingController();
  final _socketController = Get.find<SocketController>();
  final _roomController = Get.find<RoomController>();
  final _socketService = Get.find<SocketService>();
  final _myModel = VChatAppService.to.vChatUser!;
  final _messageController = Get.find<MessageController>();

  final isRecordWidget = true.obs;
  bool isEmitTyping = false;
  final msgText = "".obs;

  void sendTextMessage() async {
    _messageController.isLastMessageSeen.value = false;
    if (textController.text.isEmpty) throw ("message must be not empty !");
    try {
      if (!_socketService.isConnected) {
        throw "not connected to server yet";
      }
      await CustomDio().send(reqMethod: "POST", path: "message", body: {
        "type": MessageType.text.inString,
        "roomId": _roomController.currentRoom!.id.toString(),
        "content": textController.value.text.toString()
      });
      textController.clear();
    } catch (err) {
      CustomAlert.error(msg: err.toString());
    }
  }

  @override
  void onReady() {
    super.onReady();
    textController.addListener(() {
      final value = textController.value.text;
      msgText.value = textController.value.text;
      if (value.isEmpty) {
        isRecordWidget.value = true;
        emitTypingChange(0);
      } else {
        isRecordWidget.value = false;
        emitTypingChange(1);
      }
    });
  }

  @override
  void onClose() {
    try {
      if (isEmitTyping) {
        emitTypingChange(0);
      }
      textController.dispose();
    } catch (err) {
      log(err.toString());
    } finally {
      return super.onClose();
    }
  }

  void emitTypingChange(int type) {
    //0 mean stop
    //1 typing
    //2 recording

    try {
      if (type == 0) {
        isEmitTyping = false;
      }
      if (!isEmitTyping) {
        final roomTyping = VChatRoomTyping(
            roomId: _messageController.currentRoom!.id,
            status: type == 0
                ? RoomTypingType.stop
                : type == 1
                    ? RoomTypingType.typing
                    : RoomTypingType.recording,
            name: _myModel.name);
        _socketController.emitTypingChange(roomTyping);
      }
      if (type == 1) {
        isEmitTyping = true;
      }
    } catch (err) {}
  }

  void emitPickedImage(BuildContext context, String path) async {
    try {
      _messageController.isLastMessageSeen.value = false;
      CustomAlert.customLoadingDialog(context: context);
      final _pickedImage = File( path);
      final compressedFile = await FileUtils.compressImage(_pickedImage);

      final ImageProperties properties =
          await FlutterNativeImage.getImageProperties(compressedFile.path);
      final fileSize = FileUtils.getFileSize(compressedFile);
      if (!_socketService.isConnected) {
        throw "not connected to server yet";
      }
      await FileUtils.uploadFile(
          [
            compressedFile,
          ],
          "message/file",
          body: {
            "roomId": _roomController.currentRoom!.id.toString(),
            "content": "this content image 📷",
            "type": MessageType.image.inString,
            "attachment": jsonEncode(VchatMessageAttachment(
              fileSize: fileSize,
              height: properties.height.toString(),
              width: properties.width.toString(),
            ).toMap())
          });
      Navigator.pop(context);
    } catch (err) {
      Navigator.pop(context);
      CustomAlert.error(msg: err.toString());
      rethrow;
    }
  }

  void emitPickedFile(BuildContext context, PlatformFile platformFile) async {
    try {
      _messageController.isLastMessageSeen.value = false;
      CustomAlert.customLoadingDialog(context: context);

      final file = File(platformFile.path!);

      final fileSize = FileUtils.getFileSize(file);
      if (!_socketService.isConnected) {
        throw "not connected to server yet";
      }
      await FileUtils.uploadFile(
          [
            file,
          ],
          "message/file",
          body: {
            "roomId": _roomController.currentRoom!.id.toString(),
            "content": "this content file 📁",
            "type": MessageType.file.inString,
            "attachment": jsonEncode(VchatMessageAttachment(
              fileSize: fileSize,
              linkTitle: basename(file.path),
            ).toMap())
          });
      Navigator.pop(context);
      file.deleteSync();
    } catch (err) {
      Navigator.pop(context);
      CustomAlert.error(msg: err.toString());
    }
  }

  void emitPickedVideo(BuildContext context, PlatformFile platformFile) async {
    try {
      _messageController.isLastMessageSeen.value = false;
      CustomAlert.customLoadingDialog(context: context);
      final videoFile = File(platformFile.path!);
      final videoThumb = await FileUtils.getVideoThumb(videoFile);
      final ImageProperties properties =
          await FlutterNativeImage.getImageProperties(videoThumb.path);
      final d = await FileUtils.getVideoDuration(videoFile.path);
      final fileSize = FileUtils.getFileSize(videoFile);
      if (!_socketService.isConnected) {
        throw "not connected to server yet";
      }
      await FileUtils.uploadFile(
        [videoThumb, videoFile],
        "message/file",
        body: {
          "roomId": _roomController.currentRoom!.id.toString(),
          "content": "this content video 📽",
          "type": MessageType.video.inString,
          "attachment": jsonEncode(VchatMessageAttachment(
                  fileSize: fileSize,
                  height: properties.height.toString(),
                  width: properties.width.toString(),
                  fileDuration: d)
              .toMap())
        },
      );
      Navigator.pop(context);
      videoFile.deleteSync();
    } catch (err) {
      Navigator.pop(context);
      CustomAlert.error(msg: err.toString());
    }
  }

  void startPickFile(BuildContext ctx) async {
    final t = VChatAppService.to.getTrans(ctx);
    showCupertinoModalPopup(
      barrierDismissible: true,
      semanticsDismissible: true,
      context: ctx,
      builder: (context) {
        return CupertinoActionSheet(
          cancelButton: CupertinoActionSheetAction(
            child:   Text( VChatAppService.to.getTrans().cancel()),
            onPressed: () {
              Navigator.pop(ctx);
            },
          ),
          actions: [
            CupertinoActionSheetAction(
              child:   Text(VChatAppService.to.getTrans().photo()),
              onPressed: () async {
                Navigator.pop(ctx);
                final picker = ImagePicker();
                final pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);

                if (pickedFile != null) {
                  if (File(pickedFile.path).lengthSync() >
                      ServerConfig.MAX_MESSAGE_FILE_SIZE) {
                    CustomAlert.error(msg: t.fileIsTooBig());
                    File(pickedFile.path).deleteSync();
                    return;
                  }
                  emitPickedImage(ctx, pickedFile.path);
                }
              },
            ),
            CupertinoActionSheetAction(
              child:   Text(t.file()),
              onPressed: () async {
                Navigator.pop(ctx);
                final FilePickerResult? result =
                    await FilePicker.platform.pickFiles();
                if (result != null) {
                  if (File(result.files.first.path!).lengthSync() >
                      ServerConfig.MAX_MESSAGE_FILE_SIZE) {
                    CustomAlert.error(msg: t.fileIsTooBig());
                    File(result.files.first.path!).deleteSync();
                    return;
                  }
                  emitPickedFile(ctx, result.files.first);
                }
              },
            ),
            CupertinoActionSheetAction(
              child:   Text(t.video()),
              onPressed: () async {
                Navigator.pop(ctx);
                final FilePickerResult? result =
                    await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['mp4', 'mkv', 'avi', 'm4p', 'flv'],
                );
                if (result != null) {
                  if (File(result.files.first.path!).lengthSync() >
                      ServerConfig.MAX_MESSAGE_FILE_SIZE) {
                    CustomAlert.error(msg:t.fileIsTooBig());
                    File(result.files.first.path!).deleteSync();
                    return;
                  }
                  emitPickedVideo(ctx, result.files.first);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void emitVoice(BuildContext context, String path, String duration) async {
    try {
      _messageController.isLastMessageSeen.value = false;
      CustomAlert.customLoadingDialog(context: context);
      final voiceFile = File(path);
      final fileSize = FileUtils.getFileSize(voiceFile);
      if (!_socketService.isConnected) {
        throw "not connected to server yet";
      }
      await FileUtils.uploadFile(
          [
            voiceFile,
          ],
          "message/file",
          body: {
            "roomId": _roomController.currentRoom!.id.toString(),
            "content": "this content voice 🎤",
            "type": MessageType.voice.inString,
            "attachment": jsonEncode(VchatMessageAttachment(
              fileSize: fileSize,
              fileDuration: duration,
            ).toMap())
          });
      Navigator.pop(context);
    } catch (err) {
      Navigator.pop(context);
      CustomAlert.error(msg: err.toString());
    }
  }

  void showRecordWidgetAndStart(BuildContext context) {
    _messageController.startRecord(context);
  }
}
