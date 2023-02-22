// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/src/http/api_service/block/block_api.dart';
import 'package:v_chat_sdk_core/src/http/api_service/interceptors.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class VBlockApiService {
  VBlockApiService._();

  static BlockApi? _blockApi;

  Future<bool> blockUser({
    required String identifier,
  }) async {
    final res = await _blockApi!.banUser(identifier);
    throwIfNotSuccess(res);
    return true;
  }

  Future<bool> unBlockUser({
    required String identifier,
  }) async {
    final res = await _blockApi!.unBanUser(identifier);
    throwIfNotSuccess(res);
    return true;
  }

  Future<VCheckBanModel> checkIfThereBan({
    required String identifier,
  }) async {
    final res = await _blockApi!.checkBan(identifier);
    throwIfNotSuccess(res);
    return VCheckBanModel.fromMap(extractDataFromResponse(res));
  }

  static VBlockApiService init({
    Uri? baseUrl,
    String? accessToken,
  }) {
    _blockApi ??= BlockApi.create(
      accessToken: accessToken,
      baseUrl: baseUrl ?? VAppConstants.baseUri,
    );
    return VBlockApiService._();
  }
}
