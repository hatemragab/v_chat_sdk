// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:sqflite/sqflite.dart';

abstract class MessageTable {
  static const tableName = 'tb_m_';
  static const columnId = '${tableName}id';
  static const columnSenderId = '${tableName}s_id';
  static const columnSIdentifier = '${tableName}s_id_fire';
  static const columnSenderName = '${tableName}s_name';
  static const columnSenderImageThumb = '${tableName}s_img';
  static const columnRoomId = '${tableName}room_id';
  static const columnContent = '${tableName}content';
  static const columnMessageType = '${tableName}type';
  static const columnAttachment = '${tableName}att';
  static const columnLinkAttachment = '${tableName}l_att';
  static const columnReplyTo = '${tableName}reply_to';
  static const columnSeenAt = '${tableName}seen_at';
  static const columnAllDeletedAt = '${tableName}all_deleted_at';
  static const columnParentBroadcastId = '${tableName}p_b_id';
  static const columnDeliveredAt = '${tableName}delivered_at';
  static const columnForwardId = '${tableName}forward_l_id';
  static const columnContentTr = '${tableName}c_tr';
  static const columnIsStar = '${tableName}is_star';
  static const columnIsEncrypted = '${tableName}is_encrypted';
  static const columnCreatedAt = '${tableName}created_at';
  static const columnUpdatedAt = '${tableName}updated_at';
  static const columnPlatform = '${tableName}platform';
  static const columnMessageEmitStatus = '${tableName}emit_status';
  static const columnLocalId = '${tableName}local_id';

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
            $columnSIdentifier     TEXT,
            $columnSenderName   TEXT,
            $columnSenderImageThumb   TEXT,
            $columnRoomId   TEXT,
            $columnContent   TEXT,
            $columnMessageType   TEXT,
            $columnAttachment   TEXT,
            $columnLinkAttachment   TEXT,
            $columnReplyTo   TEXT,
            $columnSeenAt   TEXT,
            $columnContentTr   TEXT,
            $columnPlatform   TEXT,
            $columnAllDeletedAt   TEXT,
            $columnParentBroadcastId TEXT,
            $columnDeliveredAt   TEXT,
            $columnForwardId   TEXT,
            $columnIsStar   INTEGER,
            $columnIsEncrypted   INTEGER,
            $columnCreatedAt   TEXT,
            $columnUpdatedAt   TEXT,
            $columnMessageEmitStatus   TEXT,
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
