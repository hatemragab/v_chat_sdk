// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:sqflite/sqflite.dart';
import 'package:v_chat_sdk_core/src/local_db/core/abstraction/base_local_api_cache_repo.dart';
import 'package:v_chat_sdk_core/src/local_db/tables/api_cache_table.dart';
import 'package:v_chat_sdk_core/src/models/api_cache_model.dart';

class ApiCacheSqlImp extends BaseLocalApiCacheRepo {
  final Database _database;

  ApiCacheSqlImp(this._database);

  final table = ApiCacheTable.tableName;

  @override
  Future<ApiCacheModel?> getOneByEndPoint(String endpoint) async {
    final res = await _database.query(
      table,
      where: "${ApiCacheTable.columnId} =?",
      whereArgs: [endpoint],
      limit: 1,
    );
    if (res.isEmpty) {
      return null;
    }
    return ApiCacheModel.fromLocalMap(res.first);
  }

  @override
  Future<int> insert(ApiCacheModel model) {
    return _database.insert(
      table,
      model.toLocalMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> reCreate() {
    return _database.transaction((txn) => ApiCacheTable.recreateTable(txn));
  }
}
