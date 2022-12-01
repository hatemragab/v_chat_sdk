import 'package:v_chat_sdk_core/src/models/v_room/single_room/single_room.dart';

import '../../../v_chat_sdk_core.dart';
import '../../local_db/tables/room_table.dart';
import 'base_room.dart';
import 'broadcast/broadcast_room.dart';
import 'group/group_room.dart';

abstract class RoomFactory {
  static VBaseRoom createRoom(Map<String, dynamic> map) {
    if (map[RoomTable.columnRoomType] != null) {
      return _createLocalRoom(map);
    }
    final type = RoomType.values.byName(map['rT'] as String);
    switch (type) {
      case RoomType.s:
        return VSingleRoom.fromMap(map);
      case RoomType.g:
        return VGroupRoom.fromMap(map);
      case RoomType.b:
        return VBroadcastRoom.fromMap(map);
    }
  }

  static VBaseRoom _createLocalRoom(Map<String, dynamic> map) {
    final type =
        RoomType.values.byName(map[RoomTable.columnRoomType] as String);
    switch (type) {
      case RoomType.s:
        return VSingleRoom.fromLocalMap(map);
      case RoomType.g:
        return VGroupRoom.fromLocalMap(map);
      case RoomType.b:
        return VBroadcastRoom.fromLocalMap(map);
    }
  }
}
