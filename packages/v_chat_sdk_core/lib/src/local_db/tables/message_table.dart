import 'package:sqflite/sqflite.dart';

abstract class MessageTable {
  static const tableName = 'tb_m_';
  static const columnId = '${tableName}id';
  static const columnSenderId = '${tableName}s_id';
  static const columnSenderName = '${tableName}s_n';
  static const columnSenderImageThumb = '${tableName}s_img';
  static const columnRoomId = '${tableName}r_id';
  static const columnContent = '${tableName}c';
  static const columnMessageType = '${tableName}m_t';
  static const columnAttachment = '${tableName}m_a';
  static const columnLinkAttachment = '${tableName}l_att';
  static const columnReplyTo = '${tableName}r_to';
  static const columnSeenAt = '${tableName}s_at';
  static const columnDeletedAt = '${tableName}dlt_at';
  static const columnParentBroadcastId = '${tableName}p_b_id';
  static const columnDeliveredAt = '${tableName}d_at';
  static const columnForwardId = '${tableName}for_id';
  static const columnIsStar = '${tableName}is_s';
  static const columnCreatedAt = '${tableName}c_at';
  static const columnUpdatedAt = '${tableName}u_at';
  static const columnPlatform = '${tableName}p';
  static const columnMessageStatus = '${tableName}m_ss';
  static const columnLocalId = '${tableName}l_id';

  static Future<void> recreateTable(Transaction db) async {
    await db.execute(
      '''
          drop table if exists $tableName
        ''',
    );
    await MessageTable.createTable(db);
  }

  static Future<void> createTable(Transaction db) async {
    await db.execute(
      '''
          create table $tableName (
            $columnId       TEXT PRIMARY KEY UNIQUE ,
            $columnSenderId     TEXT,
            $columnSenderName   TEXT,
            $columnSenderImageThumb   TEXT,
            $columnRoomId   TEXT,
            $columnContent   TEXT,
            $columnMessageType   TEXT,
            $columnAttachment   TEXT,
            $columnLinkAttachment   TEXT,
            $columnReplyTo   TEXT,
            $columnSeenAt   TEXT,
            $columnPlatform   TEXT,
            $columnDeletedAt   TEXT,
            $columnParentBroadcastId TEXT,
            $columnDeliveredAt   TEXT,
            $columnForwardId   TEXT,
            $columnIsStar   INTEGER,
            $columnCreatedAt   TEXT,
            $columnUpdatedAt   TEXT,
            $columnMessageStatus   TEXT,
            $columnLocalId   TEXT UNIQUE,
            UNIQUE($columnId, $columnRoomId) ON CONFLICT REPLACE
           
       )        
          ''',
    );
    //CONSTRAINT fk_room FOREIGN KEY ($columnRoomId) REFERENCES
    //             ${RoomTable.tableName}(${RoomTable.columnId}) ON DELETE CASCADE

    await db.execute(
      '''
      CREATE INDEX idx_id_$tableName
      ON $tableName ($columnId)
    ''',
    );
    await db.execute(
      '''
      CREATE INDEX idx_${columnRoomId}_$tableName
      ON $tableName ($columnRoomId)
    ''',
    );
  }
}
