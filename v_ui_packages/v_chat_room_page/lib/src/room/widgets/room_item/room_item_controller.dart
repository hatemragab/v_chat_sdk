import 'package:flutter/material.dart';
import 'package:v_chat_room_page/src/room/room.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../pages/room_page/room_provider.dart';

class RoomItemController {
  final RoomProvider _provider;

  ModelSheetItem<VRoomItemClickRes> _muteItem(BuildContext context) {
    return ModelSheetItem(
      title: "Mute",
      id: VRoomItemClickRes.mute,
      iconData: const Icon(
        Icons.notifications_off,
      ),
    );
  }

  ModelSheetItem<VRoomItemClickRes> _unMuteItem(BuildContext context) {
    return ModelSheetItem(
      title: "Un mute",
      id: VRoomItemClickRes.unMute,
      iconData: const Icon(
        Icons.notifications,
      ),
    );
  }

  ModelSheetItem<VRoomItemClickRes> _deleteItem(BuildContext context) {
    return ModelSheetItem(
      title: "Delete",
      iconData: const Icon(Icons.delete),
      id: VRoomItemClickRes.delete,
    );
  }

  ModelSheetItem<VRoomItemClickRes> _reportItem(BuildContext context) {
    return ModelSheetItem(
      title: "Report",
      id: VRoomItemClickRes.report,
      iconData: const Icon(
        Icons.report_gmailerrorred,
        color: Colors.red,
      ),
    );
  }

  ModelSheetItem<VRoomItemClickRes> _unBlockItem(BuildContext context) {
    return ModelSheetItem(
      title: "Un block",
      id: VRoomItemClickRes.unBlock,
      iconData: const Icon(
        Icons.security,
        color: Colors.red,
      ),
    );
  }

  ModelSheetItem<VRoomItemClickRes> _blockItem(BuildContext context) {
    return ModelSheetItem(
      title: "Block",
      id: VRoomItemClickRes.block,
      iconData: const Icon(
        Icons.block,
        color: Colors.red,
      ),
    );
  }

  ModelSheetItem<VRoomItemClickRes> _leaveItem(
    BuildContext context,
  ) {
    return ModelSheetItem(
      title: "Leave",
      id: VRoomItemClickRes.leave,
      iconData: const Icon(
        Icons.exit_to_app,
        color: Colors.red,
      ),
    );
  }

  RoomItemController(this._provider);

  Future openForSingle(VRoom room, BuildContext context) async {
    final l = <ModelSheetItem>[
      if (room.isMuted) _unMuteItem(context) else _muteItem(context),
      _deleteItem(context),
      _reportItem(context),
    ];

    if (room.isThereBlock && room.isMeBlocker) {
      l.add(_unBlockItem(context));
    }
    if (!room.isThereBlock) {
      l.add(_blockItem(context));
    }
    final res = await VAppAlert.showModalSheet(
      content: l,
      context: context,
    );

    if (res == null) return;
    _process(res.id, room, context);
  }

  Future _process(Object res, VRoom room, BuildContext context) async {
    switch (res as VRoomItemClickRes) {
      case VRoomItemClickRes.mute:
        await _mute(context, room);
        break;
      case VRoomItemClickRes.unMute:
        await _unMute(context, room);
        break;
      case VRoomItemClickRes.delete:
        await _delete(context, room);
        break;
      case VRoomItemClickRes.block:
        await _block(context, room);
        break;
      case VRoomItemClickRes.unBlock:
        await _unBlock(context, room);
        break;
      case VRoomItemClickRes.report:
        //todo support
        break;
      case VRoomItemClickRes.leave:
        _groupLeave(context, room);
        break;
    }
  }

  Future openForGroup(VRoom room, BuildContext context) async {
    final res = await VAppAlert.showModalSheet(
      content: [
        if (room.isMuted) _unMuteItem(context) else _muteItem(context),
        _leaveItem(context),
        _deleteItem(context),
      ],
      context: context,
    );
    if (res == null) return;
    _process(res.id, room, context);
  }

  Future openForBroadcast(VRoom room, BuildContext context) async {
    final res = await VAppAlert.showModalSheet(
      content: [
        _deleteItem(context),
      ],
      context: context,
    );
    if (res == null) return;
    _process(res.id, room, context);
  }

  Future _mute(BuildContext context, VRoom room) async {
    await vSafeApiCall(
      request: () async {
        await _provider.mute(room.id);
      },
      onSuccess: (response) {
        VAppAlert.showOverlaySupport(title: "Chat muted");
      },
    );
  }

  Future _unMute(BuildContext context, VRoom room) async {
    await vSafeApiCall(
      request: () async {
        await _provider.unMute(room.id);
      },
      onSuccess: (response) {
        VAppAlert.showOverlaySupport(title: "Chat un muted");
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
        VAppAlert.showOverlaySupport(title: "Chat deleted");
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
        VAppAlert.showOverlaySupport(title: "User blocked");
      },
    );
  }

  Future _unBlock(BuildContext context, VRoom room) async {
    await vSafeApiCall(
      request: () async {
        await _provider.block(room.id);
      },
      onSuccess: (response) {
        VAppAlert.showOverlaySupport(title: "User un blocked");
      },
    );
  }

  Future _groupLeave(BuildContext context, VRoom room) async {
    final res = await VAppAlert.showAskYesNoDialog(
      context: context,
      title: "Are you sure to leave?",
      content: "Leave group and delete your message copy?",
    );
    if (res != 1) return;
    await vSafeApiCall(
      request: () async {
        await _provider.groupLeave(room.id);
      },
      onSuccess: (response) {
        VAppAlert.showOverlaySupport(title: "Group left");
      },
    );
  }
}
