import 'package:sqflite/sqflite.dart';

class MessageTable {
  MessageTable._();

  static const tableName = 'tb_message';
  static const columnId = '${tableName}_id';
  static const columnData = '${tableName}_data';
  static const columnRoomId = '${tableName}_room_id';

  static Future<void> recreateTable(Database db) async {
    await db.execute(
      '''
          drop table if exists $tableName
        ''',
    );
    await MessageTable.createTable(db);
  }

  static Future<void> createTable(dynamic db) async {
    await db.execute(
      '''
          create table $tableName (
       
            $columnId       BIGINT PRIMARY KEY ,
            $columnData     TEXT,
            $columnRoomId  TEXT
            
             
            )        
          ''',
    );

    await db.execute(
      '''
      CREATE INDEX idx_id_$tableName
      ON $tableName ($columnId)
    ''',
    );
  }
}
