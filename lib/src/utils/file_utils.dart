import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../models/v_chat_message_attachment.dart';
import '../services/v_chat_app_service.dart';
import 'api_utils/dio/custom_dio.dart';
import 'api_utils/server_config.dart';
import 'custom_widgets/custom_alert_dialog.dart';
import 'helpers/dir_helper.dart';

class FileUtils {
  FileUtils._();
  static Future newDownloadFile(BuildContext context, VChatMessageAttachment attachment) async {
    try {
      await _requestStoragePermission(context);
      final downloadFile = await DirHelper.downloadPath();
      final file = File(downloadFile + attachment.playUrl.toString());
      if (file.existsSync()) {
        await OpenFile.open(file.path);
      } else {
        try {
          final cancelToken = CancelToken();
          CustomAlert.customLoadingDialog(context: context);
          await CustomDio().download(
              path: ServerConfig.messagesMediaBaseUrl + attachment.playUrl.toString(),
              cancelToken: cancelToken,
              filePath: file.path);
          Navigator.pop(context);
          CustomAlert.done(context: context, msg: "File saved on device /download/${VChatAppService.instance.appName}");
          await OpenFile.open(file.path);
        } catch (err) {
          Navigator.pop(context);
          rethrow;
        }
      }
    } catch (err) {
      CustomAlert.customAlertDialog(errorMessage: err.toString(), context: context);
      rethrow;
    }
  }

  static Future compressImage(File file) async {
    final ImageProperties properties = await FlutterNativeImage.getImageProperties(file.path);
    File compressedFile = file;
    if (file.lengthSync() > 150 * 1000) {
      // compress only images bigger than 150 kb
      compressedFile = await FlutterNativeImage.compressImage(file.path,
          quality: 100, targetWidth: 700, targetHeight: (properties.height! * 700 / properties.width!).round());
    }

    //  final compressFile = await _copyTheCompressImage(compressedFile);
    // file.deleteSync();
    return compressedFile;
  }

  static String getFileSize(File file, {int decimals = 2}) {
    final int bytes = file.lengthSync();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    final i = (log(bytes) / log(1000)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  static String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  static Future<File> getVideoThumb(File file) async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: file.path,
      imageFormat: ImageFormat.PNG,
      quality: 50,
      maxHeight: 600,
      maxWidth: 800,
      timeMs: 1,
    );
    final t = (await getTemporaryDirectory()).path;
    final String fileName = "IMG_THUMB_${DateTime.now().microsecondsSinceEpoch}.png";
    final newFile = File("$t$fileName");
    return await newFile.writeAsBytes(uint8list!);
  }

  static Future<String> getVideoDuration(String path) async {
    final videoInfo = FlutterVideoInfo();
    final info = await videoInfo.getVideoInfo(path);
    //  final info = await VideoCompress.getMediaInfo(path);
    return _printDuration(Duration(milliseconds: info!.duration!.round()));
  }

  static Future<dynamic> uploadFile(List<File> files, String endPoint, {Map<String, String>? body}) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ServerConfig.serverBaseUrl}$endPoint'),
    );

    for (final file in files) {
      request.files.add(
        http.MultipartFile(
          'file',
          file.readAsBytes().asStream(),
          file.lengthSync(),
          filename: basename(file.path),
        ),
      );
    }

    request.headers.addAll({"authorization": VChatAppService.instance.vChatUser!.accessToken.toString()});
    if (body != null) {
      request.fields.addAll(body);
    }
    final stream = await request.send();
    final responseData = await stream.stream.toBytes();
    final responseString = String.fromCharCodes(responseData);
    return jsonDecode(responseString)['data'];
  }

  static Future _requestStoragePermission(BuildContext context) async {
    final c = Completer();
    if (!(await Permission.storage.isGranted)) {
      CustomAlert.customAlertDialog(
          context: context,
          errorMessage:
              "App Need this permission to save downloaded files in device storage /download/${VChatAppService.instance.appName}}/",
          dismissible: false,
          onPress: () async {
            Navigator.pop(context);
            final Map<Permission, PermissionStatus> statuses = await [
              Permission.storage,
            ].request();
            if (statuses[Permission.storage] == PermissionStatus.granted) {
              return c.complete();
            } else {
              Navigator.pop(context);
              return c.completeError("storage permission must be accepted to download the file");
            }
          });
    } else {
      return c.complete();
    }
    return c.future;
  }
}
