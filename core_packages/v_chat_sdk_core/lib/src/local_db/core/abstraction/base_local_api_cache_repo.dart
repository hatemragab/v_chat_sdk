// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/src/models/api_cache_model.dart';

abstract class BaseLocalApiCacheRepo {
  Future<int> insert(ApiCacheModel model);

  Future<ApiCacheModel?> getOneByEndPoint(String endpoint);

  Future<void> reCreate();
}
