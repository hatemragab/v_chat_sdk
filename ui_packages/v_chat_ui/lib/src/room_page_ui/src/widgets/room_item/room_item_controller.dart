import 'package:flutter/src/widgets/framework.dart';
import 'package:v_chat_sdk_core/src/models/v_room/v_room.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_ui/src/core/platfrom_widgets/v_app_alert.dart';

class RoomItemController {
  Future openForSingle(VRoom room, BuildContext context) async {
    final res = await VAppAlert.showModalSheet(
      content: [
        ModelSheetItem(
          title: room.isMuted ? "Un mute" : "Mute",
          id: room.isMuted ? 2 : 1,
        ),
        ModelSheetItem(
          title: room.isMeBlocker ? "Un block" : "Block",
          id: room.isMeBlocker ? 10 : 3,
        ),
        ModelSheetItem(
          title: "Delete",
          id: 4,
        ),
      ],
      context: context,
    );
    if (res == null) return;
    if (res.id == 1) {
      await _mute(context);
    }
    if (res.id == 2) {
      await _unMute(context);
    }
    if (res.id == 3) {
      await _block(context);
    }
    if (res.id == 10) {
      await _unBlock(context);
    }
    if (res.id == 4) {
      await _delete(context);
    }
  }

  Future openForGroup(VRoom room, BuildContext context) async {
    final res = await VAppAlert.showModalSheet(
      content: [
        ModelSheetItem(
          title: room.isMuted ? "Un mute" : "Mute",
          id: room.isMuted ? 2 : 1,
        ),
        ModelSheetItem(
          title: "Leave",
          id: 3,
        ),
        ModelSheetItem(
          title: "Delete",
          id: 4,
        ),
      ],
      context: context,
    );
    if (res == null) return;
    if (res.id == 1) {
      await _mute(context);
    }
    if (res.id == 2) {
      await _unMute(context);
    }
    if (res.id == 3) {
      await _groupLeave(context);
    }
    if (res.id == 4) {
      await _delete(context);
    }
  }

  Future openForBroadcast(VRoom room, BuildContext context) async {
    final res = await VAppAlert.showModalSheet(
      content: [
        ModelSheetItem(
          title: "Delete",
          id: 4,
        ),
      ],
      context: context,
    );
    if (res == null) return;

    if (res.id == 4) {
      await _delete(context);
    }
  }

  Future _mute(BuildContext context) async {
    await vSafeApiCall(
      request: () async {
        await Future.delayed(const Duration(seconds: 2));
      },
      onSuccess: (response) {
        VAppAlert.showSuccessSnackBar(msg: "Chat muted", context: context);
      },
    );
  }

  Future _unMute(BuildContext context) async {
    await vSafeApiCall(
      request: () async {
        await Future.delayed(const Duration(seconds: 2));
      },
      onSuccess: (response) {
        VAppAlert.showSuccessSnackBar(msg: "Chat un muted", context: context);
      },
    );
  }

  Future _delete(BuildContext context) async {
    final res = await VAppAlert.showAskYesNoDialog(
      context: context,
      title: "Delete you copy?",
      content: "Are you sure to permit your copy this action cant undo",
    );
    if (res != 1) return;
    await vSafeApiCall(
      request: () async {
        await Future.delayed(const Duration(seconds: 2));
      },
      onSuccess: (response) {
        VAppAlert.showSuccessSnackBar(msg: "Chat deleted", context: context);
      },
    );
  }

  Future _block(BuildContext context) async {
    final res = await VAppAlert.showAskYesNoDialog(
      context: context,
      title: "Block this user?",
      content: "Are you sure to block this user cant send message to you",
    );
    if (res != 1) return;
    await vSafeApiCall(
      request: () async {
        await Future.delayed(const Duration(seconds: 2));
      },
      onSuccess: (response) {
        VAppAlert.showSuccessSnackBar(msg: "User blocked", context: context);
      },
    );
  }

  Future _unBlock(BuildContext context) async {
    await vSafeApiCall(
      request: () async {
        await Future.delayed(const Duration(seconds: 2));
      },
      onSuccess: (response) {
        VAppAlert.showSuccessSnackBar(msg: "User un blocked", context: context);
      },
    );
  }

  Future _groupLeave(BuildContext context) async {
    final res = await VAppAlert.showAskYesNoDialog(
      context: context,
      title: "Are you sure to leave?",
      content: "Leave group and delete your message copy?",
    );
    if (res != 1) return;
    await vSafeApiCall(
      request: () async {
        await Future.delayed(const Duration(seconds: 2));
      },
      onSuccess: (response) {
        VAppAlert.showSuccessSnackBar(msg: "Group left", context: context);
      },
    );
  }
}
