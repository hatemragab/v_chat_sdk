// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_firebase_fcm/v_chat_firebase_fcm.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';
import 'package:v_chat_room_page/v_chat_room_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';
import 'package:v_chat_web_rtc/v_chat_web_rtc.dart';

import 'app/routes/app_pages.dart';

Future initVChat(GlobalKey<NavigatorState> _navigatorKey) async {
  await VChatController.init(
    navigatorKey: _navigatorKey,
    vMessagePageConfig: VMessagePageConfig(
      googleMapsApiKey: "AIzaSyAP-dfhdfhg",
    ),
    vChatConfig: VChatConfig(
      encryptHashKey: "V_CHAT_SDK_V2_VERY_STRONG_KEY",
      baseUrl: _getBaseUrl(),
      vPush: VPush(
        fcmProvider: VPlatforms.isMobile ? VChatFcmProver() : null,
        enableVForegroundNotification: true,
        vPushConfig: VLocalNotificationPushConfig(),
      ),
    ),
    vNavigator: VNavigator(
      roomNavigator: vDefaultRoomNavigator,
      callNavigator: vDefaultCallNavigator,
      messageNavigator: VMessageNavigator(
        toImageViewer: vDefaultMessageNavigator.toImageViewer,
        toViewChatMedia: vDefaultMessageNavigator.toViewChatMedia,
        toVideoPlayer: vDefaultMessageNavigator.toVideoPlayer,
        toSingleChatMessageInfo:
            vDefaultMessageNavigator.toSingleChatMessageInfo,
        toMessagePage: vDefaultMessageNavigator.toMessagePage,
        toBroadcastChatMessageInfo:
            vDefaultMessageNavigator.toBroadcastChatMessageInfo,
        toGroupChatMessageInfo: vDefaultMessageNavigator.toGroupChatMessageInfo,
        toGroupSettings: (context, data) {
          Get.toNamed(Routes.GROUP_SETTINGS, arguments: data);
          print("Going to group $data");
        },
        toSingleSettings: (context, data) {
          print("Going to toSingleSettings $data");
        },
        toBroadcastSettings: (context, data) {
          Get.toNamed(Routes.BROADCAST_SETTINGS, arguments: data);
        },
        toUserProfilePage: (context, identifier) {
          print("Going to toUserProfile $identifier");
        },
      ),
    ),
  );
}

Uri _getBaseUrl() {
  // return Uri.parse("http://192.168.1.4:3001");
  // if (true) {
  //   return Uri.parse("http://192.168.1.13:3001");
  // }
  if (kDebugMode) {
    if (kIsWeb || VPlatforms.isIOS) {
      return Uri.parse("http://localhost:3001");
    }
    //this will only working on the android emulator
    //to test on real device get you ipv4 first google it ! how to get my ipv4
    if (false) {
      return Uri.parse("http://192.168.1.3:3001");
    }
    return Uri.parse("http://10.0.2.2:3001");
  }
  return Uri.parse("http://v_chat_endpoint:3001");
}
