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
  ) async {
    FocusScope.of(context).unfocus();
    final items = <ModelSheetItem<MessageItemClickRes>>[];
    if (message.messageStatus.isServerConfirm) {
      items.add(
        ModelSheetItem(
          id: MessageItemClickRes.forward,
          title: "Forward",
          iconData: Icons.forward,
        ),
      );
      items.add(
        ModelSheetItem(
          id: MessageItemClickRes.reply,
          title: "Reply",
          iconData: Icons.replay,
        ),
      );
      items.add(
        ModelSheetItem(
          id: MessageItemClickRes.share,
          title: "Share",
          iconData: Icons.share,
        ),
      );
      if (message.isMeSender) {
        items.add(
          ModelSheetItem(
            id: MessageItemClickRes.info,
            title: "Info",
            iconData: Icons.info,
          ),
        );
      }
    }
    items.add(
      ModelSheetItem(
        id: MessageItemClickRes.delete,
        title: "Delete",
        iconData: Icons.delete,
      ),
    );
    if (message.messageType.isText) {
      items.add(
        ModelSheetItem(
            id: MessageItemClickRes.copy, title: "Copy", iconData: Icons.copy),
      );
    }
    final res = await VAppAlert.showModalSheet(
      content: items,
      context: context,
    );
    if (res == null) return;
    switch (res.id as MessageItemClickRes) {
      case MessageItemClickRes.forward:
        _handleForward(context, message.roomId);
        break;
      case MessageItemClickRes.reply:
        _handleReply(context, message);
        break;
      case MessageItemClickRes.share:
        _handleShare(context, message);
        break;
      case MessageItemClickRes.info:
        _handleInfo(context, message, room);
        break;
      case MessageItemClickRes.delete:
        _handleDelete(context, message);
        break;
      case MessageItemClickRes.copy:
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

  void _handleReply(BuildContext context, VBaseMessage message) {}

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
