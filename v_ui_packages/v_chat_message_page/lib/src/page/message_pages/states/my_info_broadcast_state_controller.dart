// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_message_page/src/page/message_pages/states/app_bar_state_controller.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class MyInfoBroadcastStateController {
  final VRoom room;
  final String _cacheKey = "broadcast-info-";
  VMyBroadcastInfo value = VMyBroadcastInfo.empty();

  MyInfoBroadcastStateController(this.room, this.appBarStateController) {
    _getFromCache();
    updateFromRemote();
  }

  final AppBarStateController appBarStateController;

  void updateValue(VMyBroadcastInfo value) {
    this.value = value;
    appBarStateController.setMemberCount(value.totalUsers);
  }

  Future<void> _getFromCache() async {
    final res = VAppPref.getMap("$_cacheKey${room.id}");
    if (res == null) return;
    updateValue(VMyBroadcastInfo.fromMap(res));
  }

  Future<void> updateFromRemote() async {
    await vSafeApiCall<VMyBroadcastInfo>(
      request: () {
        return VChatController.I.roomApi.getBroadcastMyInfo(roomId: room.id);
      },
      onSuccess: (response) async {
        updateValue(response);
        await VAppPref.setMap("$_cacheKey${room.id}", response.toMap());
      },
    );
  }
}
