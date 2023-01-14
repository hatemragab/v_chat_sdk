import 'package:v_chat_sdk_core/src/service/online_offline_service.dart';
import 'package:v_chat_sdk_core/src/utils/stream_utils.dart';
import 'package:v_chat_sdk_core/src/v_chat_controller.dart';

class SocketStatusService with VSocketStatusStream {
  SocketStatusService() {
    initSocketStatusStream(
      VChatController.I.nativeApi.streams.socketStatusStream,
    );
  }

  void close() {
    closeSocketStatusStream();
  }

  @override
  void onSocketConnected() {
    OnlineOfflineService.clean();
  }

  @override
  void onSocketDisconnect() {
    OnlineOfflineService.clean();
  }
}
