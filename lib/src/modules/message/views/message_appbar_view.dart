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
  final roomController = Get.find<RoomController>();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 1,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
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
      title: Obx(() {
        final _room =
            roomController.rooms.firstWhere((element) => element.id == roomController.currentRoomId!);

        return Column(
          children: [
            _room.title.text,
            Builder(
              builder: (_) {
                final isOnline = _room.isOnline;
                final typingSt = _room.typingStatus;
                final isSingle = _room.roomType == RoomType.single;
                final t = VChatAppService.to.getTrans(context);
                if (isSingle) {
                  if (typingSt.status != RoomTypingType.stop) {
                    if (typingSt.status == RoomTypingType.typing) {
                      return t.typing().cap.size(14);
                    }
                    if (typingSt.status == RoomTypingType.recording) {
                      return t.recording().cap.size(14);
                    }
                    return "${typingSt.status.inString} ...".cap.size(14);
                  }
                  if (isOnline == 1) {
                    return t.online().cap.size(14);
                  } else {
                    return VChatAppService.to
                        .getTrans(context)
                        .offline()
                        .cap
                        .size(14);
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
              },
            ),
          ],
        );
      }),
      actions: [
        Center(
          child: Obx(() {
            final _room =
                roomController.rooms.firstWhere((element) => element.id == roomController.currentRoomId!);
            return Padding(
              padding: const EdgeInsets.only(right: 5),
              child: InkWell(
                onTap: () {
                  //todo call back when icon clicked
                },
                child: CircleImage.network(
                    path: _room.thumbImage,
                    radius: 25,
                    isOnline: _room.isOnline == 1),
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
