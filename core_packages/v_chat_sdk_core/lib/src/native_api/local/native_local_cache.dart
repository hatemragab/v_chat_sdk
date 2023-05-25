// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:sqflite/sqlite_api.dart';
import 'package:v_chat_sdk_core/src/local_db/core/abstraction/base_local_api_cache_repo.dart';
import 'package:v_chat_sdk_core/src/local_db/core/imp/api_cache/api_cache_memory_imp.dart';
import 'package:v_chat_sdk_core/src/local_db/core/imp/api_cache/api_cache_sql_imp.dart';
import 'package:v_chat_sdk_core/src/models/api_cache_model.dart';
import 'package:v_platform/v_platform.dart';

class NativeLocalApiCache {
  late final BaseLocalApiCacheRepo _apiCacheRepo;

  NativeLocalApiCache(Database? database) {
    if (VPlatforms.isWeb) {
      _apiCacheRepo = ApiCacheMemoryImp();
    } else {
      _apiCacheRepo = ApiCacheSqlImp(database!);
    }
  }

  Future<int> insertToApiCache(ApiCacheModel model) async {
    return _apiCacheRepo.insert(model);
  }

  Future<ApiCacheModel?> getOneApiCache(String endPoint) async {
    return _apiCacheRepo.getOneByEndPoint(endPoint);
  }
}
