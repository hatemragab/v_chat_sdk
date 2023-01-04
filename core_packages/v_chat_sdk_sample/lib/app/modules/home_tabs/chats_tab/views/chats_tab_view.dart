import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_room_page/v_chat_room_page.dart';

import '../controllers/chats_tab_controller.dart';

class ChatsTabView extends GetView<ChatsTabController> {
  const ChatsTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VChatPage(
      appBar: AppBar(
        title: const Text('Chats Tab View'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.onCreateGroupOrBroadcast,
        child: const Icon(Icons.add),
      ),
      controller: controller.vRoomController,
    );
  }
}
