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
    final maps = await database.query(
      RoomTable.tableName,
      orderBy: "${RoomTable.columnUpdatedAt} DESC",
    );
    final rooms = <VChatRoom>[];
    for (final map in maps) {
      final r =
          VChatRoom.fromMap(jsonDecode(map[RoomTable.columnData].toString()));
      rooms.add(r);
    }

    return rooms;
  }

  Future setRooms(List<VChatRoom> rooms) async {
    //await database.delete(NewRoomTable.TABLE_NAME);
    final roomsToInsert = rooms;
    if (rooms.isEmpty) {
      await database.delete(RoomTable.tableName);
      return;
    }
    final batch = database.batch();
    for (final room in roomsToInsert) {
      batch.insert(
        RoomTable.tableName,
        {
          RoomTable.columnId: room.id,
          RoomTable.columnUpdatedAt: room.updatedAt,
          RoomTable.columnData: jsonEncode(room.toLocalMap())
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future setRoomOrUpdate(VChatRoom room) async {
    await insertMessage(room.id, room.lastMessage);
    await database.insert(
      RoomTable.tableName,
      {
        RoomTable.columnId: room.id,
        RoomTable.columnUpdatedAt: room.updatedAt,
        RoomTable.columnData: jsonEncode(room.toLocalMap())
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future setRoomMessages(
    String roomId,
    List<VChatMessage> messageToInsert,
  ) async {
    final batch = database.batch();
    for (final msg in messageToInsert) {
      batch.insert(
        MessageTable.tableName,
        {
          MessageTable.columnId: msg.id,
          MessageTable.columnRoomId: msg.roomId,
          MessageTable.columnData: jsonEncode(msg.toLocalMap())
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
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
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<VChatMessage>> getRoomMessages(String roomId) async {
    final messages = <VChatMessage>[];
    final maps = await database.query(
      MessageTable.tableName,
      where: "${MessageTable.columnRoomId} =?",
      whereArgs: [roomId],
      limit: 30,
      orderBy: "${MessageTable.columnId} DESC",
    );

    for (final x in maps) {
      // Helpers.vlog(x.toString());
      messages.add(
        VChatMessage.fromMap(
          jsonDecode(x[MessageTable.columnData].toString()),
        ),
      );
    }

    return messages;
  }

  Future deleteRoom(String id) async {
    await database.delete(
      RoomTable.tableName,
      where: "${RoomTable.columnId}=?",
      whereArgs: [id],
    );
  }
}
