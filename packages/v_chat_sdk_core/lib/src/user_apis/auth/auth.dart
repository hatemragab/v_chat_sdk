import 'dart:ui';

import 'package:logging/logging.dart';
import 'package:v_chat_sdk_core/src/http/abstraction/abstraction.dart';
import 'package:v_chat_sdk_core/src/native_api/remote/native_remote_auth.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../v_chat_sdk_core.dart';
import '../../http/socket/socket_controller.dart';
import '../../native_api/v_native_api.dart';
import '../../utils/controller_helper.dart';
import '../../utils/device_info.dart';
import '../../utils/event_bus.dart';

class Auth implements AuthEndPoints {
  final VNativeApi _vNativeApi;
  final ControllerHelper _helper;
  final VChatConfig _chatConfig;
  final _log = Logger('Auth');

  NativeRemoteAuth get _remoteAuth => _vNativeApi.remote.remoteAuth;

  Auth(
    this._vNativeApi,
    this._helper,
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
      platform: Platforms.currentPlatform,
      deviceId: await deviceHelper.getId(),
      deviceInfo: await deviceHelper.getDeviceMapInfo(),
      language: deviceLanguage.languageCode,
      pushKey: await _helper.getFcmToken(),
      password: await _helper.getPasswordFromIdentifier(identifier),
    );
    final user = await _remoteAuth.login(dto);
    SocketController.instance.connect();
    return user;
  }

  ///register to v chat system
  @override
  Future<VIdentifierUser> register({
    required String identifier,
    required String fullName,
    PlatformFileSource? image,
    required Locale deviceLanguage,
  }) async {
    final deviceHelper = DeviceInfoHelper();
    final dto = VChatRegisterDto(
      identifier: identifier,
      fullName: fullName,
      deviceId: await deviceHelper.getId(),
      language: deviceLanguage.languageCode,
      platform: Platforms.currentPlatform,
      password: await _helper.getPasswordFromIdentifier(identifier),
      deviceInfo: await deviceHelper.getDeviceMapInfo(),
      pushKey: await _helper.getFcmToken(),
      image: image,
    );

    final user = await _remoteAuth.register(dto);
    SocketController.instance.connect();
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
    for (var element in StorageKeys.values) {
      await AppPref.remove(element);
    }
    SocketController.instance.disconnect();

    EventBusSingleton.instance.close();
  }
}
