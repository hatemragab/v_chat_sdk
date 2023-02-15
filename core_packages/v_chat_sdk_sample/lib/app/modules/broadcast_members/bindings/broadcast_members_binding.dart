// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:get/get.dart';

import '../controllers/broadcast_members_controller.dart';

class BroadcastMembersBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<BroadcastMembersController>(
      BroadcastMembersController(Get.arguments),
    );
  }
}
