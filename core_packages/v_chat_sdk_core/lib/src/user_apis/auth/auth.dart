// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:ui';

import 'package:logging/logging.dart';
import 'package:v_chat_sdk_core/src/http/abstraction/abstraction.dart';
import 'package:v_chat_sdk_core/src/http/api_service/profile/profile_api_service.dart';
import 'package:v_chat_sdk_core/src/http/socket/socket_controller.dart';
import 'package:v_chat_sdk_core/src/native_api/remote/native_remote_auth.dart';
import 'package:v_chat_sdk_core/src/service/controller_helper.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class VProfileApi implements AuthEndPoints {
  final VNativeApi _vNativeApi;
  final ControllerHelper _helper = ControllerHelper.instance;
  final VChatConfig _chatConfig;
  final _log = Logger('user_api.Auth');

  NativeRemoteAuth get _remoteAuth => _vNativeApi.remote.remoteAuth;

  VProfileApiService get _profileApi => _vNativeApi.remote.profile;

  VProfileApi(
    this._vNativeApi,
    this._chatConfig,
  );

  ///login to v chat system
  @override
  Future<VIdentifierUser> login({
    required String identifier,
    required Locale deviceLanguage,
    bool ignoreIfUserAlreadyLogin = true,
  }) async {
    final userMap = VAppPref.getMap(VStorageKeys.vMyProfile.name);
    if (userMap != null) {
      _connectSuccessLogin();
      return VIdentifierUser.fromMap(userMap);
    }

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
    _connectSuccessLogin();

    return user;
  }

  void _connectSuccessLogin() {
    SocketController.instance.connect();
    if (VChatController.I.vChatConfig.isPushEnable && !VPlatforms.isWeb) {
      VChatController.I.vChatConfig.currentPushProviderService!
          .askForPermissions();
    }
  }

  Future<bool> updateName(String newName) async {
    return _profileApi.updateUserName(newName);
  }

  Future<VUserImage> updateImage(VPlatformFileSource fileSource) async {
    return _profileApi.updateImage(fileSource);
  }

  Future<DateTime> getUserLastSeenAt(String identifier) async {
    return _profileApi.getUserLastSeenAt(identifier);
  }

  ///register to v chat system
  @override
  Future<VIdentifierUser> register({
    required String identifier,
    required String fullName,
    VPlatformFileSource? image,
    required Locale deviceLanguage,
  }) async {
    final userMap = VAppPref.getMap(VStorageKeys.vMyProfile.name);
    if (userMap != null) {
      _connectSuccessLogin();
      return VIdentifierUser.fromMap(userMap);
    }
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
    _connectSuccessLogin();
    SocketController.instance.connect();
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
