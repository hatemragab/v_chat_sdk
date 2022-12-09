import 'dart:ui';

import 'package:logging/logging.dart';
import 'package:v_chat_sdk_core/src/http/socket/socket_controller.dart';
import 'package:v_chat_sdk_core/src/local_db/local_storage_service.dart';
import 'package:v_chat_sdk_core/src/utils/app_pref.dart';
import 'package:v_chat_sdk_core/src/utils/controller_helper.dart';
import 'package:v_chat_sdk_core/src/utils/device_info.dart';
import 'package:v_chat_sdk_core/src/utils/enums.dart';
import 'package:v_chat_sdk_core/src/utils/event_bus.dart';

import '../v_chat_sdk_core.dart';
import 'http/abstraction/auth_abs.dart';

class VChatController implements AuthEndPoints {
  final log = Logger('VChatController');
  final vChatEvents = EventBusSingleton.instance.vChatEvents;

  ///singleton
  VChatController._privateConstructor();

  static final instance = VChatController._privateConstructor();

  static VChatController get I => instance;

  ///v chat variables
  late final ControllerHelper _helper;
  late final VChatConfig config;
  bool isControllerInit = false;
  late final VNativeApi vNativeApi;

  Future<void> init({
    required VChatConfig vChatConfig,
  }) async {
    if (isControllerInit) {
      log.warning(
        "You must call this function once ! this will throw in future updates",
      );
      return;
    }
    isControllerInit = true;
    config = vChatConfig;
    await AppPref.init();
    _helper = await ControllerHelper.instance.init(vChatConfig);
    _initApiService();
    SocketController.instance.connect();
    await LocalStorageService.instance.init();
    vNativeApi = VNativeApi();
  }

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
    final user = await vNativeApi.login(dto);
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

    final user = await vNativeApi.register(dto);
    SocketController.instance.connect();
    return user;
  }

  ///delete user device from v chat sdk
  @override
  Future<void> logout() async {
    try {
      await vNativeApi.logout();
      await config.pushProvider?.deleteToken();
    } catch (err) {
      log.warning(err);
    }
    for (var element in StorageKeys.values) {
      await AppPref.remove(element);
    }
    SocketController.instance.disconnect();

    vChatEvents.dispose();
  }

  ///make sure you already login or already login to v chat
  bool connectToSocket() {
    final access = AppPref.getHashedString(key: StorageKeys.accessToken);
    if (access == null) {
      log.warning(
        "You try to connect to socket with out login please make sure you call VChatController.instance.login first",
      );
      return false;
    }
    SocketController.instance.connect();
    return true;
  }

  void _initApiService() {
    VChatAuthApiService.instance.init();
  }
}
