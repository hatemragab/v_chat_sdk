// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class VDownloaderService {
  VDownloaderService._();

  // final _downloadQueue = <VBaseMessage>[];

  static final instance = VDownloaderService._();

  Future<String> addToQueue(VBaseMessage message) async {
    if (message is VFileMessage) {
      return _startDownload(message.data.fileSource);
      // _downloadQueue.removeWhere((e) => e.localId == message.localId);
    } else if (message is VVoiceMessage) {
      return _startDownload(message.data.fileSource);
    }
    return "";
    // if (!_downloadQueue.contains(message)) {
    //   _downloadQueue.add(message);
    //   if (message is VFileMessage) {
    //     await _startDownload(message.data.fileSource);
    //     _downloadQueue.removeWhere((e) => e.localId == message.localId);
    //   }
    // }
  }

  Future<String> _startDownload(VPlatformFileSource source) async {
    return await VFileUtils.saveFileToPublicPath(
      fileAttachment: source,
      appName: VAppConstants.appName,
    );
  }
}
