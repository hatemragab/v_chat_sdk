import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../../v_chat_sdk_core.dart';
import '../../../utils/api_constants.dart';
import '../../../utils/http_helper.dart';
import '../interceptors.dart';
import 'auth_api.dart';

class AuthApiService {
  AuthApiService._();

  static late final AuthApi _authApi;

  Future<VIdentifierUser> login(VChatLoginDto dto) async {
    final body = dto.toMap();
    final response = await _authApi.login(body);
    throwIfNotSuccess(response);
    final myUser = VIdentifierUser.fromMap(
      response.body['data']['user'] as Map<String, dynamic>,
    );
    await Future.wait([
      VAppPref.setHashedString(
        VStorageKeys.accessToken,
        response.body['data']['accessToken'].toString(),
      ),
      VAppPref.setString(
        VStorageKeys.appLanguage,
        dto.language,
      ),
      VAppPref.setMap(VStorageKeys.vMyProfile, myUser.toMap())
    ]);
    return myUser;
  }

  Future<VIdentifierUser> register(VChatRegisterDto dto) async {
    final body = dto.toListOfPartValue();
    final response = await _authApi.register(
      body,
      dto.image == null
          ? null
          : await HttpHelpers.getMultipartFile(
              source: dto.image!,
            ),
    );
    throwIfNotSuccess(response);
    final myUser = VIdentifierUser.fromMap(
      response.body['data']['user'] as Map<String, dynamic>,
    );
    await Future.wait([
      VAppPref.setHashedString(
        VStorageKeys.accessToken,
        response.body['data']['accessToken'].toString(),
      ),
      VAppPref.setString(
        VStorageKeys.appLanguage,
        dto.language,
      ),
      VAppPref.setMap(VStorageKeys.vMyProfile, myUser.toMap())
    ]);
    return myUser;
  }

  static AuthApiService init({
    Uri? baseUrl,
    String? accessToken,
  }) {
    _authApi = AuthApi.create(
      accessToken: accessToken,
      baseUrl: baseUrl ?? VAppConstants.baseUri,
    );
    return AuthApiService._();
  }

  Future<bool> logout() async {
    final response = await _authApi.logout();
    throwIfNotSuccess(response);
    return true;
  }
}
