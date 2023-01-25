import 'dart:ui';

import 'package:logging/logging.dart';
import 'package:v_chat_sdk_core/src/http/abstraction/abstraction.dart';
import 'package:v_chat_sdk_core/src/http/socket/socket_controller.dart';
import 'package:v_chat_sdk_core/src/native_api/remote/native_remote_auth.dart';
import 'package:v_chat_sdk_core/src/service/controller_helper.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class AuthApi implements AuthEndPoints {
  final VNativeApi _vNativeApi;
  final ControllerHelper _helper = ControllerHelper.instance;
  final VChatConfig _chatConfig;
  final _log = Logger('user_api.Auth');

  NativeRemoteAuth get _remoteAuth => _vNativeApi.remote.remoteAuth;

  AuthApi(
    this._vNativeApi,
    this._chatConfig,
  );

  ///login to v chat system
  @override
  Future<VIdentifierUser> login({
    required String identifier,
    required Locale deviceLanguage,
  }) async {
    final deviceHelper = DeviceInfoHelper();
    final dto = VChatLoginDto(
      identifier: identifier,
      platform: VPlatforms.currentPlatform,
      deviceId: await deviceHelper.getId(),
      language: deviceLanguage.languageCode,
      pushKey: await _helper.getPushToken(),
      password: await _helper.getPasswordFromIdentifier(identifier),
    );
    final user = await _remoteAuth.login(dto);
    SocketController.instance.connect();
    if (VChatController.I.vChatConfig.isPushEnable) {
      VChatController.I.vChatConfig.currentPushProviderService!
          .askForPermissions();
    }
    return user;
  }

  ///register to v chat system
  @override
  Future<VIdentifierUser> register({
    required String identifier,
    required String fullName,
    VPlatformFileSource? image,
    required Locale deviceLanguage,
  }) async {
    final deviceHelper = DeviceInfoHelper();
    final dto = VChatRegisterDto(
      identifier: identifier,
      fullName: fullName,
      deviceId: await deviceHelper.getId(),
      language: deviceLanguage.languageCode,
      platform: VPlatforms.currentPlatform,
      password: await _helper.getPasswordFromIdentifier(identifier),
      pushKey: await _helper.getPushToken(),
      image: image,
    );

    final user = await _remoteAuth.register(dto);
    SocketController.instance.connect();
    if (VChatController.I.vChatConfig.isPushEnable) {
      VChatController.I.vChatConfig.currentPushProviderService!
          .askForPermissions();
    }
    return user;
  }

  ///delete user device from v chat sdk
  @override
  Future<void> logout() async {
    try {
      await _remoteAuth.logout();
      await _chatConfig.currentPushProviderService?.deleteToken();
    } catch (err) {
      _log.warning(err);
    }
    try {
      await _vNativeApi.remote.profile.deleteFcm();
    } catch (err) {
      _log.warning(err);
    }
    for (final element in VStorageKeys.values) {
      await VAppPref.removeKey(element.name);
    }
    SocketController.instance.disconnect();
    await _vNativeApi.local.reCreate();
  }
}
