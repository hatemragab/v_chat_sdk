import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textless/textless.dart';
import '../../../../enums/room_type.dart';
import '../../../../enums/room_typing_type.dart';
import '../../../../models/vchat_room.dart';
import '../../../../services/vchat_app_service.dart';
import '../../../../utils/custom_widgets/circle_image.dart';
import '../../../../utils/custom_widgets/custom_alert_dialog.dart';
import '../../../../utils/custom_widgets/sheet_action/custom_vertical_sheet_item.dart';
import '../../../../utils/custom_widgets/sheet_action/sheet_vertical_item.dart';
import '../../../message/bindings/message_binding.dart';
import '../../../message/views/message_view.dart';
import '../../controllers/rooms_controller.dart';
import 'message_with_icon.dart';

class RoomItem extends StatelessWidget {
  final VchatRoom _room;

  RoomItem(this._room);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.find<RoomController>().currentRoom = _room;
        MessageBinding.bind();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessageView(),
          ),
        );
        //Get.toNamed(Routes.MESSAGE);
      },
      onLongPress: () async {
        final isMyBlock =
            _room.blockerId.value == VChatAppService.to.vChatUser!.id;

        final res = await CustomVerticalSheetItem.normal(context, [
          CustomSheetModel(
            value: 1,
            text: _room.isMute.value == 1
                ? "enable notification"
                : "mute notification",
            iconData: _room.isMute.value == 1
                ? Icons.notifications
                : Icons.notifications_off,
          ),
          _room.roomType == RoomType.single
              ? CustomSheetModel(
                  value: 2,
                  text: isMyBlock ? "Open chat" : "Close chat",
                  iconData: Icons.block,
                )
              : CustomSheetModel(
                  value: 2,
                  text: "leave",
                  iconData: Icons.exit_to_app,
                ),
        ]);
        if (res == 1) {
          final res = await CustomAlert.customAskDialog(
              message: "Are you sure", context: context);
          if (res == 1) {
            Get.find<RoomController>().muteAction(_room);
          }
        } else if (res == 2) {
          final res = await CustomAlert.customAskDialog(
              message: "Are you sure", context: context);
          if (res == 1) {
            Get.find<RoomController>().blockOrLeaveAction(_room);
          }
        }
      },
      child: Obx(
        () => Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircleImage.network(
                path: _room.thumbImage,
                isOnline: _room.isOnline.value == 1,
                isGroup: _room.roomType == RoomType.groupChat),
            const SizedBox(
              width: 15,
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: AutoDirection(
                          text: _room.title,
                          child: _room.title
                              .toString()
                              .h6
                              .size(18)
                              .maxLine(1)
                              .alignStart
                              .overflowEllipsis,
                        ),
                      ),
                      _room.lastMessage.value.createdAtString.toString().s2
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () {
                          final tSt = _room.typingStatus.value;
                          if (tSt.status != RoomTypingType.stop) {
                            final txt = "${tSt.status.inString} ...";
                            if (_room.roomType == RoomType.single) {
                              return txt.text;
                            } else {
                              return "${tSt.name} is $txt".text;
                            }
                          } else {
                            return Flexible(
                              child: MessageWithIcon(_room),
                            );
                          }
                        },
                      ),
                      Obx(() {
                        final x = _room.isMute.value;
                        if (x == 1) {
                          return const Icon(Icons.notifications_off);
                        } else {
                          return const SizedBox.shrink();
                        }
                      })
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
