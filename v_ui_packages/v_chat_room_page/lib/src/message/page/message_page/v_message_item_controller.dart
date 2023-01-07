import 'package:flutter/material.dart';
import 'package:v_chat_room_page/src/message/page/message_status/message_status_page.dart';
import 'package:v_chat_room_page/src/room/pages/choose_rooms/choose_rooms_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../core/enums.dart';
import 'message_provider.dart';

//todo trans
class VMessageItemController {
  final MessageProvider _messageProvider;

  ModelSheetItem<VMessageItemClickRes> _deleteItem(BuildContext context) {
    return ModelSheetItem(
      id: VMessageItemClickRes.delete,
      title: "Delete",
      iconData: const Icon(
        Icons.delete,
        color: Colors.red,
      ),
    );
  }

  ModelSheetItem<VMessageItemClickRes> _copyItem(BuildContext context) {
    return ModelSheetItem(
        id: VMessageItemClickRes.copy,
        title: "Copy",
        iconData: const Icon(Icons.copy));
  }

  ModelSheetItem<VMessageItemClickRes> _infoItem(BuildContext context) {
    return ModelSheetItem(
      id: VMessageItemClickRes.info,
      title: "Info",
      iconData: const Icon(Icons.info),
    );
  }

  ModelSheetItem<VMessageItemClickRes> _shareItem(BuildContext context) {
    return ModelSheetItem(
      id: VMessageItemClickRes.share,
      title: "Share",
      iconData: const Icon(Icons.share),
    );
  }

  ModelSheetItem<VMessageItemClickRes> _forwardItem(BuildContext context) {
    return ModelSheetItem(
      id: VMessageItemClickRes.forward,
      title: "Forward",
      iconData: const Icon(Icons.forward),
    );
  }

  ModelSheetItem<VMessageItemClickRes> _replyItem(BuildContext context) {
    return ModelSheetItem(
      id: VMessageItemClickRes.reply,
      title: "Reply",
      iconData: const Icon(Icons.replay),
    );
  }

  VMessageItemController(this._messageProvider);

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
      items.add(_forwardItem(context));
      items.add(_replyItem(context));
      items.add(_shareItem(context));
      if (message.isMeSender) {
        items.add(_infoItem(context));
      }
    }
    items.add(
      _deleteItem(context),
    );
    if (message.messageType.isText) {
      items.add(_copyItem(context));
    }

    if (message.messageType.isAllDeleted) {
      items.clear();
      //solution
      items.add(_deleteItem(context));
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

  void _handleDelete(BuildContext context, VBaseMessage message) async {
    final l = <ModelSheetItem>[];
    if (message.isMeSender && !message.messageType.isAllDeleted) {
      l.add(ModelSheetItem(title: 'Delete from all', id: 1));
    }
    l.add(ModelSheetItem(title: 'Delete from me', id: 2));
    final res = await VAppAlert.showModalSheet(
      content: l,
      context: context,
    );
    if (res == null) return;
    if (res.id == 1) {
      await vSafeApiCall(
        request: () async {
          return _messageProvider.deleteMessageFromAll(
            message.roomId,
            message.id,
          );
        },
        onSuccess: (response) {},
      );
    }
    if (res.id == 2) {
      await vSafeApiCall(
        request: () async {
          return _messageProvider.deleteMessageFromMe(message);
        },
        onSuccess: (response) {},
      );
    }
  }

  void _handleCopy(BuildContext context, VBaseMessage message) {}
}
