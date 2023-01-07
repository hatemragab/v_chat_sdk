import 'dart:async';

import 'package:flutter/material.dart';
import 'package:v_chat_room_page/src/room/pages/room_page/room_provider.dart';
import 'package:v_chat_room_page/src/room/pages/room_page/states/room_state_controller.dart';
import 'package:v_chat_room_page/src/room/pages/room_page/states/room_stream_state.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../widgets/room_item/room_item_controller.dart';

class VRoomController with VSocketStatusStream {
  final bool isTesting;
  late final RoomStreamState _localStreamChanges;
  late final RoomItemController roomItemController;
  late final RoomStateController roomState;

  final _roomProvider = RoomProvider();

  ///getters
  List<VRoom> get rooms => roomState.stateRooms;

  VRoomController({
    this.isTesting = false,
  }) {
    roomItemController = RoomItemController(_roomProvider);
    initSocketStatusStream(
      VChatController.I.nativeApi.streams.socketStatusStream,
    );
    roomState = RoomStateController(
      _roomProvider,
    );
    _localStreamChanges = RoomStreamState(
      nativeApi: VChatController.I.nativeApi,
      roomState: roomState,
    );
    _getRoomsFromLocal();
  }

  Future<void> _getRoomsFromLocal() async {
    await vSafeApiCall<VPaginationModel<VRoom>>(
      request: () async {
        if (isTesting) {
          return VPaginationModel<VRoom>(
            values: await _roomProvider.getFakeLocalRooms(),
            page: 1,
            limit: 20,
          );
        }
        return _roomProvider.getLocalRooms();
      },
      onSuccess: (response) {
        roomState.insertAll(response);
      },
    );
    await getRoomsFromApi();
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

  Future getRoomsFromApi() async {
    await vSafeApiCall<VPaginationModel<VRoom>>(
      request: () async {
        if (isTesting) {
          return VPaginationModel(
            values: await _roomProvider.getFakeApiRooms(),
            page: 1,
            limit: 20,
          );
        }
        return _roomProvider.getApiRooms(
          const VRoomsDto(),
        );
      },
      onSuccess: (response) {
        roomState.updateCacheState(response);
      },
    );
  }

  void dispose() {
    roomState.close();
    _localStreamChanges.close();
    closeSocketStatusStream();
  }

  @override
  void onSocketConnected() {
    ///todo improve this api call
    // getRoomsFromApi();
  }

  void onRoomItemPress(VRoom room, BuildContext context) {
    VChatController.I.vNavigator.toMessagePage(context, room);
  }

  Future<bool> onLoadMore() {
    return roomState.onLoadMore();
  }

  bool getIsFinishLoadMore() {
    return roomState.isFinishLoadMore;
  }
}
