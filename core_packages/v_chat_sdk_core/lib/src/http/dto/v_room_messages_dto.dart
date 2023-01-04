import '../../../v_chat_sdk_core.dart';

class VRoomMessagesDto {
  const VRoomMessagesDto({
    this.limit = 30,
    this.lastId,
    this.text,
    this.filter,
  });

  final int limit;
  final String? lastId;
  final String? text;
  final MessagesFilter? filter;

  Map<String, dynamic> toMap() {
    return {
      'limit': limit,
      'lastId': lastId,
      'text': text,
      'filter': filter == null ? MessagesFilter.all.name : filter!.name,
    };
  }
}
