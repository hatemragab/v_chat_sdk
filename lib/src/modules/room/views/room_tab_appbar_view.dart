import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textless/textless.dart';
import '../../../utils/custom_widgets/popup_item.dart';
import '../../create_single_chat/bindings/create_single_chat_binding.dart';
import '../../create_single_chat/views/create_single_chat_view.dart';
import '../controllers/rooms_controller.dart';

class RoomTabAppBarView extends GetView<RoomController>
    implements PreferredSizeWidget {
  const RoomTabAppBarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: 'All Chats '.text,
      actions: [
        PopupMenuButton(
          child: const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.chat ),
          ),
          itemBuilder: (context) {
            return [
              PopupItem(
                child: Row(
                  children: [
                    const Icon(Icons.person,color: Colors.black),
                    const SizedBox(
                      width: 5,
                    ),
                    "Single Chat".text,
                  ],
                ),
                flag: 1,
                onDone: (f) {
                  CreateSingleChatBinding.bind();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateSingleChatView(),
                      ));
                },
              ),
              // PopupItem(
              //   child: Row(
              //     children: [
              //       Icon(Icons.group ,color: Colors.black),
              //       const SizedBox(
              //         width: 5,
              //       ),
              //       "Group Chat".text,
              //     ],
              //   ),
              //   flag: 2,
              //   onTap: (f) {
              //     //Get.toNamed(Routes.SELECT_GROUP_CHAT_MEMBERS);
              //   },
              // ),
            ];
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
