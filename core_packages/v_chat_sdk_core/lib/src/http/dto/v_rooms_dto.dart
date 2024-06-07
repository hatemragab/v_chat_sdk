// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

/// This class is used to carry the data related to rooms in the VChat application.
class VRoomsDto {
  /// Constructs a new `VRoomsDto`.
  ///
  /// The [limit] parameter specifies the maximum number of rooms that can be returned,
  /// defaulting to 20 if not provided.
  ///
  /// The [page] parameter specifies the page number for pagination purposes,
  /// defaulting to 1 if not provided.
  ///
  /// The [title] parameter specifies the title of the room.
  ///
  /// The [roomType] parameter specifies the type of room.
  ///
  /// The [mutedOnly] parameter, if true, fetches only muted rooms.
  ///
  /// The [archiveOnly] parameter, if true, fetches only archived rooms.
  ///
  /// The [deletedOnly] parameter, if true, fetches only deleted rooms.
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

  /// Returns a map with keys and values representing object state.
  Map<String, dynamic> toMap() {
    return {
      'limit': limit,
      'page': page,
      'title': title,
      'roomType': roomType?.name,
      'mutedOnly': mutedOnly,
      'archiveOnly': archiveOnly,
      'deletedOnly': deletedOnly,
    };
  }
}
