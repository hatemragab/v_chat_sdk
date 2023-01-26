import 'package:v_chat_sdk_core/src/http/api_service/interceptors.dart';
import 'package:v_chat_sdk_core/src/http/api_service/profile/profile_api.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class VProfileApiService {
  static ProfileApi? _profileApi;

  VProfileApiService._();

  Future<bool> addFcm(String fcm) async {
    final res = await _profileApi!.addFcm(
      {'pushKey': fcm},
    );
    throwIfNotSuccess(res);
    return true;
  }

  Future<bool> deleteFcm() async {
    final res = await _profileApi!.deleteFcm();
    throwIfNotSuccess(res);
    return true;
  }

  Future<bool> updateImage(VPlatformFileSource img) async {
    final res = await _profileApi!.updateImage(
      await VPlatforms.getMultipartFile(
        source: img,
      ),
    );
    throwIfNotSuccess(res);
    return true;
  }

  Future<bool> updateUserName(String fullName) async {
    final res = await _profileApi!.updateUserName({"fullName": fullName});
    throwIfNotSuccess(res);

    return true;
  }

  Future<DateTime> getUserLastSeenAt(
    String peerId,
  ) async {
    final res = await _profileApi!.getLastSeenAt(peerId);
    throwIfNotSuccess(res);
    return DateTime.parse((res.body as Map<String, dynamic>)['data'] as String);
  }

  Future<List<VIdentifierUser>> appUsers(Map<String, dynamic> dto) async {
    final res = await _profileApi!.appUsers(dto);
    throwIfNotSuccess(res);
    return (extractDataFromResponse(res)['docs'] as List)
        .map(
          (e) => VIdentifierUser.fromMap(e as Map<String, dynamic>),
        )
        .toList();
  }

  static VProfileApiService init({
    Uri? baseUrl,
    String? accessToken,
  }) {
    _profileApi ??= ProfileApi.create(
      accessToken: accessToken,
      baseUrl: baseUrl ?? VAppConstants.baseUri,
    );
    return VProfileApiService._();
  }
}
