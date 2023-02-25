// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/src/local_db/core/abstraction/base_local_room_repo.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class MemoryRoomImp extends BaseLocalRoomRepo {
  final _rooms = <VRoom>[];

  @override
  Future<int> delete(VDeleteRoomEvent event) {
    _rooms.removeWhere((e) => event.roomId == e.id);
    return Future.value(1);
  }

  VRoom? getRoomById(String id) {
    return _rooms.singleWhereOrNull((e) => e.id == id);
  }

  @override
  Future<int> insert(VInsertRoomEvent event) {
    final room = getRoomById(event.room.id);

    ///room already exist!
    if (room != null) return Future.value(0);
    _rooms.add(event.room);
    return Future.value(1);
  }

  @override
  Future<List<VRoom>> search(String text, int limit, VRoomType? roomType) {
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

  //
  // @override
  // Future<int> updateBlockRoom(VBlockRoomEvent event) async {
  //   final room = getRoomById(event.roomId);
  //   if (room == null) return 0;
  //   room.blockerId = event.banModel.bannerId;
  //   return Future.value(1);
  // }

  @override
  Future<int> updateCountByOne(
    VUpdateRoomUnReadCountByOneEvent event,
  ) async {
    final room = getRoomById(event.roomId);
    if (room == null) return 0;
    ++room.unReadCount;
    return Future.value(1);
  }

  @override
  Future<int> updateImage(VUpdateRoomImageEvent event) async {
    final room = getRoomById(event.roomId);
    if (room == null) return 0;
    room.thumbImage = event.image;
    return Future.value(1);
  }

  @override
  Future<int> updateIsMuted(VUpdateRoomMuteEvent event) async {
    final old = getRoomById(event.roomId);
    if (old == null) return 0;
    old.isMuted = event.isMuted;
    return Future.value(1);
  }

  @override
  Future<int> updateName(VUpdateRoomNameEvent event) async {
    final room = getRoomById(event.roomId);
    if (room == null) return 0;
    room.title = event.name;
    return Future.value(1);
  }

  @override
  Future<int> updateCountToZero(
    VUpdateRoomUnReadCountToZeroEvent event,
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

  Future<int> setAllOffline() async {
    for (final element in _rooms) {
      element.isOnline = false;
      element.typingStatus = VSocketRoomTypingModel.offline;
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

  @override
  Future<bool> isRoomExist(String roomId) async {
    return _rooms.firstWhereOrNull((e) => e.id == roomId) != null;
  }

  @override
  Future<int> updateTransTo(VUpdateTransToEvent event) async {
    final room = getRoomById(event.roomId);
    if (room == null) return 0;
    room.transTo = event.transTo;
    return Future.value(1);
  }
}
