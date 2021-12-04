import '../../models/v_chat_room.dart';
import '../../utils/api_utils/dio/custom_dio.dart';

class RoomsApiProvider {
  Future<List<VChatRoom>> loadMore(int page) async {
    final roomsMaps = (await CustomDio()
            .send(reqMethod: "GET", path: "room", query: {"page": page}))
        .data['data'] as List;
    return roomsMaps.map((e) => VChatRoom.fromMap(e)).toList();
  }

  Future blockOrUnBlock(String ifSinglePeerId) async {
    await CustomDio().send(
      reqMethod: "POST",
      path: "room/ban-chat-user",
      body: {"peerId": ifSinglePeerId},
    );
  }

  Future leaveGroupChat(String id) async {
    await CustomDio().send(
      reqMethod: "DELETE",
      path: "room/leave/$id",
    );
  }

  Future changeNotifaictions(String roomId) async {
    return (await CustomDio().send(
            reqMethod: "POST",
            path: "room/chat-notification",
            body: {"roomId": roomId.toString()}))
        .data['data'];
  }
}
