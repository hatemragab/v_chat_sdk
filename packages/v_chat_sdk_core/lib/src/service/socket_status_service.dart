import 'package:v_chat_sdk_core/src/utils/stream_utils.dart';
import 'package:v_chat_sdk_core/src/v_chat_controller.dart';

import 'online_offline_service.dart';

class SocketStatusService with VSocketStatusStream {
  SocketStatusService() {
    initSocketStatusStream(
      VChatController.I.nativeApi.remote.socketIo.socketStatusStream,
    );
  }

  close() {
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
