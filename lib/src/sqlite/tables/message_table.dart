import 'package:sqflite/sqflite.dart';

class MessageTable {
  static const tableName = 'tb_message';
  static const COLUMN_ID = '${tableName}_id';
  static const COLUMN_DATA = '${tableName}_data';
  static const COLUMN_ROOM_ID = '${tableName}_room_id';

  static Future<void> recreateTable(Database db) async {
    await db.execute('''
          drop table if exists $tableName
        ''');
    await MessageTable.createTable(db);
  }

  static Future<void> createTable(dynamic db) async {
    await db.execute('''
          create table $tableName (
       
            $COLUMN_ID       BIGINT PRIMARY KEY ,
            $COLUMN_DATA          TEXT,
            $COLUMN_ROOM_ID  BIGINT
            
             
            )        
          ''');

    await db.execute('''
      CREATE INDEX idx_id_$tableName
      ON $tableName ($COLUMN_ID)
    ''');
  }
}
