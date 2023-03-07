// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class VRoomsDto {
  const VRoomsDto({
    this.limit = 20,
    this.page = 1,
    this.title,
    this.roomType,
    this.mutedOnly,
    this.archiveOnly,
    this.deletedOnly,
  });

  final int limit;
  final int page;
  final String? title;
  final VRoomType? roomType;
  final bool? mutedOnly;
  final bool? archiveOnly;
  final bool? deletedOnly;

  Map<String, dynamic> toMap() {
    return {
      'limit': limit,
      'page': page,
      'title': title,
      'roomType': roomType == null ? null : roomType!.name,
      'mutedOnly': mutedOnly,
      'archiveOnly': archiveOnly,
      'deletedOnly': deletedOnly,
    };
  }
}
