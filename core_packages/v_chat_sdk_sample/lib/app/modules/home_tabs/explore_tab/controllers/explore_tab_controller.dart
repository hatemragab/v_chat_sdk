// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_sdk_sample/app/routes/app_pages.dart';

class ExploreTabController extends GetxController {
  // final ProductRepository repository;
  int txt = 0;
  late StreamSubscription totalUnreadMessageCountStream;

  // ExploreTabController(this.repository);
  @override
  void onInit() {
    super.onInit();
    totalUnreadMessageCountStream = VChatController
        .I.nativeApi.streams.totalUnreadMessageCountStream
        .listen((event) {
      txt = event.count;
      update();
      print(event.toString());
    });
  }

  @override
  void onClose() {
    super.onClose();
    totalUnreadMessageCountStream.cancel();
  }

  void onCreateProduct() {
    Get.toNamed(Routes.CREATE_PRODUCT);
  }
}
