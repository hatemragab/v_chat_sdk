import '../../../v_chat_sdk_core.dart';
import '../../local_db/tables/message_table.dart';

class VMessageBetweenFilter {
  final String targetId;
  final String lastId;

  VMessageBetweenFilter({
    required this.targetId,
    required this.lastId,
  });
}

class VRoomMessagesDto {
  VRoomMessagesDto({
    this.limit = 30,
    this.lastId,
    this.text,
    this.filter,
    this.between,
  }) {
    assert(!(filter != null && between != null));
  }

  final int limit;
  String? lastId;
  final String? text;
  final MessagesFilter? filter;
  final VMessageBetweenFilter? between;

  Map<String, dynamic> toMap() {
    return {
      'limit': limit,
      'lastId': lastId,
      'text': text,
      'filter': filter == null ? MessagesFilter.all.name : filter!.name,
    };
  }

  Map<String, dynamic> toLocalMap() {
    return {
      'limit': limit,
      MessageTable.columnId: lastId,
      MessageTable.columnContent: text,
      MessageTable.columnMessageType:
          filter == null ? MessagesFilter.all.name : filter!.name,
    };
  }
}
