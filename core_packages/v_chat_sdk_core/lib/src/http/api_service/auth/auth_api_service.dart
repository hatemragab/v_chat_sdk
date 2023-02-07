import 'package:v_chat_sdk_core/src/http/api_service/auth/auth_api.dart';
import 'package:v_chat_sdk_core/src/http/api_service/interceptors.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class VAuthApiService {
  VAuthApiService._();

  static AuthApi? _authApi;

  Future<VIdentifierUser> login(VChatLoginDto dto) async {
    final body = dto.toMap();
    final response = await _authApi!.login(body);
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
        dto.language,
      ),
      VAppPref.setMap(VStorageKeys.vMyProfile.name, myUser.toMap())
    ]);
    return myUser;
  }

  Future<VIdentifierUser> register(VChatRegisterDto dto) async {
    final body = dto.toListOfPartValue();
    final response = await _authApi!.register(
      body,
      dto.image == null
          ? null
          : await HttpHelpers.getMultipartFile(
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
        dto.language,
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
