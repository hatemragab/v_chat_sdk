// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/src/local_db/tables/message_table.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

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
    // assert(!(filter != null && between != null));
  }

  final int limit;
  String? lastId;
  final String? text;
  final VMessagesFilter? filter;
  final VMessageBetweenFilter? between;

  Map<String, dynamic> toMap() {
    return {
      'limit': limit,
      'lastId': lastId,
      'text': text,
      'filter': filter == null ? VMessagesFilter.all.name : filter!.name,
    };
  }

  Map<String, dynamic> toLocalMap() {
    return {
      'limit': limit,
      MessageTable.columnId: lastId,
      MessageTable.columnContent: text,
      MessageTable.columnMessageType:
          filter == null ? VMessagesFilter.all.name : filter!.name,
    };
  }
}
