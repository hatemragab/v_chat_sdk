import 'package:sqflite/sqflite.dart';

class RoomTable {
  static const tableName = 'tb_room';
  static const columnId = '${tableName}_id';
  static const columnData = '${tableName}_data';
  static const columnUpdatedAt = '${tableName}_updated_at';

  static Future<void> recreateTable(Database db) async {
    await db.execute('''
          drop table if exists $tableName
        ''');
    await RoomTable.createTable(db);
  }

  static Future<void> createTable(dynamic db) async {
    await db.execute('''
          create table $tableName (
       
            $columnId     BIGINT PRIMARY KEY ,
            $columnData          TEXT,
            $columnUpdatedAt    BIGINT
             
            )        
          ''');

    await db.execute('''
      CREATE INDEX idx_id_$tableName
      ON $tableName ($columnId)
    ''');
  }
}
