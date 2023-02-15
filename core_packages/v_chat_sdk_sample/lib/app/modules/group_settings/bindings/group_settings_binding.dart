// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../controllers/group_settings_controller.dart';

class GroupSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<GroupSettingsController>(
      GroupSettingsController(Get.arguments as VToChatSettingsModel),
    );
  }
}
