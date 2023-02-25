// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:diacritic/diacritic.dart';
import 'package:sqflite/sqflite.dart';
import 'package:v_chat_sdk_core/src/local_db/core/abstraction/base_local_room_repo.dart';
import 'package:v_chat_sdk_core/src/local_db/tables/message_table.dart';
import 'package:v_chat_sdk_core/src/local_db/tables/room_table.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class SqlRoomImp extends BaseLocalRoomRepo {
  final Database _database;
  final _id = RoomTable.columnId;
  final _table = RoomTable.tableName;

  SqlRoomImp(this._database);

  @override
  Future<int> delete(VDeleteRoomEvent event) {
    return _database.delete(
      _table,
      where: "$_id =?",
      whereArgs: [event.roomId],
    );
  }

  @override
  Future<int> insert(VInsertRoomEvent event) {
    return _database.insert(
      _table,
      event.room.toLocalMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  @override
  Future<List<VRoom>> search(
    String text,
    int limit,
    VRoomType? roomType,
  ) async {
    if (roomType == null) {
      final maps = await _database.rawQuery(
        _prefixRoomFilterQuery(
          "WHERE r1.${RoomTable.columnEnTitle} LIKE '${removeDiacritics(text)}%'",
          150,
        ),
      );
      return maps.map((e) => VRoom.fromLocalMap(e)).toList();
    }
    final maps = await _database.rawQuery(
      _prefixRoomFilterQuery(
        "WHERE r1.${RoomTable.columnRoomType} = '${roomType.name}' AND r1.${RoomTable.columnEnTitle} LIKE '${removeDiacritics(text)}%'",
        150,
      ),
    );
    return maps.map((e) => VRoom.fromLocalMap(e)).toList();
  }

  // @override
  // Future<int> updateBlockRoom(VBlockRoomEvent event) {
  //   return _database.update(
  //     _table,
  //     {
  //       RoomTable.columnBlockerId: event.banModel.bannerId,
  //     },
  //     where: "$_id =?",
  //     whereArgs: [event.roomId],
  //   );
  // }

  @override
  Future<int> updateCountByOne(VUpdateRoomUnReadCountByOneEvent event) {
    return _database.rawUpdate(
      "UPDATE $_table SET ${RoomTable.columnUnReadCount} = ${RoomTable.columnUnReadCount} + 1 WHERE ${RoomTable.columnId} =?",
      [event.roomId],
    );
  }

  @override
  Future<int> updateCountToZero(VUpdateRoomUnReadCountToZeroEvent event) {
    return _database.update(
      _table,
      {
        RoomTable.columnUnReadCount: 0,
      },
      where: "$_id =?",
      whereArgs: [event.roomId],
    );
  }

  @override
  Future<int> updateImage(VUpdateRoomImageEvent event) {
    return _database.update(
      _table,
      {
        RoomTable.columnThumbImage: event.image,
      },
      where: "$_id =?",
      whereArgs: [event.roomId],
    );
  }

  @override
  Future<int> updateIsMuted(VUpdateRoomMuteEvent event) {
    return _database.update(
      _table,
      {
        RoomTable.columnIsMuted: event.isMuted ? 1 : 0,
      },
      where: "$_id =?",
      whereArgs: [event.roomId],
    );
  }

  @override
  Future<int> updateName(VUpdateRoomNameEvent event) {
    return _database.update(
      _table,
      {
        RoomTable.columnTitle: event.name,
      },
      where: "$_id =?",
      whereArgs: [event.roomId],
    );
  }

  // @override
  // Future<int> updateOnline(UpdateRoomOnlineEvent event) {
  //   return _database.update(
  //     _table,
  //     {
  //       RoomTable.columnIsOnline: event.model.isOnline ? 1 : 0,
  //     },
  //     where: "$_id =?",
  //     whereArgs: [event.roomId],
  //   );
  // }

  // @override
  // Future<int> updateTyping(UpdateRoomTypingEvent event) {
  //   return _database.update(
  //     _table,
  //     {
  //       RoomTable.columnRoomTyping: jsonEncode(event.typingModel.toMap()),
  //     },
  //     where: "$_id =?",
  //     whereArgs: [event.roomId],
  //   );
  // }

  @override
  Future<List<VRoom>> getRoomsWithLastMessage({int limit = 300}) async {
    final maps = await _database.rawQuery(
      _prefixRoomFilterQuery(null, limit),
    );
    return maps.map((e) => VRoom.fromLocalMap(e)).toList();
  }

  String _prefixRoomFilterQuery(String? where, int? limit) {
    return '''
    SELECT *  FROM ${RoomTable.tableName} as r1
    INNER JOIN(
    SELECT *
    FROM ${MessageTable.tableName}  as t
    GROUP BY ${MessageTable.columnRoomId}
    HAVING MAX(t.${MessageTable.columnId})
    ORDER BY t.${MessageTable.columnId} DESC
    ) j1 ON r1.${RoomTable.columnId} = j1.${MessageTable.columnRoomId}
    ${where ?? ''} 
    ORDER BY j1.${MessageTable.columnId} DESC  
    ${limit != null ? 'LIMIT $limit' : ''} 
    ''';
  }

  // @override
  // Future<int> setAllOffline() {
  //   return _database.update(
  //     _table,
  //     {
  //       RoomTable.columnIsOnline: 0,
  //       RoomTable.columnRoomTyping:
  //           jsonEncode(VSocketRoomTypingModel.offline.toMap()),
  //     },
  //   );
  // }

  @override
  Future<int> insertMany(List<VRoom> rooms) async {
    final batch = _database.batch();
    for (final e in rooms) {
      batch.insert(
        _table,
        e.toLocalMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
    return 1;
  }

  @override
  Future<VRoom?> getOneWithLastMessageByRoomId(String roomId) async {
    final maps = await _database.rawQuery(
      _prefixRoomFilterQuery("WHERE r1.$_id ='$roomId'", 1),
    );
    if (maps.isEmpty) return null;
    return VRoom.fromLocalMap(maps.first);
  }

  @override
  Future<void> reCreate() async {
    return _database.transaction((txn) => RoomTable.recreateTable(txn));
  }

  @override
  Future<String?> getRoomIdByPeerId(String peerId) async {
    final map = await _database.query(
      _table,
      where: "${RoomTable.columnPeerId} =?",
      whereArgs: [peerId],
    );
    if (map.isEmpty) return null;
    return map.first[RoomTable.columnId].toString();
  }

  @override
  Future<VRoom?> getOneByPeerId(String peerId) async {
    final maps = await _database.rawQuery(
      _prefixRoomFilterQuery(
        "WHERE r1.${RoomTable.columnPeerId} = '$peerId'",
        1,
      ),
    );
    return maps.isEmpty ? null : VRoom.fromLocalMap(maps.first);
  }

  @override
  Future<bool> isRoomExist(String roomId) async {
    final maps = await _database.query(
      _table,
      where: "$_id =?",
      whereArgs: [roomId],
      limit: 1,
    );
    return maps.isNotEmpty;
  }

  @override
  Future<int> updateTransTo(VUpdateTransToEvent event) {
    return _database.update(
      _table,
      {
        RoomTable.columnTransTo: event.transTo,
      },
      where: "$_id =?",
      whereArgs: [event.roomId],
    );
  }
}
