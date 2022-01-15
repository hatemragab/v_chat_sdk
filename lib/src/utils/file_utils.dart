import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';

import '../models/v_chat_message_attachment.dart';
import '../services/v_chat_app_service.dart';
import 'custom_widgets/custom_alert_dialog.dart';
import 'v_chat_config.dart';

class FileUtils {
  FileUtils._();

  static Future newDownloadFile(
    BuildContext context,
    VChatMessageAttachment attachment,
  ) async {
    try {
      final html.AnchorElement anchorElement =
          html.AnchorElement(href: attachment.playUrl.toString());
      anchorElement.download = attachment.playUrl.toString();
      anchorElement.click();
    } catch (err) {
      CustomAlert.customAlertDialog(
        errorMessage: err.toString(),
        context: context,
      );
      rethrow;
    }
  }

  static Future<File> compressImage(File file) async {
    final properties = decodeJpg(file.readAsBytesSync());

    File compressedFile = file;
    if (file.lengthSync() > 1024 * 1000) {
      // compress only images bigger than 1 mb
      final compressedImage = copyResize(
        properties!,
        width: 700,
        height: (properties.height * 700 / properties.width).round(),
      );

      // Save the thumbnail as a PNG.
     // File('out/thumbnail-test.png').writeAsBytesSync(encodePng(thumbnail));
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

  // static Future<File> getVideoThumb(File file) async {
  //   final String fileName =
  //       "IMG_THUMB_${DateTime.now().microsecondsSinceEpoch}.png";
  //   final newFile = File("$t$fileName");
  //   return newFile.writeAsBytes(uint8list!);
  // }

  static Future<String> getVideoDuration(String path) async {
    final VideoPlayerController controller =
        VideoPlayerController.file(File(path));
    await controller.initialize();
    final duration = controller.value.duration.toString();
    controller.dispose();
    return duration;
  }

  static Future<dynamic> uploadFile(
    List<File> files,
    String endPoint, {
    Map<String, String>? body,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${VChatConfig.serverBaseUrl}$endPoint'),
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

    request.headers.addAll({
      "authorization":
          "Bearer ${VChatAppService.instance.vChatUser!.accessToken}",
      "Accept-Language": VChatAppService.instance.currentLocal
    });
    if (body != null) {
      request.fields.addAll(body);
    }
    final stream = await request.send();
    final responseData = await stream.stream.toBytes();
    final responseString = String.fromCharCodes(responseData);
    return jsonDecode(responseString)['data'];
  }
}
