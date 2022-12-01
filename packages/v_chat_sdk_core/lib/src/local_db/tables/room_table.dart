import 'package:sqflite/sqflite.dart';

class RoomTable {
  RoomTable._();

  static const tableName = 'tb_r';
  static const columnId = '${tableName}_id';
  static const columnRoomType = '${tableName}_r_r';
  static const columnTitle = '${tableName}_r';
  static const columnThumbImage = '${tableName}_img';
  static const columnRoomTyping = '${tableName}_typing';
  static const columnIsArchived = '${tableName}_i_a';
  static const columnIsOnline = '${tableName}_i_onl';
  static const columnIsMuted = '${tableName}_i_m';
  static const columnPeerId = '${tableName}_p_id';
  static const columnBlockerId = '${tableName}_b_id';
  static const columnIsDeleted = '${tableName}_is_del';
  static const columnEnTitle = '${tableName}_en_t';
  static const columnUnReadCount = '${tableName}_un_c';
  static const columnNickName = '${tableName}_n_name';
  static const columnCreatedAt = '${tableName}_created_at';

  static Future<void> recreateTable(Transaction db) async {
    await db.execute(
      '''
          drop table if exists $tableName
        ''',
    );
    await RoomTable.createTable(db);
  }

  static Future<void> createTable(Transaction db) async {
    await db.execute(
      '''
          create table $tableName (
       
            $columnId     TEXT PRIMARY KEY UNIQUE ,
            $columnRoomType     TEXT   ,
            $columnTitle     TEXT   ,
            $columnEnTitle     TEXT   ,
            $columnRoomTyping     TEXT   ,
            $columnThumbImage     TEXT   ,
            $columnCreatedAt     TEXT   ,
            $columnIsArchived     INTEGER ,
            $columnIsOnline     INTEGER ,
            $columnIsMuted     INTEGER ,
            $columnPeerId     TEXT   ,
            $columnBlockerId     TEXT   ,
            $columnNickName     TEXT   ,
            $columnUnReadCount     INTEGER ,
            $columnIsDeleted     INTEGER ,
         
            UNIQUE($columnId, $columnPeerId) ON CONFLICT REPLACE
            )        
          ''',
    );

    ///$columnIsTranslateEnable     INTEGER DEFAULT 0,
    await db.execute(
      '''
      CREATE INDEX idx_id_$tableName
      ON $tableName ($columnId)
    ''',
    );
  }

  static Future<void> addColumnIsTranslateEnable(dynamic db) async {
    //  await db.execute(
    //    '''
    //  alter table $tableName add column $columnTransTo TEXT DEFAULT null
    // ''',
    //  );
  }
}
