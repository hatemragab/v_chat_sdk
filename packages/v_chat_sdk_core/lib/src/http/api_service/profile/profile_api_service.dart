import 'package:v_chat_sdk_core/src/http/api_service/profile/profile_api.dart';

import '../../../../v_chat_sdk_core.dart';
import '../interceptors.dart';

class ProfileApiService {
  static late final ProfileApi _profileApi;

  ProfileApiService._();

  Future<DateTime> getUserLastSeenAt(
    String peerId,
  ) async {
    final res = await _profileApi.getLastSeenAt(peerId);
    throwIfNotSuccess(res);
    return DateTime.parse(res.body['data']);
  }

  static ProfileApiService init({
    Uri? baseUrl,
    String? accessToken,
  }) {
    _profileApi = ProfileApi.create(
      accessToken: accessToken,
      baseUrl: baseUrl ?? VAppConstants.baseUri,
    );
    return ProfileApiService._();
  }
}
