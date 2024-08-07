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
import 'package:v_chat_sdk_sample/app/v_chat/extension.dart';
import 'package:v_platform/v_platform.dart';

import 'app/modules/message_page/message_page.dart';
import 'app/routes/app_pages.dart';

Future initVChat(GlobalKey<NavigatorState> _navigatorKey) async {
  await VChatController.init(
    navigatorKey: _navigatorKey,
    vChatConfig: VChatConfig(
      agoraAppId: "1b7727fb86e846d795b0dd12f560cfe4",
      encryptHashKey: "V_CHAT_SDK_V2_VERY_STRONG_KEY",
      baseUrl: _getBaseUrl(),
      vPush: VPush(
        fcmProvider: VPlatforms.isMobile ? VChatFcmProver() : null,
        enableVForegroundNotification: true,
        // oneSignalProvider: VChatOneSignalProver(
        //   appId: "------------",
        // ),
        vPushConfig: VLocalNotificationPushConfig(),
      ),
    ),
    vNavigator: VNavigator(
        roomNavigator: vDefaultRoomNavigator,
        messageNavigator: VMessageNavigator(
          toImageViewer: vDefaultMessageNavigator.toImageViewer,
          toVideoPlayer: vDefaultMessageNavigator.toVideoPlayer,
          toSingleChatMessageInfo:
              vDefaultMessageNavigator.toSingleChatMessageInfo,
          toMessagePage: (context, vRoom) {
            context.toPage(
              MyProjectMessagePageWrapper(
                room: vRoom,
              ),
            );
          },
          toBroadcastChatMessageInfo:
              vDefaultMessageNavigator.toBroadcastChatMessageInfo,
          toGroupChatMessageInfo:
              vDefaultMessageNavigator.toGroupChatMessageInfo,
          toGroupSettings: (context, data) {
            Get.toNamed(Routes.GROUP_SETTINGS, arguments: data);
            print("Going to group $data");
          },
          toSingleSettings: (context, data, peerIdentifier) {
            print("Going to toSingleSettings $data");
          },
          toBroadcastSettings: (context, data) {
            Get.toNamed(Routes.BROADCAST_SETTINGS, arguments: data);
          },
          toUserProfilePage: (context, identifier) {
            print("Going to toUserProfile $identifier");
          },
        ),
        callNavigator: vDefaultCallNavigator),
  );
}

Uri _getBaseUrl() {
  // return Uri.parse("http://192.168.1.5:3001");
  // if (true) {
  //   return Uri.parse("http://192.168.1.13:3001");
  // }
  if (kDebugMode) {
    if (kIsWeb || VPlatforms.isIOS || VPlatforms.isMacOs) {
      return Uri.parse("http://localhost:3001");
    }
    //this will only working on the android emulator
    //to test on real device get you ipv4 first google it ! how to get my ipv4
    // if (false) {
    //   return Uri.parse("http://192.168.1.3:3001");
    // }
    //10.0.2.2
    return Uri.parse("http://192.168.1.5:3001");
  }
  return Uri.parse("http://v_chat_endpoint:3001");
}
