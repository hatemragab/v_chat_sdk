// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

part of 'v_room_page.dart';

class VRoomController with StreamMix {
  VRoomController() {
    _initStreams();
    _roomState = RoomStateController(
      _roomProvider,
    );
  }

  final _nativeApi = VChatController.I.nativeApi;
  final _events = VEventBusSingleton.vEventBus;
  bool isFetchingRooms = false;

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
        _roomState.updateCacheStateForChatRooms(response);
      },
    );
    isFetchingRooms = false;
  }

  void dispose() {
    _roomState.close();
    closeStreamMix();
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

  void _initStreams() {
    streamsMix.addAll([
      ///socket events
      _events.on<VSocketStatusEvent>().listen(_handleSocketConnectionStatus),
      _events.on<VSocketIntervalEvent>().listen(_handleSocketIntervalFire),

      ///room events
      _events.on<VUpdateRoomImageEvent>().listen(_handleUpdateRoomImage),
      _events.on<VUpdateRoomNameEvent>().listen(_handleUpdateRoomTitle),
      _events.on<VUpdateRoomTypingEvent>().listen(_handleRoomTyping),
      _events
          .on<VUpdateRoomUnReadCountByOneEvent>()
          .listen(_handleCounterByOne),
      _events.on<VUpdateRoomMuteEvent>().listen(_handleMute),
      _events.on<VDeleteRoomEvent>().listen(_handleDeleteRoom),
      _events.on<VInsertRoomEvent>().listen(_handleInsertRoom),
      _events
          .on<VUpdateRoomUnReadCountToZeroEvent>()
          .listen(_handleResetCounter),
      _events.on<VRoomOfflineEvent>().listen(_handleOnOffRoom),
      _events.on<VRoomOnlineEvent>().listen(_handleOnOnlineRoom),

      ///messages events
      _events.on<VInsertMessageEvent>().listen(_handleInsertMessage),
      _events.on<VDeleteMessageEvent>().listen(_handleDeleteMessage),
      _events.on<VUpdateMessageDeliverEvent>().listen(_handleDeliverMessages),
      _events.on<VUpdateMessageSeenEvent>().listen(_handleSeenMessages),
      _events.on<VUpdateMessageEvent>().listen(_handleUpdateMessages),
      _events
          .on<VUpdateMessageAllDeletedEvent>()
          .listen(_handleAllDeleteMessage),
      _events
          .on<VUpdateMessageStatusEvent>()
          .listen(_handleUpdateMessageStatus),
    ]);
  }

  void _handleSocketConnectionStatus(VSocketStatusEvent event) {
    if (event.isConnected) {
      _getRoomsFromApi();
    }
  }

  void _handleSocketIntervalFire(VSocketIntervalEvent event) {
    ///emit to update online and offline
    final ids = _roomState.stateRooms
        .where((element) => element.roomType.isSingleOrOrder)
        .toList();
    _nativeApi.remote.socketIo.emitGetMyOnline(
      ids
          .map((e) => VOnlineOfflineModel(
                peerId: e.peerId!,
                isOnline: false,
                roomId: e.id,
              ).toMap())
          .toList(),
    );
  }

  void _handleUpdateRoomImage(VUpdateRoomImageEvent event) {
    _roomState.updateImage(event.roomId, event.image);
  }

  void _handleUpdateRoomTitle(VUpdateRoomNameEvent event) {
    _roomState.updateTitle(event.roomId, event.name);
  }

  void _handleRoomTyping(VUpdateRoomTypingEvent event) {
    _roomState.updateTyping(event.roomId, event.typingModel);
  }

  void _handleCounterByOne(VUpdateRoomUnReadCountByOneEvent event) {
    _roomState.updateCounterByOne(event.roomId);
  }

  void _handleMute(VUpdateRoomMuteEvent event) {
    _roomState.updateMute(event.roomId, event.isMuted);
  }

  void _handleDeleteRoom(VDeleteRoomEvent event) {
    _roomState.deleteRoom(event.roomId);
  }

  void _handleInsertRoom(VInsertRoomEvent event) {
    _roomState.insertRoom(event.room);
  }

  void _handleResetCounter(VUpdateRoomUnReadCountToZeroEvent event) {
    _roomState.resetRoomCounter(event.roomId);
  }

  void _handleOnOffRoom(VRoomOfflineEvent event) {
    _roomState.updateOffline(event.roomId);
  }

  void _handleOnOnlineRoom(VRoomOnlineEvent event) {
    _roomState.updateOnline(event.roomId);
  }

  void _handleInsertMessage(VInsertMessageEvent event) {
    _roomState.insertRoomLastMessage(event);
  }

  void _handleDeleteMessage(VDeleteMessageEvent event) {
    _roomState.deleteRoomLastMessage(event);
  }

  void _handleDeliverMessages(VUpdateMessageDeliverEvent event) {
    _roomState.deliverRoomLastMessage(event);
  }

  void _handleSeenMessages(VUpdateMessageSeenEvent event) {
    _roomState.seenRoomLastMessage(event);
  }

  void _handleUpdateMessages(VUpdateMessageEvent event) {
    _roomState.updateRoomLastMessage(event);
  }

  void _handleUpdateMessageStatus(VUpdateMessageStatusEvent event) {
    _roomState.updateRoomLastMessageStatus(event);
  }

  void _handleAllDeleteMessage(VUpdateMessageAllDeletedEvent event) {
    _roomState.updateRoomLastMessageAllDelete(event);
  }
}
