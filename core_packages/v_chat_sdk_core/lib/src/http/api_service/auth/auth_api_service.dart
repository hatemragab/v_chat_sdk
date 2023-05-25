// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/src/http/api_service/auth/auth_api.dart';
import 'package:v_chat_sdk_core/src/http/api_service/interceptors.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../../utils/app_pref.dart';

class VAuthApiService {
  VAuthApiService._();

  static AuthApi? _authApi;

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
