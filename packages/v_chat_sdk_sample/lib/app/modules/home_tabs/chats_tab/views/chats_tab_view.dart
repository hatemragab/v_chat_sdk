import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_ui/v_chat_ui.dart';

import '../controllers/chats_tab_controller.dart';

class ChatsTabView extends GetView<ChatsTabController> {
  const ChatsTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: controller.onCreateGroupOrBroadcast,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Chats Tab View'),
        centerTitle: true,
      ),
      body: VRoomBody(
        controller: controller.vRoomController,
      ),
    );
  }
}
