part of 'v_room_page.dart';

class VRoomController with VSocketStatusStream, VVAppLifeCycleStream {
  final bool isTesting;
  late final RoomStreamState _localStreamChanges;
  late final RoomItemController _roomItemController;
  late final RoomStateController _roomState;

  final _roomProvider = RoomProvider();

  VRoomController({
    this.isTesting = false,
  }) {
    _roomItemController = RoomItemController(_roomProvider);
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
    _getRoomsFromLocal();
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
        _roomState.insertAll(response);
      },
    );
    await _getRoomsFromApi();
  }

  void _onRoomItemLongPress(VRoom room, BuildContext context) async {
    switch (room.roomType) {
      case VRoomType.s:
        await _roomItemController.openForSingle(room, context);
        break;
      case VRoomType.g:
        await _roomItemController.openForGroup(room, context);
        break;
      case VRoomType.b:
        await _roomItemController.openForBroadcast(room, context);
        break;
      case VRoomType.o:
        // TODO: Handle this case.
        break;
    }
  }

  Future _getRoomsFromApi() async {
    await VChatController.I.nativeApi.remote.socketIo.socketCompleter.future;
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
        _roomState.updateCacheState(response);
      },
    );
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

  bool _getIsFinishLoadMore() {
    return _roomState.isFinishLoadMore;
  }

  @override
  void onSocketConnected() {
    super.onSocketConnected();
    _getRoomsFromLocal();
  }
}
