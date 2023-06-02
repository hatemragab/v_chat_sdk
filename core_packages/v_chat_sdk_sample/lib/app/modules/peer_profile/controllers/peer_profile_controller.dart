// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../core/enums.dart';
import '../../../core/models/user.model.dart';

class PeerProfileController extends GetxController {
  final String uuId;
  // final UserRepository repository;
  late UserModel peerData;

  PeerProfileController(
    this.uuId,
  );

  final apiCallStatus = ApiCallStatus.holding.obs;

  @override
  void onInit() {
    getUser();
    super.onInit();
  }

  Future getUser() async {
    // await vSafeApiCall<UserModel>(
    //   onLoading: () {
    //     apiCallStatus.value = ApiCallStatus.loading;
    //   },
    //   request: () {
    //     // return repository.getId(uuId);
    //   },
    //   onSuccess: (response) {
    //     apiCallStatus.value = ApiCallStatus.success;
    //     peerData = response;
    //   },
    //   onError: (exception, trace) {
    //     apiCallStatus.value = ApiCallStatus.error;
    //     print(exception);
    //   },
    // );
  }

  void onStartChat() async {
    await vSafeApiCall<VRoom>(
      request: () {
        return VChatController.I.roomApi.getPeerRoom(peerIdentifier: uuId);
      },
      onSuccess: (response) {
        VChatController.I.vNavigator.messageNavigator.toMessagePage(
          Get.context!,
          response,
        );
      },
    );
  }
}
