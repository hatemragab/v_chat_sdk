import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textless/textless.dart';
import 'package:v_chat_sdk/src/services/vchat_app_service.dart';
import '../../../../v_chat_sdk.dart';
import '../../../enums/room_type.dart';
import '../../../enums/room_typing_type.dart';
import '../../../utils/custom_widgets/circle_image.dart';
import '../../../utils/custom_widgets/rounded_container.dart';
import '../../room/controllers/rooms_controller.dart';
import '../controllers/message_controller.dart';

class MessageAppBarView extends GetView<MessageController>
    implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    final _room = controller.currentRoom!;
    return AppBar(
      elevation: 1,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: InkWell(
        onTap: () => controller.goBack(context),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.arrow_back_ios),
            Obx(() {
              final count =
                  Get.find<RoomController>().totalUnreadMessages.value;
              if (count != 0) {
                return Positioned(
                    top: 6,
                    right: 15,
                    child: RoundedContainer(
                      child: "$count".text.color(Colors.white),
                      height: 18,
                      width: 18,
                      color: Colors.red,
                      boxShape: BoxShape.circle,
                    ));
              } else {
                return const SizedBox.shrink();
              }
            }),
          ],
        ),
      ),
      title: Column(
        children: [
          controller.currentRoom!.title.text,
          Obx(() {
            final isOnline = _room.isOnline.value;
            final typingSt = _room.typingStatus.value;
            final isSingle = _room.roomType == RoomType.single;
            if (isSingle) {
              if (typingSt.status != RoomTypingType.stop) {
                return "${typingSt.status.inString} ...".cap.size(14);
              }
              if (isOnline == 1) {
                return "Online".cap.size(14);
              } else {
                return VChatAppService.to.getTrans(context).test().cap.size(14);
              }
            } else {
              if (typingSt.status != RoomTypingType.stop) {
                return "${typingSt.name} is ${typingSt.status.inString} ..."
                    .cap
                    .size(14);
              } else {
                return const SizedBox();
              }
            }
          }),

          // "last seen at 4 hour ago".cap
        ],
      ),
      actions: [
        Center(
          child: Obx(() {
            return Padding(
              padding: const EdgeInsets.only(right: 5),
              child: InkWell(
                onTap: () {
                  if (_room.roomType == RoomType.groupChat) {
                    // Get.toNamed(Routes.GROUP_CHAT_INFO);
                  } else {
                    // Get.toNamed(Routes.PEER_PROFILE,
                    //     arguments: controller.currentRoom!.ifSinglePeerId);
                  }
                },
                child: CircleImage.network(
                    path: controller.currentRoom!.thumbImage,
                    width: 45,
                    height: 45,
                    isOnline: controller.currentRoom!.isOnline.value == 1),
              ),
            );
          }),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
