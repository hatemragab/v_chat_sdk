// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.
import 'dart:async';

import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:v_chat_sdk_core/src/local_db/tables/api_cache_table.dart';
import 'package:v_chat_sdk_core/src/local_db/tables/message_table.dart';
import 'package:v_chat_sdk_core/src/local_db/tables/room_table.dart';
import 'package:v_chat_sdk_core/src/utils/api_constants.dart';
import 'package:v_platform/v_platform.dart';

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
    final documentsDirectory = VPlatforms.isWindows
        ? (await getApplicationDocumentsDirectory()).path
        : await getDatabasesPath();
    final path = join(documentsDirectory, VAppConstants.dbName);

    if (VPlatforms.isWindows) {
      return _initForWindows(path);
    }
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
        });
        log.fine("All tables Created !!");
      },
      onOpen: (db) async {
        dbCompleter.complete();
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

  Future<Database> _initForWindows(String path) async {
    final databaseFactory = databaseFactoryFfi;
    return databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: VAppConstants.dbVersion,
        onUpgrade: (db, oldVersion, newVersion) async {
          await reCreateTables(db);
        },
        onCreate: (db, version) async {
          await db.transaction((txn) async {
            await RoomTable.createTable(txn);
            await MessageTable.createTable(txn);
            await ApiCacheTable.createTable(txn);
            log.fine("All tables Created !!");
          });
        },
        onOpen: (db) async {
          dbCompleter.complete();
        },
      ),
    );
  }
}
