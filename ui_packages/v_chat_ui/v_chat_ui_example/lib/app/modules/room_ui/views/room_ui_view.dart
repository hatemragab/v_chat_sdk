import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_ui/v_chat_ui.dart';

import '../controllers/room_ui_controller.dart';

class RoomUiView extends GetView<RoomUiController> {
  const RoomUiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VRoomPage(
      controller: controller.roomController,
      appBar: AppBar(
        title: const Text('Room Ui View'),
        centerTitle: true,
      ),
    );
  }
}
