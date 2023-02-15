// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

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
    // OnlineOfflineService.clean();
  }

  @override
  void onSocketDisconnect() {
    // OnlineOfflineService.clean();
  }
}
