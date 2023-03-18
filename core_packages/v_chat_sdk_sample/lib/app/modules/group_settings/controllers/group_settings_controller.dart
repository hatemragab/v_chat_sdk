// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_sdk_sample/app/routes/app_pages.dart';

class GroupSettingsController extends GetxController {
  final VToChatSettingsModel data;

  GroupSettingsController(this.data);

  void toShowMembers() {
    Get.toNamed(Routes.GROUP_MEMBERS, arguments: data);
  }

  void leave() async {
    await VChatController.I.roomApi.leaveGroup(roomId: data.roomId);
  }
}
