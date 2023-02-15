// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../routes/app_pages.dart';

class BroadcastSettingsController extends GetxController {
  final VToChatSettingsModel data;

  BroadcastSettingsController(this.data);

  void toShowMembers() {
    Get.toNamed(Routes.BROADCAST_MEMBERS, arguments: data);
  }
}
