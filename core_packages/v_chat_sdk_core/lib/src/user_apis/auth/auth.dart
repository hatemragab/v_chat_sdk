// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.
/// Provides services to interact with the VChat Profile API.

import 'dart:ui';

import 'package:logging/logging.dart';
import 'package:v_chat_sdk_core/src/http/abstraction/abstraction.dart';
import 'package:v_chat_sdk_core/src/http/api_service/profile/profile_api_service.dart';
import 'package:v_chat_sdk_core/src/http/socket/socket_controller.dart';
import 'package:v_chat_sdk_core/src/native_api/remote/native_remote_auth.dart';
import 'package:v_chat_sdk_core/src/service/controller_helper.dart';
import 'package:v_chat_sdk_core/src/utils/device_info.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

class VProfileApi implements AuthEndPoints {
  final VNativeApi _vNativeApi;
  final VChatControllerHelper _helper = VChatControllerHelper.instance;
  final VChatConfig _chatConfig;
  final _log = Logger('user_api.Auth');

  // Provides access to remote authentication API
  NativeRemoteAuth get _remoteAuth => _vNativeApi.remote.remoteAuth;

  // Provides access to profile-related API services
  VProfileApiService get _profileApi => _vNativeApi.remote.profile;

  VProfileApi(
    this._vNativeApi,
    this._chatConfig,
  );

  // Handles actions required after a successful login
  Future<void> _connectSuccessLogin() async {
    SocketController.instance.connect();
    VChatControllerHelper.instance.initSocketTimer();
    if (VChatController.I.vChatConfig.isPushEnable) {
      await (await VChatController.I.vChatConfig.currentPushProviderService)
          ?.askForPermissions();
    }
    await VNotificationListener.init();
  }

  // Updates the user's name
  Future<bool> updateName(String newName) async {
    return _profileApi.updateUserName(newName);
  }

  // Updates the user's image
  Future<VUserImage> updateImage(VPlatformFile fileSource) async {
    return _profileApi.updateImage(fileSource);
  }

  // Retrieves the last seen time of a user
  Future<DateTime> getUserLastSeenAt(String identifier) async {
    return _profileApi.getUserLastSeenAt(identifier);
  }

  // Connect a user to the VChat system
  @override
  Future<VIdentifierUser> connect({
    required String identifier,
    required String? fullName,
    VPlatformFile? image,
    Locale? deviceLanguage,
  }) async {
    final userMap = VAppPref.getMap(VStorageKeys.vMyProfile.name);
    await VChatControllerHelper.instance.initPushService();
    if (userMap != null) {
      _connectSuccessLogin();
      return VIdentifierUser.fromMap(userMap);
    }
    final deviceHelper = DeviceInfoHelper();
    final dto = VChatRegisterDto(
      identifier: identifier,
      fullName: fullName,
      deviceId: await deviceHelper.getId(),
      language: deviceLanguage?.languageCode,
      platform: VPlatforms.currentPlatform,
      password: await _helper.getPasswordFromIdentifier(identifier),
      pushKey: await _helper.getPushToken(),
      image: image,
    );
    final user = await _remoteAuth.connect(dto);
    _connectSuccessLogin();
    return user;
  }

  // Logs out a user from the VChat SDK
  @override
  Future<void> logout() async {
    try {
      await _remoteAuth.logout();
      await (await _chatConfig.currentPushProviderService)?.deleteToken();
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
