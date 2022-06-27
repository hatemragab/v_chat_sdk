import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:textless/textless.dart';
import 'package:v_chat_sdk/src/enums/room_type.dart';
import 'package:v_chat_sdk/src/enums/room_typing_type.dart';
import 'package:v_chat_sdk/src/models/v_chat_room.dart';
import 'package:v_chat_sdk/src/modules/message/views/message_view.dart';
import 'package:v_chat_sdk/src/modules/rooms/cubit/room_cubit.dart';
import 'package:v_chat_sdk/src/modules/rooms/widgets/message_with_icon.dart';
import 'package:v_chat_sdk/src/services/v_chat_app_service.dart';
import 'package:v_chat_sdk/src/utils/custom_widgets/auto_direction.dart';
import 'package:v_chat_sdk/src/utils/custom_widgets/circle_image.dart';
import 'package:v_chat_sdk/src/utils/custom_widgets/custom_alert_dialog.dart';
import 'package:v_chat_sdk/src/utils/custom_widgets/sheet_action/custom_vertical_sheet_item.dart';
import 'package:v_chat_sdk/src/utils/custom_widgets/sheet_action/sheet_vertical_item.dart';

class RoomItem extends StatelessWidget {
  final VChatRoom _room;

  const RoomItem(this._room, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = VChatAppService.instance.getTrans(context);
    return InkWell(
      onTap: () {
        RoomCubit.instance.currentRoomId = _room.id;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessageView(
              roomId: _room.id,
            ),
          ),
        );
        //Get.toNamed(Routes.MESSAGE);
      },
      onLongPress: () async {
        final isMyBlock =
            _room.blockerId == VChatAppService.instance.vChatUser!.id;

        final data = [
          CustomSheetModel(
            value: 1,
            text: _room.isMute == 1
                ? t.enableNotification()
                : t.muteNotification(),
            iconData: _room.isMute == 1
                ? Icons.notifications
                : Icons.notifications_off,
          ),
        ];
        final bool isSingle = _room.roomType == RoomType.single;
        if (isSingle) {
          data.add(
            CustomSheetModel(
              value: 2,
              text: isMyBlock ? t.unBlockUser() : t.blockUser(),
              iconData: Icons.block,
            ),
          );
        } else {
          data.add(
            CustomSheetModel(
              value: 2,

              /// todo support language
              text: t.leave(),
              iconData: Icons.exit_to_app,
            ),
          );
        }
        final res = await CustomVerticalSheetItem.normal(context, data);

        if (res == 1) {
          final res = await CustomAlert.customAskDialog(
            title: t.areYouSure(),
            context: context,
          );
          if (res == 1) {
            context.read<RoomCubit>().muteAction(context, _room);
          }
        } else if (res == 2) {
          /// todo support language
          final res = await CustomAlert.customAskDialog(
            title: isSingle
                ? t.areYouSure()
                : t.areYouSureToLeaveAndDeleteAllConversionData(),
            context: context,
          );
          if (res == 1) {
            context.read<RoomCubit>().blockOrLeaveAction(context, _room);
          }
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CircleImage.network(
            path: _room.thumbImage,
            isOnline: _room.isOnline == 1,
            isGroup: _room.roomType == RoomType.groupChat,
          ),
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
                    ///chat title
                    Flexible(
                      child: AutoDirection(
                        text: _room.title,
                        child: _room.title.h6
                            .maxLine(1)
                            .alignStart
                            .overflowEllipsis,
                      ),
                    ),
                    _room.lastMessage.createdAtString.b2
                  ],
                ),

                ///chat message
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
                              return t.typing().text.color(Colors.green);
                            }
                            if (tSt.status == RoomTypingType.recording) {
                              return t.recording().text.color(Colors.green);
                            }
                            return txt.text;
                          } else {
                            return "${tSt.name} is $txt"
                                .text
                                .color(Colors.green);
                          }
                        } else {
                          return Flexible(
                            child: MessageWithIcon(_room),
                          );
                        }
                      },
                    ),
                    if (_room.isMute == 1)
                      const Icon(Icons.notifications_off)
                    else
                      const SizedBox.shrink()
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
