import '../../../models/v_chat_message.dart';
import '../../../utils/api_utils/dio/custom_dio.dart';

class MessageProvider {
  Future<List<VChatMessage>> loadMoreMessages(
    String roomId,
    String lastId,
  ) async {
    final messages = (await CustomDio().send(
      reqMethod: "GET",
      path: "message",
      query: {"lastId": lastId, "roomId": roomId},
    ))
        .data['data'] as List;
    return messages.map((e) => VChatMessage.fromMap(e)).toList();
  }
}
