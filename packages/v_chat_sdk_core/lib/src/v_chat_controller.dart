import 'dart:ui';

import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:v_chat_sdk_core/src/http/socket/socket_controller.dart';
import 'package:v_chat_sdk_core/src/types/platform_file_source.dart';
import 'package:v_chat_sdk_core/src/types/platforms.dart';
import 'package:v_chat_sdk_core/src/utils/app_pref.dart';
import 'package:v_chat_sdk_core/src/utils/controller_helper.dart';
import 'package:v_chat_sdk_core/src/utils/device_info.dart';
import 'package:v_chat_sdk_core/src/utils/enums.dart';
import 'package:v_chat_sdk_core/src/utils/event_bus.dart';

import '../v_chat_sdk_core.dart';
import 'http/abstraction/auth_abs.dart';

class VChatController implements AuthEndPoints {
  final log = Logger('VChatController');
  final _getIt = GetIt.I;
  final vChatEvents = EventBusSingleton.instance.vChatEvents;

  ///singleton
  VChatController._privateConstructor();

  static final instance = VChatController._privateConstructor();

  static VChatController get I => instance;

  ///v chat variables
  late final ControllerHelper _helper;
  late final VChatConfig config;
  bool isControllerInit = false;
  late final VChatAuthApiService _authApiService;
  late final SocketController _socketController;
  late final VNativeApi vNativeApi;

  Future<void> init({
    required VChatConfig config,
  }) async {
    if (isControllerInit) {
      log.warning(
        "You must call this function once ! this will throw in future updates",
      );
      return;
    }
    isControllerInit = true;
    this.config = config;
    await AppPref.init();
    _helper = await ControllerHelper.instance.init(config);
    _lazyInject();
    _authApiService = _getIt.get<VChatAuthApiService>();
    _socketController = _getIt.get<SocketController>()..connect();
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
    final user = await _authApiService.login(dto);
    _socketController.connect();
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

    final user = await _authApiService.register(dto);
    _socketController.connect();
    return user;
  }

  ///delete user device from v chat sdk
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
    _socketController.disconnect();

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
    _socketController.connect();
    return true;
  }

  void _lazyInject() {
    _getIt.registerLazySingleton(() => VChatAuthApiService.create());
    _getIt.registerLazySingleton(() => SocketController());
  }
}
