// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_message_page/src/page/message_pages/states/app_bar_state_controller.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import 'input_state_controller.dart';

class MyInfoGroupStateController {
  final VRoom room;
  final String _cacheKey = "group-info-";
  VMyGroupInfo value = VMyGroupInfo.empty();

  MyInfoGroupStateController(
      this.inputStateController, this.room, this.appBarStateController) {
    _getFromCache();
    updateFromRemote();
  }

  final InputStateController inputStateController;
  final AppBarStateController appBarStateController;

  void updateValue(VMyGroupInfo value) {
    this.value = value;
    appBarStateController.setMemberCount(value.membersCount);
    if (value.isMeOut) {
      inputStateController.closeChat();
    } else {
      inputStateController.openChat();
    }
  }

  Future<void> _getFromCache() async {
    final res = VAppPref.getMap("$_cacheKey${room.id}");
    if (res == null) return;
    updateValue(VMyGroupInfo.fromMap(res));
  }

  Future<void> updateFromRemote() async {
    await vSafeApiCall<VMyGroupInfo>(
      request: () {
        return VChatController.I.roomApi.getGroupVMyGroupInfo(roomId: room.id);
      },
      onSuccess: (response) async {
        updateValue(response);
        await VAppPref.setMap("$_cacheKey${room.id}", response.toMap());
      },
    );
  }
}
