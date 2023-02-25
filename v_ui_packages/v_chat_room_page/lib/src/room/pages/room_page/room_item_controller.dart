// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:v_chat_room_page/src/room/room.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import 'room_provider.dart';

class RoomItemController {
  final RoomProvider _provider;
  final BuildContext context;

  RoomItemController(
    this._provider,
    this.context,
  );

  ModelSheetItem<VRoomItemClickRes> _muteItem() {
    return ModelSheetItem(
      title: VTrans.of(context).labels.mute,
      id: VRoomItemClickRes.mute,
      iconData: const Icon(
        Icons.notifications_off,
      ),
    );
  }

  ModelSheetItem<VRoomItemClickRes> _unMuteItem() {
    return ModelSheetItem(
      title: VTrans.of(context).labels.unMute,
      id: VRoomItemClickRes.unMute,
      iconData: const Icon(
        Icons.notifications,
      ),
    );
  }

  ModelSheetItem<VRoomItemClickRes> _deleteItem() {
    return ModelSheetItem(
      title: VTrans.of(context).labels.delete,
      iconData: const Icon(Icons.delete),
      id: VRoomItemClickRes.delete,
    );
  }

  ModelSheetItem<VRoomItemClickRes> _reportItem() {
    return ModelSheetItem(
      title: VTrans.of(context).labels.report,
      id: VRoomItemClickRes.report,
      iconData: const Icon(
        Icons.report_gmailerrorred,
        color: Colors.red,
      ),
    );
  }

  // ModelSheetItem<VRoomItemClickRes> _unBlockItem() {
  //   return ModelSheetItem(
  //     title: VTrans.of(context).labels.unBlock,
  //     id: VRoomItemClickRes.unBlock,
  //     iconData: const Icon(
  //       Icons.security,
  //       color: Colors.red,
  //     ),
  //   );
  // }
  //
  // ModelSheetItem<VRoomItemClickRes> _blockItem() {
  //   return ModelSheetItem(
  //     title: VTrans.of(context).labels.block,
  //     id: VRoomItemClickRes.block,
  //     iconData: const Icon(
  //       Icons.block,
  //       color: Colors.red,
  //     ),
  //   );
  // }

  ModelSheetItem<VRoomItemClickRes> _leaveItem() {
    return ModelSheetItem(
      title: VTrans.of(context).labels.leave,
      id: VRoomItemClickRes.leave,
      iconData: const Icon(
        Icons.exit_to_app,
        color: Colors.red,
      ),
    );
  }

  Future openForSingle(VRoom room) async {
    final l = <ModelSheetItem>[
      if (room.isMuted) _unMuteItem() else _muteItem(),
      _deleteItem(),
      _reportItem(),
    ];

    // if (room.isThereBlock && room.isMeBlocker) {
    //   l.add(_unBlockItem());
    // }
    // if (!room.isThereBlock) {
    //   l.add(_blockItem());
    // }
    final res = await VAppAlert.showModalSheet(
      content: l,
      context: context,
    );

    if (res == null) return;
    _process(
      res.id,
      room,
    );
  }

  Future _process(Object res, VRoom room) async {
    switch (res as VRoomItemClickRes) {
      case VRoomItemClickRes.mute:
        await _mute(room);
        break;
      case VRoomItemClickRes.unMute:
        await _unMute(room);
        break;
      case VRoomItemClickRes.delete:
        await _delete(room);
        break;
        // case VRoomItemClickRes.block:
        //   // await _block(room);
        //   break;
        // case VRoomItemClickRes.unBlock:
        //   // await _unBlock(room);
        break;
      case VRoomItemClickRes.report:
        _report(room);
        break;
      case VRoomItemClickRes.leave:
        _groupLeave(room);
        break;
    }
  }

  Future openForGroup(VRoom room) async {
    final res = await VAppAlert.showModalSheet(
      content: [
        if (room.isMuted) _unMuteItem() else _muteItem(),
        _leaveItem(),
        _deleteItem(),
      ],
      context: context,
    );
    if (res == null) return;
    _process(
      res.id,
      room,
    );
  }

  Future openForBroadcast(
    VRoom room,
  ) async {
    final res = await VAppAlert.showModalSheet(
      content: [
        _deleteItem(),
      ],
      context: context,
    );
    if (res == null) return;
    _process(res.id, room);
  }

  Future _mute(VRoom room) async {
    await vSafeApiCall(
      request: () async {
        await _provider.mute(room.id);
      },
      onSuccess: (response) {
        //VAppAlert.showOverlaySupport(title: "Chat muted");
      },
    );
  }

  Future _unMute(VRoom room) async {
    await vSafeApiCall(
      request: () async {
        await _provider.unMute(room.id);
      },
      onSuccess: (response) {
        //VAppAlert.showOverlaySupport(title: "Chat un muted");
      },
    );
  }

  Future _delete(VRoom room) async {
    final res = await VAppAlert.showAskYesNoDialog(
      context: context,
      title: VTrans.of(context).labels.deleteYouCopy,
      content: VTrans.of(context)
          .labels
          .areYouSureToPermitYourCopyThisActionCantUndo,
    );
    if (res != 1) return;
    await vSafeApiCall(
      request: () async {
        await _provider.deleteRoom(room.id);
      },
      onSuccess: (response) {},
    );
  }

  // Future _block(VRoom room) async {
  //   final res = await VAppAlert.showAskYesNoDialog(
  //     context: context,
  //     title: VTrans.of(context).labels.blockThisUser,
  //     content: VTrans.of(context)
  //         .labels
  //         .areYouSureToBlockThisUserCantSendMessageToYou,
  //   );
  //   if (res != 1) return;
  //
  //   if (VChatController.I.vMessagePageConfig.onUserBlockAnother != null) {
  //     VChatController.I.vMessagePageConfig.onUserBlockAnother!(
  //       context,
  //       room.peerIdentifier!,
  //     );
  //   }
  //   await vSafeApiCall(
  //     request: () async {
  //       await _provider.block(room.id);
  //     },
  //     onSuccess: (response) {
  //       VAppAlert.showOverlaySupport(
  //           title: VTrans.of(context).labels.userBlocked);
  //     },
  //   );
  // }
  //
  // Future _unBlock(VRoom room) async {
  //   if (VChatController.I.vMessagePageConfig.onUserUnBlockAnother != null) {
  //     VChatController.I.vMessagePageConfig.onUserUnBlockAnother!(
  //       context,
  //       room.peerIdentifier!,
  //     );
  //   }
  //
  //   await vSafeApiCall(
  //     request: () async {
  //       await _provider.block(room.id);
  //     },
  //     onSuccess: (response) {
  //       VAppAlert.showOverlaySupport(
  //           title: VTrans.of(context).labels.userUnBlocked);
  //     },
  //   );
  // }

  Future _groupLeave(VRoom room) async {
    final res = await VAppAlert.showAskYesNoDialog(
      context: context,
      title: VTrans.of(context).labels.areYouSureToLeave,
      content: VTrans.of(context).labels.leaveGroupAndDeleteYourMessageCopy,
    );
    if (res != 1) return;
    await vSafeApiCall(
      request: () async {
        await _provider.deleteRoom(room.id);
        await _provider.groupLeave(room.id);
      },
      onSuccess: (response) async {},
    );
  }

  Future openForOrder(VRoom room) async {
    final res = await VAppAlert.showModalSheet(
      content: [
        _deleteItem(),
      ],
      context: context,
    );
    if (res == null) return;
    _process(res.id, room);
  }

  Future _report(VRoom room) async {
    if (VChatController.I.vChatConfig.onReportUserPress != null) {
      unawaited(VChatController.I.vChatConfig.onReportUserPress!(
        context,
        room.peerIdentifier ?? room.id,
      ));
    }
  }
}
