import 'package:v_chat_sdk_core/src/utils/app_pref.dart';

import '../../../../v_chat_sdk_core.dart';
import '../../../utils/enums.dart';
import '../../../utils/http_helper.dart';
import '../interceptors.dart';
import 'auth_api.dart';

class VChatAuthApiService {
  VChatAuthApiService._();

  static late final AuthApi _authApi;

  Future<VIdentifierUser> login(VChatLoginDto dto) async {
    final body = dto.toMap();
    final response = await _authApi.login(body);
    throwIfNotSuccess(response);
    final myUser = VIdentifierUser.fromMap(
      response.body['data']['user'] as Map<String, dynamic>,
    );
    await Future.wait([
      AppPref.setHashedString(
        StorageKeys.accessToken,
        response.body['data']['accessToken'].toString(),
      ),
      AppPref.setString(
        StorageKeys.appLanguage,
        dto.language,
      ),
      AppPref.setMap(StorageKeys.vMyProfile, myUser.toMap())
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
              ));
    throwIfNotSuccess(response);
    final myUser = VIdentifierUser.fromMap(
      response.body['data']['user'] as Map<String, dynamic>,
    );
    await Future.wait([
      AppPref.setHashedString(
        StorageKeys.accessToken,
        response.body['data']['accessToken'].toString(),
      ),
      AppPref.setString(
        StorageKeys.appLanguage,
        dto.language,
      ),
      AppPref.setMap(StorageKeys.vMyProfile, myUser.toMap())
    ]);
    return myUser;
  }

  static VChatAuthApiService create({
    String? baseUrl,
    String? accessToken,
  }) {
    _authApi = AuthApi.create(
      accessToken: accessToken,
      baseUrl: baseUrl ?? AppConstants.baseUrl,
    );
    return VChatAuthApiService._();
  }

  Future<bool> logout() async {
    final response = await _authApi.logout();
    throwIfNotSuccess(response);
    return true;
  }
}
