// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../../core/user_filter_dto.dart';

class UsersTabController extends GetxController {
  VChatLoadingState loadingState = VChatLoadingState.ideal;
  final _data = <VIdentifierUser>[];

  List<VIdentifierUser> get data => _data;
  final _filterDto = UserFilterDto(
    limit: 30,
    page: 1,
  );

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  Future<void> getData() async {
    await vSafeApiCall<List<VIdentifierUser>>(
      onLoading: () async {},
      onError: (exception, trace) {
        VAppAlert.showOverlaySupport(title: exception);
      },
      request: () async {
        return await VChatController.I.nativeApi.remote.profile
            .appUsers(_filterDto.toMap());
      },
      onSuccess: (response) {
        loadingState = VChatLoadingState.success;
        data.addAll(response);
        update();
      },
      ignoreTimeoutAndNoInternet: true,
    );
  }

  void onCreateGroupOrBroadcast() async {
    final res = await VAppAlert.showAskListDialog(
      title: "Create Group or Broadcast?",
      context: Get.context!,
      content: ["Group", "Broadcast"],
    );
    print(res);
  }

  Future onItemPress(VIdentifierUser item) async {
    await VChatController.I.roomApi
        .openChatWith(peerIdentifier: item.identifier);
  }
}
