import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../pages/room_page/room_provider.dart';

class RoomItemController {
  final RoomProvider _provider;

  RoomItemController(this._provider);

  Future openForSingle(VRoom room, BuildContext context) async {
    final l = [
      ModelSheetItem(
        title: room.isMuted ? "Un mute" : "Mute",
        id: room.isMuted ? 2 : 1,
      ),
      ModelSheetItem(
        title: "Delete",
        id: 4,
      ),
    ];
    if (room.isThereBlock && room.isMeBlocker) {
      l.add(ModelSheetItem(
        title: "Un block",
        id: 10,
      ));
    }
    if (!room.isThereBlock) {
      l.add(ModelSheetItem(
        title: "Block",
        id: 3,
      ));
    }
    final res = await VAppAlert.showModalSheet(
      content: l,
      context: context,
    );

    if (res == null) return;
    if (res.id == 1) {
      await _mute(context, room);
    }
    if (res.id == 2) {
      await _unMute(context, room);
    }
    if (res.id == 3) {
      await _block(context, room);
    }
    if (res.id == 10) {
      await _unBlock(context, room);
    }
    if (res.id == 4) {
      await _delete(context, room);
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
      await _mute(context, room);
    }
    if (res.id == 2) {
      await _unMute(context, room);
    }
    if (res.id == 3) {
      await _groupLeave(context);
    }
    if (res.id == 4) {
      await _delete(context, room);
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
      await _delete(context, room);
    }
  }

  Future _mute(BuildContext context, VRoom room) async {
    await vSafeApiCall(
      request: () async {
        await _provider.mute(room.id);
      },
      onSuccess: (response) {
        VAppAlert.showSuccessSnackBar(msg: "Chat muted", context: context);
      },
    );
  }

  Future _unMute(BuildContext context, VRoom room) async {
    await vSafeApiCall(
      request: () async {
        await _provider.unMute(room.id);
      },
      onSuccess: (response) {
        VAppAlert.showSuccessSnackBar(msg: "Chat un muted", context: context);
      },
    );
  }

  Future _delete(BuildContext context, VRoom room) async {
    final res = await VAppAlert.showAskYesNoDialog(
      context: context,
      title: "Delete you copy?",
      content: "Are you sure to permit your copy this action cant undo",
    );
    if (res != 1) return;
    await vSafeApiCall(
      request: () async {
        await _provider.deleteRoom(room.id);
      },
      onSuccess: (response) {
        VAppAlert.showSuccessSnackBar(msg: "Chat deleted", context: context);
      },
    );
  }

  Future _block(BuildContext context, VRoom room) async {
    final res = await VAppAlert.showAskYesNoDialog(
      context: context,
      title: "Block this user?",
      content: "Are you sure to block this user cant send message to you",
    );
    if (res != 1) return;
    await vSafeApiCall(
      request: () async {
        await _provider.block(room.id);
      },
      onSuccess: (response) {
        VAppAlert.showSuccessSnackBar(msg: "User blocked", context: context);
      },
    );
  }

  Future _unBlock(BuildContext context, VRoom room) async {
    await vSafeApiCall(
      request: () async {
        await _provider.block(room.id);
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
