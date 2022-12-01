import '../../../../v_chat_sdk_core.dart';

abstract class BaseLocalRoomRepo {
  Future<int> insert(InsertRoomEvent event);

  Future<int> updateBlockSingleRoom(BlockSingleRoomEvent event);

  Future<int> updateOnline(UpdateRoomOnlineEvent event);

  Future<int> updateTyping(UpdateRoomTypingEvent event);

  Future<int> updateName(UpdateRoomNameEvent event);

  Future<int> insertMany(List<VBaseRoom> rooms);

  Future<int> updateImage(UpdateRoomImageEvent event);

  Future<int> updateCountByOne(UpdateRoomUnReadCountByOneEvent event);

  Future<int> updateCountToZero(UpdateRoomUnReadCountToZeroEvent event);

  Future<int> updateIsMuted(UpdateRoomMuteEvent event);

  Future<int> delete(DeleteRoomEvent event);

  Future<void> reCreate();

  Future<int> setAllOffline();

  Future<VBaseRoom?> getOneByPeerId(String roomId);

  Future<String?> getRoomIdByPeerId(String peerId);

  Future<VBaseRoom?> getOneWithLastMessageByRoomId(String roomId);

  Future<List<VBaseRoom>> search(String text, RoomType? roomType);

  Future<List<VBaseRoom>> getRoomsWithLastMessage({int limit = 300});
}
