// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:permission_handler/permission_handler.dart';
import 'package:v_chat_message_page/src/agora/pages/pick_up/pick_up.dart';
import 'package:v_chat_message_page/src/core/extension.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../../v_chat_message_page.dart';
import '../../v_chat/v_app_alert.dart';
import '../pages/call/call_page.dart';
import '../v_agora.dart';

final vDefaultCallNavigator = VCallNavigator(
  toPickUp: (context, callModel) async {
    if (!VPlatforms.isMobile) return;
    context.toPage(PickUp(
      callModel: callModel,
      localization: VCallLocalization.fromEnglish(),
    ));
  },
  toCall: (context, dto) async {
    if (!VPlatforms.isMobile) return;
    final micRes = await [Permission.microphone].request();
    if (dto.isVideoEnable) {
      final cameraRes = await [Permission.camera].request();
      if (cameraRes[Permission.camera] != PermissionStatus.granted) {
        VAppAlert.showSuccessSnackBar(
          msg: VCallLocalization.fromEnglish()
              .microphoneAndCameraPermissionMustBeAccepted,
          context: context,
        );
        return;
      }
    }
    if (micRes[Permission.microphone] != PermissionStatus.granted) {
      VAppAlert.showSuccessSnackBar(
        msg: VCallLocalization.fromEnglish().microphonePermissionMustBeAccepted,
        context: context,
      );
      return;
    }
    context.toPage(
      VCallPage(
        dto: dto,
      ),
    );
  },
);
