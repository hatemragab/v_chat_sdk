// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:v_chat_sdk_core/src/local_db/tables/api_cache_table.dart';
import 'package:v_chat_sdk_core/src/local_db/tables/message_table.dart';
import 'package:v_chat_sdk_core/src/local_db/tables/room_table.dart';
import 'package:v_chat_sdk_core/src/utils/api_constants.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class DBProvider {
  DBProvider._();

  final Completer<void> dbCompleter = Completer<void>();
  static final instance = DBProvider._();
  final log = Logger('DBProvider SQL');
  Database? _database;

  Future<Database?> get database async {
    if (VPlatforms.isWeb) {
      dbCompleter.complete();
      return null;
    }
    if (_database != null) return _database!;
    // if _database is null we instantiate it
    _database = await _open();
    return _database!;
  }

  Future<Database> _open() async {
    final String documentsDirectory = await getDatabasesPath();
    final String path = join(documentsDirectory, VAppConstants.dbName);

    return openDatabase(
      path,
      version: VAppConstants.dbVersion,
      onUpgrade: (db, oldVersion, newVersion) async {
        await reCreateTables(db);
      },
      onCreate: (db, version) async {
        await db.transaction((txn) async {
          await RoomTable.createTable(txn);
          await MessageTable.createTable(txn);
          await ApiCacheTable.createTable(txn);
          // await txn.execute('PRAGMA cache_size = 1000000');
          // await txn.execute("PRAGMA synchronous = OFF");
          // await txn.execute('PRAGMA temp_store = MEMORY');
        });
        log.fine("All tables Created !!");
      },
      onOpen: (db) async {
        dbCompleter.complete();
        // await NewRoomTable.recreateTable(db);
        // await NewMessageTable.recreateTable(db);
        //
        // log("--------------all tables deleted!--------------");
      },
    );
  }

  Future reCreateTables(Database db) async {
    await db.transaction((txn) async {
      await RoomTable.recreateTable(txn);
      await MessageTable.recreateTable(txn);
      await ApiCacheTable.recreateTable(txn);
    });
    log.warning("all tables deleted !!!!!!!!!!!!!!!!!!!!!!!!");
  }
}
