import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textless/textless.dart';
import 'package:v_chat_sdk/src/utils/custom_widgets/auto_direction.dart';
import '../../../../enums/room_type.dart';
import '../../../../enums/room_typing_type.dart';
import '../../../../models/v_chat_room.dart';
import '../../../../services/v_chat_app_service.dart';
import '../../../../utils/custom_widgets/circle_image.dart';
import '../../../../utils/custom_widgets/custom_alert_dialog.dart';
import '../../../../utils/custom_widgets/sheet_action/custom_vertical_sheet_item.dart';
import '../../../../utils/custom_widgets/sheet_action/sheet_vertical_item.dart';
import '../../../message/bindings/message_binding.dart';
import '../../../message/views/message_view.dart';
import '../../controllers/rooms_controller.dart';
import 'message_with_icon.dart';

class RoomItem extends StatelessWidget {
  final VChatRoom _room;

  const RoomItem(this._room);

  @override
  Widget build(BuildContext context) {
    final t = VChatAppService.to.getTrans(context);
    return InkWell(
      onTap: () {
        Get.find<RoomController>().currentRoomId = _room.id;
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
        final isMyBlock = _room.blockerId == VChatAppService.to.vChatUser!.id;

        final res = await CustomVerticalSheetItem.normal(context, [
          CustomSheetModel(
            value: 1,
            text: _room.isMute == 1
                ? t.enableNotification()
                : t.muteNotification(),
            iconData: _room.isMute == 1
                ? Icons.notifications
                : Icons.notifications_off,
          ),
          _room.roomType == RoomType.single
              ? CustomSheetModel(
                  value: 2,
                  text: isMyBlock ? t.openChat() : t.closeChat(),
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
              message: t.areYouSure(), context: context);
          if (res == 1) {
            Get.find<RoomController>().muteAction(_room);
          }
        } else if (res == 2) {
          final res = await CustomAlert.customAskDialog(
              message: t.areYouSure(), context: context);
          if (res == 1) {
            Get.find<RoomController>().blockOrLeaveAction(_room);
          }
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CircleImage.network(
              path: _room.thumbImage,
              isOnline: _room.isOnline == 1,
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
                            .maxLine(1)
                            .alignStart
                            .overflowEllipsis,
                      ),
                    ),
                    _room.lastMessage.createdAtString.toString().s2
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (context) {
                        final tSt = _room.typingStatus;
                        if (tSt.status != RoomTypingType.stop) {
                          final txt = "${tSt.status.inString} ...";
                          if (_room.roomType == RoomType.single) {
                            if (tSt.status == RoomTypingType.typing) {
                              return t.typing().text;
                            }
                            if (tSt.status == RoomTypingType.recording) {
                              return t.recording().text;
                            }

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
                    _room.isMute == 1
                        ? const Icon(Icons.notifications_off)
                        : const SizedBox.shrink()
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
