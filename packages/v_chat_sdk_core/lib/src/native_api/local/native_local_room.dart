import 'package:sqflite/sqlite_api.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../v_chat_sdk_core.dart';
import '../../local_db/core/abstraction/base_local_room_repo.dart';
import '../../local_db/core/imp/room/memory_room_imp.dart';
import '../../local_db/core/imp/room/sql_room_imp.dart';
import '../../models/v_room/single_room/single_ban_model.dart';
import '../../utils/event_bus.dart';

class NativeLocalRoom {
  late final BaseLocalRoomRepo _roomRepo;
  final _emitter = EventBusSingleton.instance.vChatEvents;

  Stream<VRoomEvents> get roomStream => _emitter.on<VRoomEvents>();

  NativeLocalRoom(Database database) {
    if (VPlatforms.isWeb) {
      _roomRepo = MemoryRoomImp();
    } else {
      _roomRepo = SqlRoomImp(database);
    }
  }

  // Future<int> prepareRooms() async {
  //   return _roomRepo.setAllOffline();
  // }

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
      _emitter.fire(event);
    }
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

  Future<int> updateRoomOnline(VUpdateRoomOnlineEvent event) async {
    final roomId = await _roomRepo.getRoomIdByPeerId(event.model.peerId);
    if (roomId != null) {
      _emitter.fire(VUpdateRoomOnlineEvent(model: event.model, roomId: roomId));
      return 1;
      // return _roomRepo.updateOnline(event);
    }
    return 1;
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
    VUpdateRoomUnReadCountToZeroEvent event,
  ) async {
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

  Future<void> reCreateRoomTable() {
    return _roomRepo.reCreate();
  }

// Future<int> offAllRooms() async {
//   await _roomRepo.setAllOffline();
//   return 1;
// }
}
