// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class NativeRemoteAuth {
  final VAuthApiService _authApiService;

  NativeRemoteAuth(this._authApiService);

  Future<VIdentifierUser> connect(VChatRegisterDto dto) {
    return Future.value(_authApiService.connect(dto));
  }

  Future<bool> logout() {
    return Future.value(_authApiService.logout());
  }
}
