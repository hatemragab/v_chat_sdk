// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import 'input_state_controller.dart';

class BlockStateController {
  final VRoom room;
  VCheckBanModel value =
      const VCheckBanModel(isMeBanner: false, isPeerBanner: false);

  BlockStateController(this.inputStateController, this.room) {
    _getFromCache();
    updateFromRemote();
  }

  final InputStateController inputStateController;

  void updateValue(VCheckBanModel value) {
    this.value = value;
    if (value.isThereBan) {
      inputStateController.closeChat();
    } else {
      inputStateController.openChat();
    }
  }

  Future<void> _getFromCache() async {
    final res = VAppPref.getMap("ban-${room.id}");
    if (res == null) return;
    updateValue(VCheckBanModel.fromMap(res));
  }

  Future<void> updateFromRemote() async {
    if (room.roomType.isSingleOrOrder) {
      await vSafeApiCall<VCheckBanModel>(
        request: () {
          return VChatController.I.blockApi
              .checkIfThereBan(peerIdentifier: room.peerIdentifier!);
        },
        onSuccess: (response) async {
          updateValue(response);
          await VAppPref.setMap("ban-${room.id}", response.toMap());
        },
      );
    }
  }
}
