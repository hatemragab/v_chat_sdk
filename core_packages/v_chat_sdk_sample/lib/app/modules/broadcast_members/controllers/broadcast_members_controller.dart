// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class BroadcastMembersController extends GetxController {
  final VToChatSettingsModel data;
  VChatLoadingState loadingState = VChatLoadingState.ideal;
  final members = <VBroadcastMember>[];

  BroadcastMembersController(this.data);

  @override
  void onInit() {
    getMembers();
    super.onInit();
  }

  void getMembers() async {
    await vSafeApiCall<List<VBroadcastMember>>(
      onLoading: () {
        loadingState = VChatLoadingState.loading;
      },
      request: () async {
        return VChatController.I.nativeApi.remote.room
            .getBroadcastMembers(roomId: data.roomId);
      },
      onSuccess: (response) {
        members.addAll(response);
        loadingState = VChatLoadingState.success;
        update();
      },
      onError: (exception, trace) {
        loadingState = VChatLoadingState.error;
        update();
      },
    );
  }
}
