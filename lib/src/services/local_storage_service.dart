import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../models/v_chat_message.dart';
import '../models/v_chat_room.dart';
import '../sqlite/db_provider.dart';
import '../sqlite/tables/message_table.dart';
import '../sqlite/tables/room_table.dart';

class LocalStorageService {
  LocalStorageService._privateConstructor();

  static final LocalStorageService instance =
      LocalStorageService._privateConstructor();

  late Database database;

  Future<void> init() async {
    database = await DBProvider.instance.database;
  }

  Future<List<VChatRoom>> getRooms() async {
    final maps = await database.query(RoomTable.tableName,
        orderBy: "${RoomTable.columnUpdatedAt} DESC");
    final rooms = <VChatRoom>[];
    for (var map in maps) {
      final r =
          VChatRoom.fromMap(jsonDecode(map[RoomTable.columnData].toString()));
      rooms.add(r);
    }

    return rooms;
  }

  Future setRooms(List<VChatRoom> rooms) async {
    //await database.delete(NewRoomTable.TABLE_NAME);
    final roomsToInsert = rooms;
    try {
      final x = rooms.sublist(0, 20);
      roomsToInsert.clear();
      roomsToInsert.addAll(x);
    } catch (err) {
      //
    }

    final batch = database.batch();
    for (var room in roomsToInsert) {
      batch.insert(
          RoomTable.tableName,
          {
            RoomTable.columnId: room.id,
            RoomTable.columnUpdatedAt: room.updatedAt,
            RoomTable.columnData: jsonEncode(room.toLocalMap())
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future setRoomOrUpdate(VChatRoom room) async {
    await insertMessage(room.id.toString(), room.lastMessage);
    await database.insert(
        RoomTable.tableName,
        {
          RoomTable.columnId: room.id,
          RoomTable.columnUpdatedAt: room.updatedAt,
          RoomTable.columnData: jsonEncode(room.toLocalMap())
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future setRoomMessages(String roomId, List<VChatMessage> messages) async {
    final messageToInsert = messages;
    try {
      final x = messages.sublist(0, 30);
      messageToInsert.clear();
      messageToInsert.addAll(x);
    } catch (err) {
      //
    }
    await database.delete(MessageTable.tableName,
        where: "${MessageTable.columnRoomId} =?", whereArgs: [roomId]);

    final batch = database.batch();
    for (var msg in messageToInsert) {
      batch.insert(
        MessageTable.tableName,
        {
          MessageTable.columnId: msg.id,
          MessageTable.columnRoomId: msg.roomId,
          MessageTable.columnData: jsonEncode(msg.toLocalMap())
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
    await batch.commit(noResult: true);
  }

  Future insertMessage(String roomId, VChatMessage msg) async {
    await database.insert(
      MessageTable.tableName,
      {
        MessageTable.columnId: msg.id,
        MessageTable.columnRoomId: msg.roomId,
        MessageTable.columnData: jsonEncode(msg.toLocalMap())
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<VChatMessage>> getRoomMessages(String roomId) async {
    final messages = <VChatMessage>[];
    final maps = await database.query(MessageTable.tableName,
        where: "${MessageTable.columnRoomId} =?",
        whereArgs: [roomId],
        limit: 30,
        orderBy: "${MessageTable.columnId} DESC");

    for (var x in maps) {
      messages.add(
        VChatMessage.fromMap(
          jsonDecode(x[MessageTable.columnData].toString()),
        ),
      );
    }

    return messages;
  }

  Future deleteRoom(String id) async {
    await database.delete(RoomTable.tableName,
        where: "${RoomTable.columnId}=?", whereArgs: [id]);
  }
}
