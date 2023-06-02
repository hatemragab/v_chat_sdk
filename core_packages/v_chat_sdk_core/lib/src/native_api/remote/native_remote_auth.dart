// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

/// Represents the Native Remote Auth that manages authentication
/// in the VChat application, using a remote API service.
class NativeRemoteAuth {
  final VAuthApiService _authApiService;

  /// Creates a new instance of [NativeRemoteAuth].
  ///
  /// Takes in an instance of [VAuthApiService] as a parameter.
  NativeRemoteAuth(this._authApiService);

  /// Connects to the remote API using the provided [dto] and returns
  /// the user identifier upon successful connection.
  Future<VIdentifierUser> connect(VChatRegisterDto dto) {
    return Future.value(_authApiService.connect(dto));
  }

  /// Logs out from the remote API and returns a boolean indicating
  /// the success of the logout operation.
  Future<bool> logout() {
    return Future.value(_authApiService.logout());
  }
}
