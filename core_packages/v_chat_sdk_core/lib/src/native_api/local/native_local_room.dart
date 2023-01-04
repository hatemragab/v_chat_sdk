import 'package:sqflite/sqlite_api.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../v_chat_sdk_core.dart';
import '../../local_db/core/abstraction/base_local_room_repo.dart';
import '../../local_db/core/imp/room/memory_room_imp.dart';
import '../../local_db/core/imp/room/sql_room_imp.dart';
import 'native_local_message.dart';

class NativeLocalRoom {
  late final BaseLocalRoomRepo _roomRepo;
  final NativeLocalMessage _localMessage;
  final _emitter = VEventBusSingleton.vEventBus;

  NativeLocalRoom(Database database, this._localMessage) {
    if (VPlatforms.isWeb) {
      _roomRepo = MemoryRoomImp();
    } else {
      _roomRepo = SqlRoomImp(database);
    }
  }

  Future<List<VRoom>> getRooms({int limit = 300}) async {
    return _roomRepo.getRoomsWithLastMessage(limit: limit);
  }

  Future<VRoom?> getRoomById(String id) {
    return _roomRepo.getOneWithLastMessageByRoomId(id);
  }

  Future<void> safeInsertRoom(VRoom room) async {
    if (await _roomRepo.getOneWithLastMessageByRoomId(room.id) == null) {
      final event = VInsertRoomEvent(roomId: room.id, room: room);
      await _roomRepo.insert(event);
      await _localMessage.safeInsertMessage(room.lastMessage);
      _emitter.fire(event);
    }
  }

  Future<int> cacheRooms(List<VRoom> rooms) async {
    if (rooms.isEmpty) {
      await _roomRepo.reCreate();
      return 1;
    }
    await _localMessage
        .cacheRoomMessages(rooms.map((e) => e.lastMessage).toList());
    return _roomRepo.insertMany(
      rooms,
    );
  }

  Future<int?> updateRoomTyping(VSocketRoomTypingModel typing) async {
    final event =
        VUpdateRoomTypingEvent(roomId: typing.roomId, typingModel: typing);
    _emitter.fire(event);
    return 1;
    // return _roomRepo.updateTyping(event);
  }

  Future<int> updateRoomSingleBlock(
      VSingleBanModel block, String roomId) async {
    final event = VBlockSingleRoomEvent(banModel: block, roomId: roomId);
    _emitter.fire(event);
    return 1;
  }

  void updateRoomOnline(List<VOnlineOfflineModel> events) {
    for (var event in events) {
      _emitter.fire(event);
      // _emitter.fire(VSocketUpdateOnlineList(
      //   model: event,
      //   roomId: event.roomId,
      // ));
    }
  }

  Future<int> updateRoomName(VUpdateRoomNameEvent event) async {
    _emitter.fire(event);
    return _roomRepo.updateName(event);
  }

  Future<int> updateRoomImage(VUpdateRoomImageEvent event) async {
    _emitter.fire(event);
    return _roomRepo.updateImage(event);
  }

  Future<int> updateRoomUnreadCountAddOne(
    String roomId,
  ) async {
    final event = VUpdateRoomUnReadCountByOneEvent(roomId: roomId);
    _emitter.fire(event);
    return _roomRepo.updateCountByOne(event);
  }

  Future<int> updateRoomUnreadToZero(
    String roomId,
  ) async {
    final event = VUpdateRoomUnReadCountToZeroEvent(roomId: roomId);
    _emitter.fire(event);
    return _roomRepo.updateCountToZero(event);
  }

  Future<int> updateRoomIsMuted(VUpdateRoomMuteEvent event) async {
    _emitter.fire(event);
    return _roomRepo.updateIsMuted(event);
  }

  Future<List<VRoom>> searchRoom({
    required String text,
    int limit = 20,
  }) async {
    return _roomRepo.search(text, limit, null);
  }

  Future<VRoom?> getRoomByPeerId(String peerId) async {
    return _roomRepo.getOneByPeerId(peerId);
  }

  Future<void> deleteRoom(String roomId) async {
    await _localMessage.deleteMessageByRoomId(roomId);
    await _roomRepo.delete(VDeleteRoomEvent(roomId: roomId));
    _emitter.fire(VDeleteRoomEvent(roomId: roomId));
  }

  Future<void> reCreateRoomTable() {
    return _roomRepo.reCreate();
  }
}
