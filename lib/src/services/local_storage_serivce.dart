import 'dart:convert';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import '../models/v_chat_message.dart';
import '../models/v_chat_room.dart';
import '../sqlite/db_provider.dart';
import '../sqlite/tables/message_table.dart';
import '../sqlite/tables/room_table.dart';

class LocalStorageService extends GetxService {
  late Database database;

  Future<LocalStorageService> init() async {
    database = await DBProvider.db.database;
    return this;
  }

  Future<List<VchatRoom>> getRooms() async {
    final maps = await database.query(RoomTable.TABLE_NAME,
        orderBy: "${RoomTable.COLUMN_UPDATED_AT} DESC");
    final rooms = <VchatRoom>[];
    for (var map in maps) {
      final r = VchatRoom.fromMap(
          jsonDecode(map[RoomTable.COLUMN_DATA].toString()));
      rooms.add(r);
    }
    return rooms;
  }

  Future setRooms(List<VchatRoom> rooms) async {
    //await database.delete(NewRoomTable.TABLE_NAME);
    final roomsToInsert = rooms;
    try {
      final x = rooms.sublist(0, 20);
      roomsToInsert.assignAll(x);
    } catch (err) {}

    final batch = database.batch();
    for (var room in roomsToInsert) {
      batch.insert(RoomTable.TABLE_NAME, {
        RoomTable.COLUMN_ID: room.id,
        RoomTable.COLUMN_UPDATED_AT: room.updatedAt,
        RoomTable.COLUMN_DATA: jsonEncode(room.toLocalMap())
      },conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future setRoomOrUpdate(VchatRoom room) async {
    await database.insert(
        RoomTable.TABLE_NAME,
        {
          RoomTable.COLUMN_ID: room.id,
          RoomTable.COLUMN_UPDATED_AT: room.updatedAt,
          RoomTable.COLUMN_DATA: jsonEncode(room.toLocalMap())
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future setRoomMessages(String roomId, List<VChatMessage> messages) async {
    final messageToInsert = messages;
    try {
      final x = messages.sublist(0, 30);
      messageToInsert.assignAll(x);
    } catch (err) {}
    await database.delete(MessageTable.TABLE_NAME,
        where: "${MessageTable.COLUMN_ROOM_ID} =?",
        whereArgs: [int.parse(roomId)]);

    final batch = database.batch();
    for (var msg in messageToInsert) {
      batch.insert(
        MessageTable.TABLE_NAME,
        {
          MessageTable.COLUMN_ID: msg.id,
          MessageTable.COLUMN_ROOM_ID: msg.roomId,
          MessageTable.COLUMN_DATA: jsonEncode(msg.toLocalMap())
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
    await batch.commit(noResult: true);
  }

  Future insertMessage(String roomId, VChatMessage msg) async {
    await database.insert(
      MessageTable.TABLE_NAME,
      {
        MessageTable.COLUMN_ID: msg.id,
        MessageTable.COLUMN_ROOM_ID: msg.roomId,
        MessageTable.COLUMN_DATA: jsonEncode(msg.toLocalMap())
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<VChatMessage>> getRoomMessages(int roomId) async {
    final messages = <VChatMessage>[];
    final maps = await database.query(MessageTable.TABLE_NAME,
        where: "${MessageTable.COLUMN_ROOM_ID} =?",
        whereArgs: [roomId],
        limit: 30,
        orderBy: "${MessageTable.COLUMN_ID} DESC");

    for (var x in maps) {
      messages.add(
        VChatMessage.fromMap(
          jsonDecode(x[MessageTable.COLUMN_DATA].toString()),
        ),
      );
    }

    return messages;
  }

  Future deleteRoom(int id) async {
    await database.delete(RoomTable.TABLE_NAME,
        where: "${RoomTable.COLUMN_ID}=?", whereArgs: [id]);
  }
}
