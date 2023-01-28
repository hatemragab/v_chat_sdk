import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_room_page/v_chat_room_page.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../controllers/chats_tab_controller.dart';
import '../web_chat_scaffold.dart';

class ChatsTabView extends GetView<ChatsTabController> {
  ChatsTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (VPlatforms.isWeb) {
      return Scaffold(
        body: Row(
          children: [
            SizedBox(
              width: 300,
              child: VChatPage(
                context: navigator == null ? context : navigator!.context,
                appBar: AppBar(
                  title: Text("start chat"),
                ),
                controller: controller.vRoomController,
                useIconForRoomItem: false,
                onRoomItemPress: (room) {
                  controller.vRoomController.setRoomSelected(room.id);
                  vWebChatNavigation.key.currentState!
                      .pushReplacementNamed(ChatRoute.route, arguments: room);
                },
              ),
            ),
            Container(
              width: 5,
              color: Colors.black12,
            ),
            Flexible(
              child: Navigator(
                key: vWebChatNavigation.key,
                onGenerateRoute: vWebChatNavigation.onGenerateRoute,
                initialRoute: IdleRoute.route,
              ),
            )
          ],
        ),
      );
    }
    return VChatPage(
      context: context,
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
