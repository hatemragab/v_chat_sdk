import 'dart:async';

import 'package:flutter/material.dart';
import 'package:v_chat_room_page/src/pages/room_page/room_state.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../assets/data/api_rooms.dart';
import '../../assets/data/local_rooms.dart';
import '../../widgets/room_item/room_item_controller.dart';

class VRoomController {
  bool isTesting;

  VRoomController({
    this.isTesting = false,
  }) {
    _getRoomsFromLocal();
    //VChatController.I.nativeApi.local.room.roomStream.listen((event) {});
  }

  final roomItemController = RoomItemController();

  final roomState = RoomState();

  List<VRoom> get rooms => roomState.stateRooms;

  Future<void> _getRoomsFromLocal() async {
    await vSafeApiCall<List<VRoom>>(
      request: () async {
        await Future.delayed(const Duration(milliseconds: 100));
        return [VRoom.fromLocalMap(fakeLocalRooms.first)];
      },
      onSuccess: (response) {
        roomState.updateCacheState(response);
      },
    );
    getRoomsFromApi();
  }

  void dispose() {
    roomState.close();
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
        await Future.delayed(const Duration(milliseconds: 1100));
        return [VRoom.fromMap(fakeApiRooms.first)];
      },
      onSuccess: (response) {
        roomState.updateCacheState(response);
      },
    );
  }
}
