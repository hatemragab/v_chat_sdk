// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:sqflite/sqflite.dart';

class RoomTable {
  RoomTable._();

  static const tableName = 'tb_r';
  static const columnId = '${tableName}_id';
  static const columnRoomType = '${tableName}_room_type';
  static const columnTitle = '${tableName}_title';
  static const columnThumbImage = '${tableName}_img';
  static const columnTransTo = '${tableName}_t_to';
  static const columnIsArchived = '${tableName}_is_archived';
  static const columnIsMuted = '${tableName}_is_muted';
  static const columnPeerId = '${tableName}_peer_id';
  static const columnPeerIdentifier = '${tableName}_peer_identifier';
  static const columnBlockerId = '${tableName}_blocker_id';
  static const columnEnTitle = '${tableName}_title_en';
  static const columnUnReadCount = '${tableName}_un_counter';
  static const columnNickName = '${tableName}_nick_name';
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
            $columnThumbImage     TEXT   ,
            $columnTransTo     TEXT   ,
            $columnCreatedAt     TEXT   ,
            $columnIsArchived     INTEGER ,
            
            $columnIsMuted     INTEGER ,
            $columnPeerId     TEXT   ,
            $columnPeerIdentifier     TEXT   ,
            $columnBlockerId     TEXT   ,
            $columnNickName     TEXT   ,
            $columnUnReadCount     INTEGER ,
           
         
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
}
