import 'dart:async';

import 'package:flutter/material.dart';
import 'package:v_chat_room_page/src/pages/room_page/room_provider.dart';
import 'package:v_chat_room_page/src/pages/room_page/room_state.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../widgets/room_item/room_item_controller.dart';
import 'local_changes_stream.dart';

class VRoomController {
  final bool isTesting;
  late final LocalStreamChanges _localStreamChanges;
  final roomItemController = RoomItemController();
  final roomState = RoomState();
  final _roomProvider = RoomProvider();

  List<VRoom> get rooms => roomState.stateRooms;

  VRoomController({
    this.isTesting = false,
  }) {
    _localStreamChanges = LocalStreamChanges(
      nativeApi: VChatController.I.nativeApi,
      roomState: roomState,
    );
    _getRoomsFromLocal();
  }

  Future<void> _getRoomsFromLocal() async {
    await vSafeApiCall<List<VRoom>>(
      request: () async {
        return _roomProvider.getFakeLocalRooms();
      },
      onSuccess: (response) {
        roomState.updateCacheState(response);
      },
    );
    getRoomsFromApi();
  }

  void onRoomItemPress(VRoom room, BuildContext context) {
    // context.toPage(VMessagePage(
    //   vRoom: room,
    // ));
  }

  void onRoomItemLongPress(VRoom room, BuildContext context) async {
    switch (room.roomType) {
      case VRoomType.s:
        await roomItemController.openForSingle(room, context);
        break;
      case VRoomType.g:
        await roomItemController.openForGroup(room, context);
        break;
      case VRoomType.b:
        await roomItemController.openForBroadcast(room, context);
        break;
      case VRoomType.o:
        // TODO: Handle this case.
        break;
    }
  }

  void getRoomsFromApi() async {
    await vSafeApiCall<List<VRoom>>(
      request: () async {
        return _roomProvider.getFakeApiRooms();
      },
      onSuccess: (response) {
        roomState.updateCacheState(response);
      },
    );
  }

  void dispose() {
    _localStreamChanges.close();
    roomState.close();
  }
}
