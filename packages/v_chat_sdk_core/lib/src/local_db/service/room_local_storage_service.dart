import 'package:sqflite/sqflite.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../v_chat_sdk_core.dart';
import '../../models/v_room/single_room/single_ban_model.dart';
import '../../utils/event_bus.dart';
import '../core/abstraction/base_local_room_repo.dart';
import '../core/imp/room/memory_room_imp.dart';
import '../core/imp/room/sql_room_imp.dart';

mixin RoomLocalStorageService {
  late BaseLocalRoomRepo localRoomRepo;
  final emitter = EventBusSingleton.instance.vChatEvents;

  initRoomLocalStorage({
    required Database database,
  }) {
    if (VPlatforms.isWeb) {
      localRoomRepo = MemoryRoomImp();
    } else {
      localRoomRepo = SqlRoomImp(database);
    }
  }

  Future<List<VRoom>> getRooms({int limit = 300}) async {
    return localRoomRepo.getRoomsWithLastMessage(limit: limit);
  }

  Future<VRoom?> getRoomById(String id) {
    return localRoomRepo.getOneWithLastMessageByRoomId(id);
  }

  Future<int?> updateRoomTyping(VSocketRoomTypingModel typing) async {
    final event =
        VUpdateRoomTypingEvent(roomId: typing.roomId, typingModel: typing);
    emitter.fire(event);
    return 1;
    // return localRoomRepo.updateTyping(event);
  }

  Future<int> updateRoomSingleBlock(
      VSingleBanModel block, String roomId) async {
    final event = VBlockSingleRoomEvent(banModel: block, roomId: roomId);
    emitter.fire(event);
    return 1;
  }

  Future<int> updateRoomOnline(VUpdateRoomOnlineEvent event) async {
    final roomId = await localRoomRepo.getRoomIdByPeerId(event.model.peerId);
    if (roomId != null) {
      emitter.fire(VUpdateRoomOnlineEvent(
        roomId: roomId,
        model: event.model,
      ));
      return 1;
      // return localRoomRepo.updateOnline(event);
    }
    return 1;
  }

  Future<int> updateRoomName(VUpdateRoomNameEvent event) async {
    emitter.fire(event);
    return localRoomRepo.updateName(event);
  }

  Future<int> updateRoomImage(VUpdateRoomImageEvent event) async {
    emitter.fire(event);
    return localRoomRepo.updateImage(event);
  }

  Future<int> updateRoomUnreadCountAddOne(
    VUpdateRoomUnReadCountByOneEvent event,
  ) async {
    emitter.fire(event);
    return localRoomRepo.updateCountByOne(event);
  }

  Future<int> updateRoomUnreadToZero(
    VUpdateRoomUnReadCountToZeroEvent event,
  ) async {
    emitter.fire(event);
    return localRoomRepo.updateCountToZero(event);
  }

  Future<int> updateRoomIsMuted(VUpdateRoomMuteEvent event) async {
    emitter.fire(event);
    return localRoomRepo.updateIsMuted(event);
  }

  Future<List<VRoom>> searchRoom({
    required String text,
    int limit = 20,
  }) async {
    return localRoomRepo.search(text, limit, null);
  }

  Future<VRoom?> getRoomByPeerId(String peerId) async {
    return localRoomRepo.getOneByPeerId(peerId);
  }

  Future<void> reCreateRoomTable() {
    return localRoomRepo.reCreate();
  }

// Future<int> offAllRooms() async {
//   await localRoomRepo.setAllOffline();
//   return 1;
// }
}
