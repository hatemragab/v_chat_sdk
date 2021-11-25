import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:v_chat_sdk/src/services/notification_service.dart';
import '../../../enums/message_type.dart';
import '../../../enums/room_typing_type.dart';
import '../../../models/v_chat_message.dart';
import '../../../models/v_chat_message_attachment.dart';
import '../../../models/v_chat_room_typing.dart';
import '../../../services/local_storage_service.dart';
import '../../../services/socket_service.dart';
import '../../../services/v_chat_app_service.dart';
import '../../../utils/api_utils/dio/custom_dio.dart';
import '../../../utils/custom_widgets/custom_alert_dialog.dart';
import '../../../utils/file_utils.dart';
import '../../rooms/cubit/room_cubit.dart';
import '../providers/message_provider.dart';
import '../providers/message_socket.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> with WidgetsBindingObserver {
  late MessageSocket _messageSocket;
  late int roomId;

  ///init message socket to stop receive notifications from this user
  MessageCubit() : super(MessageInitial()) {
    _messageSocket = MessageSocket(
      currentRoomId: RoomCubit.instance.currentRoomId!,
      myId: VChatAppService.to.vChatUser!.id,
      onNewMessage: onNewMessage,
      onAllMessages: onAllMessages,
    );
    textController.addListener(() {
      if (textController.text.isEmpty) {
        emitTypingChange(0);
      } else {
        emitTypingChange(1);
      }
    });
    WidgetsBinding.instance!.addObserver(this);
    NotificationService.to.cancelAll();
  }

  final textController = TextEditingController();
  bool isEmitTyping = false;
  final _messageApiProvider = MessageProvider();
  final messages = <VChatMessage>[];
  final scrollController = ScrollController();
  bool isLoadMoreFinished = false;

  ///get messages from sqlite
  Future<void> getLocalMessages(int roomId) async {
    this.roomId = roomId;
    final messages = await LocalStorageService.to.getRoomMessages(roomId);
    this.messages.clear();
    this.messages.addAll(messages);
    emit(MessageLoaded(messages));
  }

  ///lode more messages if top retched
  Future<bool> loadMoreMessages() async {
    try {
      if (messages.isEmpty||messages.length<19) {
        return true;
      }
      final loadedMessages = await _messageApiProvider.loadMoreMessages(
        roomId,
        messages.last.id.toString(),
      );
      messages.addAll(loadedMessages);
      if (loadedMessages.isEmpty) {
        ///if no more data stop the loading
        isLoadMoreFinished = true;
      }
      emit(MessageLoaded(messages));
      return true;
    } catch (err) {
      return false;
    }
  }

  ///Emit text message to server
  void sendTextMessage( ) async {
    try {
      if (!SocketService.to.isConnected) {

        throw "Not connected to server yet";
      }
      unawaited(CustomDio().send(reqMethod: "POST", path: "message", body: {
        "type": MessageType.text.inString,
        "roomId": roomId.toString(),
        "content":textController.text.toString()
      }));

      textController.clear();
    } catch (err) {
      textController.text = textController.text;
      CustomAlert.error(msg: err.toString());
    }
  }

  /// insert new message to the list and update
  void onNewMessage(VChatMessage message) {
    if (!messages.contains(message)) {
      messages.insert(0, message);
      emit(MessageLoaded(messages));
    }
  }

  /// update all messages from server side last 20 message only
  void onAllMessages(List<VChatMessage> messages) {
    this.messages.clear();
    this.messages.addAll(messages);
    emit(MessageLoaded(messages));
  }

  ///Emit voice note
  void sendVoiceNote(String path, String duration) async {
    try {
      CustomAlert.customLoadingDialog();
      final voiceFile = File(path);
      final fileSize = FileUtils.getFileSize(voiceFile);
      if (!SocketService.to.isConnected) {
        throw "Not connected to server yet";
      }
      await FileUtils.uploadFile(
          [
            voiceFile,
          ],
          "message/file",
          body: {
            "roomId": roomId.toString(),
            "content": "this content voice 🎤",
            "type": MessageType.voice.inString,
            "attachment": jsonEncode(VChatMessageAttachment(
              fileSize: fileSize,
              fileDuration: duration,
            ).toMap())
          });
      Navigator.pop(VChatAppService.to.navKey!.currentContext!);
    } catch (err) {
      Navigator.pop(VChatAppService.to.navKey!.currentContext!);
      CustomAlert.error(msg: err.toString());
      rethrow;
    }
  }

  /// 0 mean stop typing or recording
  /// 1 emit typing
  /// 2 emit recording
  void emitTypingChange(int type) {
    try {
      if (type == 0) {
        isEmitTyping = false;
      }
      if (!isEmitTyping) {
        final roomTyping = VChatRoomTyping(
            roomId: roomId,
            status: type == 0
                ? RoomTypingType.stop
                : type == 1
                    ? RoomTypingType.typing
                    : RoomTypingType.recording,
            name: VChatAppService.to.vChatUser!.name);
        SocketService.to.emitTypingChange(roomTyping.toMap());
      }
      if (type == 1) {
        isEmitTyping = true;
      }
    } catch (err) {
      //
    }
  }

  ///Emit picked image after compress
  void sendImage(String path) async {
    try {
      CustomAlert.customLoadingDialog();
      if (!SocketService.to.isConnected) {
        throw "Not connected to server yet";
      }
      final _pickedImage = File(path);
      final compressedFile = await FileUtils.compressImage(_pickedImage);

      final properties =
          await FlutterNativeImage.getImageProperties(compressedFile.path);
      final fileSize = FileUtils.getFileSize(compressedFile);
      await FileUtils.uploadFile(
          [
            compressedFile,
          ],
          "message/file",
          body: {
            "roomId": roomId.toString(),
            "content": "this content image 📷",
            "type": MessageType.image.inString,
            "attachment": jsonEncode(VChatMessageAttachment(
              fileSize: fileSize,
              height: properties.height.toString(),
              width: properties.width.toString(),
            ).toMap())
          });
      Navigator.pop(VChatAppService.to.navKey!.currentState!.context);
    } catch (err) {
      Navigator.pop(VChatAppService.to.navKey!.currentContext!);
      CustomAlert.error(msg: err.toString());
      rethrow;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        _messageSocket.connectMessageSocket();
        break;
      case AppLifecycleState.inactive:
        _messageSocket.disconnect();
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  ///close message name space socket so can receive notifications
  @override
  Future<void> close() async {
    _messageSocket.dispose();
    RoomCubit.instance.currentRoomId = null;
    scrollController.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    if (isEmitTyping) {
      emitTypingChange(0);
    }
    // textController.removeListener(() { });
    super.close();
  }

  void sendVideo(String path) async {
    final context = VChatAppService.to.navKey!.currentContext!;
    try {
      CustomAlert.customLoadingDialog(context: context);
      final videoFile = File(path);
      final videoThumb = await FileUtils.getVideoThumb(videoFile);
      final properties =
          await FlutterNativeImage.getImageProperties(videoThumb.path);
      final d = await FileUtils.getVideoDuration(videoFile.path);
      final fileSize = FileUtils.getFileSize(videoFile);
      if (!SocketService.to.isConnected) {
        throw "Not connected to server yet";
      }
      await FileUtils.uploadFile(
        [videoThumb, videoFile],
        "message/file",
        body: {
          "roomId": roomId.toString(),
          "content": "this content video 📽",
          "type": MessageType.video.inString,
          "attachment": jsonEncode(VChatMessageAttachment(
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

  void sendFile(String path) async {
    final context = VChatAppService.to.navKey!.currentContext!;
    try {
      CustomAlert.customLoadingDialog(context: context);

      final file = File(path);

      final fileSize = FileUtils.getFileSize(file);
      if (!SocketService.to.isConnected) {
        throw "Not connected to server yet";
      }
      await FileUtils.uploadFile(
          [
            file,
          ],
          "message/file",
          body: {
            "roomId": roomId.toString(),
            "content": "this content file 📁",
            "type": MessageType.file.inString,
            "attachment": jsonEncode(VChatMessageAttachment(
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
}
