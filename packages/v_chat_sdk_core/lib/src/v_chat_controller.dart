import 'dart:ui';

import 'package:logging/logging.dart';
import 'package:v_chat_sdk_core/src/types/platform_file_source.dart';
import 'package:v_chat_sdk_core/src/types/platforms.dart';
import 'package:v_chat_sdk_core/src/utils/app_pref.dart';
import 'package:v_chat_sdk_core/src/utils/controller_helper.dart';
import 'package:v_chat_sdk_core/src/utils/device_info.dart';
import 'package:v_chat_sdk_core/src/utils/enums.dart';

import '../v_chat_sdk_core.dart';
import 'http/abstraction/auth_abs.dart';

class VChatController implements AuthEndPoints {
  final log = Logger('VChatController');

  VChatController._privateConstructor();

  static final instance = VChatController._privateConstructor();
  late final ControllerHelper _helper;

  late final VChatConfig config;
  bool isControllerInit = false;

  late final VChatAuthApiService _authApiService;

  Future<void> init({
    required VChatConfig config,
  }) async {
    this.config = config;
    await AppPref.init();
    _helper = ControllerHelper(config);
    _helper.initLogger(config.enableLog);
    await _helper.initPushService(config.pushProvider);
    isControllerInit = true;
    _authApiService = VChatAuthApiService.create();
  }

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
    return await _authApiService.login(dto);
  }

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
    return await _authApiService.register(dto);
  }

  @override
  Future<void> logout() async {
    try {
      await _authApiService.logout();
      await config.pushProvider?.deleteToken();
    } catch (err) {
      log.warning(err);
    }
    for (var element in StorageKeys.values) {
      await AppPref.remove(element);
    }
  }
}
