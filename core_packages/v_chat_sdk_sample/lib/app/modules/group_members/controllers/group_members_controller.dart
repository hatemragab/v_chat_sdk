// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_sdk_sample/app/v_chat/v_enums.dart';

import '../../../v_chat/v_safe_api_call.dart';

class GroupMembersController extends GetxController {
  final VToChatSettingsModel data;
  VChatLoadingState loadingState = VChatLoadingState.ideal;
  final members = <VGroupMember>[];

  GroupMembersController(this.data);

  @override
  void onInit() {
    _getMembers();
    super.onInit();
  }

  void _getMembers() async {
    await vSafeApiCall<List<VGroupMember>>(
      onLoading: () {
        loadingState = VChatLoadingState.loading;
      },
      request: () async {
        return VChatController.I.nativeApi.remote.room
            .getGroupMembers(data.roomId);
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
