// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

abstract class VAppConstants {
  const VAppConstants._();
  static String clintVersion = "2.0.0";
  static const appName = "VChatSdkV2";
  static const dbName = "VChatSdkV2.db";
  static const apiVersion = "v2";
  static const dbVersion = 2;
  static const socketInterval = 10; //10sec
  static String get baseServerIp {
    final uri = VChatController.I.vChatConfig.baseUrl;
    if (uri.hasPort) {
      //https         api.example
      return "${uri.scheme}://${uri.host}:${uri.port}";
    }
    return "${uri.scheme}://${uri.host}";
  }

  static String emulatorBaseUrl = "http://10.0.2.2:3001/api/$apiVersion";
  static String realDeviceBaseUrl = "http://192.168.1.3:3001/api/$apiVersion";

  static Uri get baseUri {
    return Uri.parse("$baseServerIp/api/$apiVersion");
  }

  static VIdentifierUser get myProfile {
    final map = VAppPref.getMap(VStorageKeys.vMyProfile.name);
    if (map == null) {
      throw VChatDartException(
        exception:
            "You try to get myProfile from cache but it value is NULL! please make sure you are login!",
      );
    }
    return VIdentifierUser.fromMap(
      map,
    );
  }

  static VIdentifierUser get fakeMyProfile {
    return VIdentifierUser(
      identifier: "FAKE identifier",
      baseUser: VBaseUser.fromFakeData(),
    );
  }

  static String get myId {
    return myProfile.baseUser.vChatId;
  }

  static String get myIdentifier {
    return myProfile.identifier;
  }

  static String get sdkLanguage =>
      VAppPref.getStringOrNullKey(VStorageKeys.vAppLanguage.name) ?? "en";
}
