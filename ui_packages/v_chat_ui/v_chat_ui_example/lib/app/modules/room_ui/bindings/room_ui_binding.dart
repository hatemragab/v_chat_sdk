import 'package:get/get.dart';

import '../controllers/room_ui_controller.dart';

class RoomUiBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<RoomUiController>(
      RoomUiController(),
    );
  }
}
