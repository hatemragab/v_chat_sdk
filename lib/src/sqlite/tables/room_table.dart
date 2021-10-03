import 'package:sqflite/sqflite.dart';

class RoomTable {
  static const TABLE_NAME = 'tb_room';
  static const COLUMN_ID = '${TABLE_NAME}_id';
  static const COLUMN_DATA = '${TABLE_NAME}_data';
  static const COLUMN_UPDATED_AT = '${TABLE_NAME}_updated_at';

  static Future<void> recreateTable(Database db) async {
    await db.execute('''
          drop table if exists $TABLE_NAME
        ''');
    await RoomTable.createTable(db);
  }

  static Future<void> createTable(dynamic db) async {
    await db.execute('''
          create table $TABLE_NAME (
       
            $COLUMN_ID     BIGINT PRIMARY KEY ,
            $COLUMN_DATA          TEXT,
            $COLUMN_UPDATED_AT          BIGINT
             
            )        
          ''');

    await db.execute('''
      CREATE INDEX idx_id_$TABLE_NAME
      ON $TABLE_NAME ($COLUMN_ID)
    ''');
  }
}
