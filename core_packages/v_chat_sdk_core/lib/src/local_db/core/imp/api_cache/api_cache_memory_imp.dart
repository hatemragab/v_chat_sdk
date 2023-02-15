// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/src/local_db/core/abstraction/base_local_api_cache_repo.dart';
import 'package:v_chat_sdk_core/src/models/api_cache_model.dart';

class ApiCacheMemoryImp extends BaseLocalApiCacheRepo {
  // final _apiCaches = <Map<String, Object?>>[];

  @override
  Future<ApiCacheModel?> getOneByEndPoint(String endpoint) {
    return Future.value();
  }

  @override
  Future<int> insert(ApiCacheModel model) {
    return Future.value(1);
  }

  @override
  Future<void> reCreate() {
    return Future.value();
  }
}
