// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/src/http/api_service/auth/auth_api.dart';
import 'package:v_chat_sdk_core/src/http/api_service/interceptors.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

class VAuthApiService {
  VAuthApiService._();

  static AuthApi? _authApi;

  ///use this method to connect to the server and enable all the features of v chat
  ///this should be the first method to call before using any other method
  ///and it should be called only once
  ///and it should be called only after the user has been authenticated
  Future<VIdentifierUser> connect(VChatRegisterDto dto) async {
    final body = dto.toListOfPartValue();
    final response = await _authApi!.connect(
      body,
      dto.image == null
          ? null
          : await VPlatforms.getMultipartFile(
              source: dto.image!,
            ),
    );
    throwIfNotSuccess(response);
    final myUser = VIdentifierUser.fromMap(
      extractDataFromResponse(response)['user'] as Map<String, dynamic>,
    );
    await Future.wait([
      VAppPref.setHashedString(
        VStorageKeys.vAccessToken.name,
        extractDataFromResponse(response)['accessToken'].toString(),
      ),
      VAppPref.setStringKey(
        VStorageKeys.vAppLanguage.name,
        dto.language ?? "en",
      ),
      VAppPref.setMap(VStorageKeys.vMyProfile.name, myUser.toMap())
    ]);
    return myUser;
  }

  static VAuthApiService init({
    Uri? baseUrl,
    String? accessToken,
  }) {
    _authApi ??= AuthApi.create(
      accessToken: accessToken,
      baseUrl: baseUrl ?? VAppConstants.baseUri,
    );
    return VAuthApiService._();
  }

  Future<bool> logout() async {
    final response = await _authApi!.logout();
    throwIfNotSuccess(response);
    return true;
  }
}
