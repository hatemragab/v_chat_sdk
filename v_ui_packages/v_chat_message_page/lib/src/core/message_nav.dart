// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_message_page/src/core/extension.dart';
import 'package:v_chat_message_page/src/page/message_status/group/message_group_status_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../v_chat_message_page.dart';
import '../page/message_status/broadcast/message_broadcast_status_page.dart';
import '../page/message_status/single/message_single_status_page.dart';
import '../v_chat/v_image_viewer.dart';
import '../v_chat/v_video_player.dart';

final vDefaultMessageNavigator = VMessageNavigator(
  toMessagePage: (context, vRoom) {
    return context.toPage(
      VMessagePage(
        vRoom: vRoom,
        localization: VMessageLocalization.fromEnglish(),
      ),
    );
  },
  toVideoPlayer: (context, source) {
    return context.toPage(
      VVideoPlayer(
        platformFileSource: source,
        downloadingLabel: "Downloading...",
        successfullyDownloadedInLabel: "Successfully downloaded in ",
      ),
    );
  },
  toImageViewer: (context, source) {
    return context.toPage(
      VImageViewer(
        platformFileSource: source,
        downloadingLabel: "Downloading...",
        successfullyDownloadedInLabel: "Successfully downloaded in ",
      ),
    );
  },
  toGroupChatMessageInfo: (context, message) => context.toPage(
    VMessageGroupStatusPage(
      message: message,
      deliveredLabel: "Delivered",
      messageInfoLabel: "Message Info",
      readLabel: "Read",
      vMessageLocalization: VMessageLocalization.fromEnglish(),
    ),
  ),
  toBroadcastChatMessageInfo: (context, message) => context.toPage(
    VMessageBroadcastStatusPage(
      message: message,
      deliveredLabel: "Delivered",
      messageInfoLabel: "Message Info",
      readLabel: "Read",
      vMessageLocalization: VMessageLocalization.fromEnglish(),
    ),
  ),
  toSingleChatMessageInfo: (context, message) => context.toPage(
    VMessageSingleStatusPage(
      message: message,
      deliveredLabel: "Delivered",
      readLabel: "Read",
      vMessageLocalization: VMessageLocalization.fromEnglish(),
    ),
  ),
);
