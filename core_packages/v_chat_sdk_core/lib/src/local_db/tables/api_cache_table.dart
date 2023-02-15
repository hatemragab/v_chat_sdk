// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:sqflite/sqflite.dart';

abstract class ApiCacheTable {
  static const tableName = 'api_';
  static const columnId = '${tableName}id';
  static const columnJsonValue = '${tableName}json_value';

  static Future<void> recreateTable(Transaction db) async {
    await db.execute(
      '''
          drop table if exists $tableName
        ''',
    );
    await ApiCacheTable.createTable(db);
  }

  static Future<void> createTable(Transaction db) async {
    await db.execute(
      '''
          create table $tableName (
            $columnId       TEXT PRIMARY KEY UNIQUE ,
            $columnJsonValue     TEXT
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
