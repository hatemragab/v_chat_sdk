import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class VDownloaderService {
  VDownloaderService._();

  final _downloadQueue = <VBaseMessage>[];

  static final instance = VDownloaderService._();

  void addToQueue(VBaseMessage message) {
    if (!_downloadQueue.contains(message)) {
      _downloadQueue.add(message);
      _startDownload();
    }
  }

  void _startDownload() async {
    // VFileUtils.safeToPublicPath(
    //   fileAttachment: fileAttachment,
    //   appName: appName,
    // );
  }
}
