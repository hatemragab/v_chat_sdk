// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

part of 'v_room_page.dart';

class VRoomController with VSocketStatusStream, VVAppLifeCycleStream {
  VRoomController() {
    initSocketStatusStream(
      VChatController.I.nativeApi.streams.socketStatusStream,
    );
    initVAppLifeCycleStreamStream();
    _roomState = RoomStateController(
      _roomProvider,
    );
    _localStreamChanges = RoomStreamState(
      nativeApi: VChatController.I.nativeApi,
      roomState: _roomState,
    );
  }

  bool isFetchingRooms = false;
  late final RoomStreamState _localStreamChanges;
  late RoomItemController _roomItemController;
  late final RoomStateController _roomState;
  late BuildContext _context;

  final _roomProvider = RoomProvider();

  void _init(BuildContext context) {
    _context = context;
    _roomItemController = RoomItemController(
      _roomProvider,
      _context,
    );
    _getRoomsFromLocal();
    _getRoomsFromApi();
  }

  void sortRoomsBy(VRoomType? type) {
    if (type == null) {
      _getRoomsFromLocal();
      return;
    }
    _roomState.sortRoomsBy(type);
  }

  Future<void> _getRoomsFromLocal() async {
    await vSafeApiCall<VPaginationModel<VRoom>>(
      request: () async {
        return _roomProvider.getLocalRooms();
      },
      onSuccess: (response) {
        _roomState.insertAll(response);
      },
    );
  }

  void setRoomSelected(String roomId) {
    _roomState.setRoomSelected(roomId);
  }

  void _onRoomItemLongPress(VRoom room, BuildContext context) async {
    switch (room.roomType) {
      case VRoomType.s:
        await _roomItemController.openForSingle(
          room,
        );
        break;
      case VRoomType.g:
        await _roomItemController.openForGroup(
          room,
        );
        break;
      case VRoomType.b:
        await _roomItemController.openForBroadcast(
          room,
        );
        break;
      case VRoomType.o:
        await _roomItemController.openForOrder(
          room,
        );
        break;
    }
  }

  Future _getRoomsFromApi() async {
    if (isFetchingRooms) {
      return;
    }
    isFetchingRooms = true;
    await VChatController.I.nativeApi.remote.socketIo.socketCompleter.future;
    await vSafeApiCall<VPaginationModel<VRoom>>(
      request: () async {
        return _roomProvider.getApiRooms(
          const VRoomsDto(),
        );
      },
      onSuccess: (response) {
        _roomState.updateCacheState(response);
      },
    );
    isFetchingRooms = false;
  }

  void dispose() {
    _roomState.close();
    _localStreamChanges.close();
    closeSocketStatusStream();
    closeVAppLifeCycleStreamStream();
  }

  void _onRoomItemPress(VRoom room, BuildContext context) {
    VChatController.I.vNavigator.messageNavigator.toMessagePage(context, room);
  }

  Future<bool> _onLoadMore() {
    return _roomState.onLoadMore();
  }

  bool get _getIsFinishLoadMore {
    return _roomState.isFinishLoadMore;
  }

  @override
  void onSocketConnected() {
    super.onSocketConnected();
    _getRoomsFromApi();
  }
}
