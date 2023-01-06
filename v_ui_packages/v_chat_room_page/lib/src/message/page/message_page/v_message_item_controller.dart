import 'package:flutter/material.dart';
import 'package:v_chat_room_page/src/message/page/message_status/message_status_page.dart';
import 'package:v_chat_room_page/src/room/pages/choose_rooms/choose_rooms_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../core/enums.dart';

//todo trans
class VMessageItemController {
  void onMessageItemPress(BuildContext context, VBaseMessage message) async {}

  void onMessageItemLongPress(
    BuildContext context,
    VBaseMessage message,
    VRoom room,
    Function(VBaseMessage p1) onSwipe,
  ) async {
    FocusScope.of(context).unfocus();
    final items = <ModelSheetItem<VMessageItemClickRes>>[];
    if (message.messageStatus.isServerConfirm) {
      items.add(
        ModelSheetItem(
          id: VMessageItemClickRes.forward,
          title: "Forward",
          iconData: Icon(Icons.forward),
        ),
      );
      items.add(
        ModelSheetItem(
          id: VMessageItemClickRes.reply,
          title: "Reply",
          iconData: Icon(Icons.replay),
        ),
      );
      items.add(
        ModelSheetItem(
          id: VMessageItemClickRes.share,
          title: "Share",
          iconData: Icon(Icons.share),
        ),
      );
      if (message.isMeSender) {
        items.add(
          ModelSheetItem(
            id: VMessageItemClickRes.info,
            title: "Info",
            iconData: Icon(Icons.info),
          ),
        );
      }
    }
    items.add(
      ModelSheetItem(
        id: VMessageItemClickRes.delete,
        title: "Delete",
        iconData: Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
    );
    if (message.messageType.isText) {
      items.add(
        ModelSheetItem(
            id: VMessageItemClickRes.copy,
            title: "Copy",
            iconData: Icon(Icons.copy)),
      );
    }
    final res = await VAppAlert.showModalSheet(
      content: items,
      context: context,
    );
    if (res == null) return;
    switch (res.id as VMessageItemClickRes) {
      case VMessageItemClickRes.forward:
        _handleForward(context, message.roomId);
        break;
      case VMessageItemClickRes.reply:
        onSwipe(message);
        break;
      case VMessageItemClickRes.share:
        _handleShare(context, message);
        break;
      case VMessageItemClickRes.info:
        _handleInfo(context, message, room);
        break;
      case VMessageItemClickRes.delete:
        _handleDelete(context, message);
        break;
      case VMessageItemClickRes.copy:
        _handleCopy(context, message);
        break;
    }
  }

  Future onLinkPress(String link) async {
    await VStringUtils.lunchLink(link);
  }

  Future onEmailPress(String email) async {
    await VStringUtils.lunchLink(email);
  }

  Future onPhonePress(String phone) async {
    await VStringUtils.lunchLink(phone);
  }

  void _handleForward(BuildContext context, String roomId) async {
    final res = await context.toPage(
      ChooseRoomsPage(
        currentRoomId: roomId,
      ),
    );
  }

  void _handleShare(BuildContext context, VBaseMessage message) {}

  void _handleInfo(BuildContext context, VBaseMessage message, VRoom room) {
    FocusScope.of(context).unfocus();
    context.toPage(MessageStatusPage(
      message: message,
      roomType: room.roomType,
    ));
  }

  void _handleDelete(BuildContext context, VBaseMessage message) {}

  void _handleCopy(BuildContext context, VBaseMessage message) {}
}
