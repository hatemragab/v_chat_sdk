import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';
import 'package:v_chat_room_page/v_chat_room_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

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
      onRoomItemPress: (room) {
        context.toPage(VMessagePage(
          vRoom: room,
          onAppBarTitlePress: (id, roomType) {
            switch (roomType) {
              case VRoomType.s:

                ///single room the id is the user identifier
                break;
              case VRoomType.g:

                ///group room the id is the group id
                break;
              case VRoomType.b:

                ///broadcast room the id is the broadcast id
                break;
              case VRoomType.o:
                // TODO: Handle this case.
                break;
            }
          },
          onMentionPress: (identifier) {},
          googleMapsApiKey: "test",
        ));
      },
    );
  }
}
