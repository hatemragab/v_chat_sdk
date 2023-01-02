import 'dart:ui';

import 'package:logging/logging.dart';
import 'package:v_chat_sdk_core/src/http/abstraction/abstraction.dart';
import 'package:v_chat_sdk_core/src/native_api/remote/native_remote_auth.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../v_chat_sdk_core.dart';
import '../../http/socket/socket_controller.dart';
import '../../service/controller_helper.dart';

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
      deviceInfo: await deviceHelper.getDeviceMapInfo(),
      language: deviceLanguage.languageCode,
      pushKey: await _helper.getFcmToken(),
      password: await _helper.getPasswordFromIdentifier(identifier),
    );
    final user = await _remoteAuth.login(dto);
    SocketController.instance.connect();
    if (VChatController.I.vChatConfig.isPushEnable) {
      VChatController.I.vChatConfig.pushProvider!.askForPermissions();
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
      deviceInfo: await deviceHelper.getDeviceMapInfo(),
      pushKey: await _helper.getFcmToken(),
      image: image,
    );

    final user = await _remoteAuth.register(dto);
    SocketController.instance.connect();
    if (VChatController.I.vChatConfig.isPushEnable) {
      VChatController.I.vChatConfig.pushProvider!.askForPermissions();
    }
    return user;
  }

  ///delete user device from v chat sdk
  @override
  Future<void> logout() async {
    try {
      await _remoteAuth.logout();
      await _chatConfig.pushProvider?.deleteToken();
    } catch (err) {
      _log.warning(err);
    }
    for (var element in VStorageKeys.values) {
      await VAppPref.remove(element);
    }
    SocketController.instance.disconnect();
    await _vNativeApi.local.reCreate();
  }
}
