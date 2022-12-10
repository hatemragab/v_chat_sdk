import 'package:collection/collection.dart';

import '../../../../../v_chat_sdk_core.dart';
import '../../../../models/socket/room_typing_model.dart';
import '../../abstraction/base_local_room_repo.dart';

class MemoryRoomImp extends BaseLocalRoomRepo {
  final _rooms = <VRoom>[];

  @override
  Future<int> delete(DeleteRoomEvent event) {
    _rooms.removeWhere((e) => event.roomId == e.id);
    return Future.value(1);
  }

  VRoom? getRoomById(String id) {
    return _rooms.singleWhereOrNull((e) => e.id == id);
  }

  @override
  Future<int> insert(InsertRoomEvent event) {
    final room = getRoomById(event.room.id);

    ///room already exist!
    if (room != null) return Future.value(0);
    _rooms.add(event.room);
    return Future.value(1);
  }

  @override
  Future<List<VRoom>> search(String text, int limit, RoomType? roomType) {
    ///case filterType ==null search in all room types !
    if (roomType == null) {
      return Future.value(
        _rooms
            .where((e) => e.title.toLowerCase().startsWith(text.toLowerCase()))
            .toList(),
      );
    }
    return Future.value(
      _rooms
          .where(
            (e) =>
                e.title.toLowerCase().startsWith(text.toLowerCase()) &&
                e.roomType == roomType,
          )
          .toList(),
    );
  }

  @override
  Future<int> updateBlockSingleRoom(BlockSingleRoomEvent event) async {
    final room = getRoomById(event.roomId);
    if (room == null) return 0;
    room.blockerId = event.banModel.bannerId;
    return Future.value(1);
  }

  @override
  Future<int> updateCountByOne(
    UpdateRoomUnReadCountByOneEvent event,
  ) async {
    final room = getRoomById(event.roomId);
    if (room == null) return 0;
    ++room.unReadCount;
    return Future.value(1);
  }

  @override
  Future<int> updateImage(UpdateRoomImageEvent event) async {
    final room = getRoomById(event.roomId);
    if (room == null) return 0;
    room.thumbImage = VFullUrlModel(event.image);
    return Future.value(1);
  }

  @override
  Future<int> updateIsMuted(UpdateRoomMuteEvent event) async {
    final old = getRoomById(event.roomId);
    if (old == null) return 0;
    old.isMuted = event.isMuted;
    return Future.value(1);
  }

  @override
  Future<int> updateName(UpdateRoomNameEvent event) async {
    final room = getRoomById(event.roomId);
    if (room == null) return 0;
    room.title = event.name;
    return Future.value(1);
  }

  @override
  Future<int> updateOnline(UpdateRoomOnlineEvent event) async {
    final room = getRoomById(event.roomId);
    if (room == null) return 0;
    room.isOnline = event.model.isOnline;
    return Future.value(1);
  }

  @override
  Future<int> updateTyping(UpdateRoomTypingEvent event) async {
    final room = getRoomById(event.roomId);
    if (room == null) return 0;
    room.typingStatus = event.typingModel;
    return Future.value(1);
  }

  @override
  Future<int> updateCountToZero(
    UpdateRoomUnReadCountToZeroEvent event,
  ) async {
    final room = getRoomById(event.roomId);
    if (room == null) return 0;
    room.unReadCount = 0;
    return Future.value(1);
  }

  @override
  Future<List<VRoom>> getRoomsWithLastMessage({int limit = 300}) async {
    return _rooms.sortedByCompare(
      (element) => element.lastMessage.id,
      (a, b) => 1,
    );
  }

  @override
  Future<int> setAllOffline() async {
    for (final element in _rooms) {
      element.isOnline = false;
      element.typingStatus = RoomTypingModel.offline;
    }
    return Future.value(1);
  }

  @override
  Future<int> insertMany(List<VRoom> rooms) async {
    for (final room in rooms) {
      if (!_rooms.contains(room)) {
        _rooms.add(room);
      }
    }
    return Future.value(1);
  }

  @override
  Future<VRoom?> getOneWithLastMessageByRoomId(String roomId) async {
    return Future.value(getRoomById(roomId));
  }

  @override
  Future<int> reCreate() async {
    _rooms.clear();
    return Future.value(1);
  }

  @override
  Future<String?> getRoomIdByPeerId(String peerId) async {
    final x = _rooms.singleWhereOrNull((e) => e.peerId == peerId);
    if (x == null) return null;
    return x.id;
  }

  @override
  Future<VRoom?> getOneByPeerId(String peerId) async {
    return _rooms.singleWhereOrNull((e) => e.peerId == peerId);
  }
}