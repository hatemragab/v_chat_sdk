import '../../../../v_chat_sdk_core.dart';

abstract class BaseLocalRoomRepo {
  Future<int> insert(InsertRoomEvent event);

  Future<int> updateBlockSingleRoom(BlockSingleRoomEvent event);

  Future<int> updateOnline(UpdateRoomOnlineEvent event);

  Future<int> updateTyping(UpdateRoomTypingEvent event);

  Future<int> updateName(UpdateRoomNameEvent event);

  Future<int> insertMany(List<VRoom> rooms);

  Future<int> updateImage(UpdateRoomImageEvent event);

  Future<int> updateCountByOne(UpdateRoomUnReadCountByOneEvent event);

  Future<int> updateCountToZero(UpdateRoomUnReadCountToZeroEvent event);

  Future<int> updateIsMuted(UpdateRoomMuteEvent event);

  Future<int> delete(DeleteRoomEvent event);

  Future<void> reCreate();

  Future<int> setAllOffline();

  Future<VRoom?> getOneByPeerId(String roomId);

  Future<String?> getRoomIdByPeerId(String peerId);

  Future<VRoom?> getOneWithLastMessageByRoomId(String roomId);

  Future<List<VRoom>> search(String text, int limit, RoomType? roomType);

  Future<List<VRoom>> getRoomsWithLastMessage({int limit = 300});
}
