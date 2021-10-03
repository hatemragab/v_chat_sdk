import 'package:get/get.dart';

import '../../../models/vchat_message.dart';
import '../../../models/vchat_room.dart';
import '../../../utils/api_utils/dio/custom_dio.dart';
import '../../../utils/api_utils/dio/server_default_res.dart';

class MessageProvider extends DisposableInterface {
  Future<List<VchatMessage>> getRoomMessages(int roomId) async {
    final List<VchatMessage> _localMessages = [];
    return _localMessages;
  }

  Future<List<VchatMessage>> loadMoreMessages(
    int roomId,
    String lastMessageId,
  ) async {
    final messages = (await CustomDio().send(
            reqMethod: "GET",
            path: "message",
            query: {"id": lastMessageId, "roomId": roomId.toString()}))
        .data['data'] as List;
    return messages.map((e) => VchatMessage.fromMap(e)).toList();
  }



  Future<ServerDefaultResponse> acceptRoom(VchatRoom currentRoom) async {
    final res = await CustomDio().send(
      reqMethod: "POST",
      path: "roomMember/accept-room",
      body: {"roomId": currentRoom.id},
    );
    return ServerDefaultResponse.fromMap(res.data);
  }

  Future readMessages(int roomId) async {}
}
