// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:v_chat_sdk_core/src/models/models.dart';
import 'package:v_platform/v_platform.dart';

typedef VInfoMessageRouteFunction = Function(
  BuildContext context,
  VBaseMessage baseMessage,
);
typedef VMediaViewerFunction = Function(
  BuildContext context,
  VPlatformFile source,
);

typedef VToUserProfileFunction = Function(
  BuildContext context,
  String identifier,
);

typedef VToChatSettingsFunction = Function(
  BuildContext context,
  VToChatSettingsModel data,
);

typedef VToSingleOrOrderSettingsFunction = Function(
  BuildContext context,
  VToChatSettingsModel data,
  String identifier,
);

class VRoomNavigator {
  final Future<List<String>?> Function(
    BuildContext context,
    String? currentRoomId,
  ) toForwardPage;

  VRoomNavigator({
    required this.toForwardPage,
  });
}

class VMessageNavigator {
  ///message info
  final VInfoMessageRouteFunction toSingleChatMessageInfo;
  final VInfoMessageRouteFunction toGroupChatMessageInfo;
  final VInfoMessageRouteFunction toBroadcastChatMessageInfo;

  ///media
  final VMediaViewerFunction toImageViewer;
  final VMediaViewerFunction toVideoPlayer;

  ///user
  final VToUserProfileFunction? toUserProfilePage;

  /// chat settings
  final VToSingleOrOrderSettingsFunction? toSingleSettings;
  final VToSingleOrOrderSettingsFunction? toOrderSettings;
  final VToChatSettingsFunction? toGroupSettings;
  final VToChatSettingsFunction? toBroadcastSettings;

  final Function(
    BuildContext context,
    VRoom vRoom,
  ) toMessagePage;

  const VMessageNavigator({
    required this.toSingleChatMessageInfo,
    required this.toBroadcastChatMessageInfo,
    required this.toGroupChatMessageInfo,
    required this.toMessagePage,
    required this.toImageViewer,
    required this.toVideoPlayer,
    this.toUserProfilePage,
    this.toOrderSettings,
    this.toSingleSettings,
    this.toBroadcastSettings,
    this.toGroupSettings,
  });

  VMessageNavigator copyWith({
    VInfoMessageRouteFunction? toSingleChatMessageInfo,
    VInfoMessageRouteFunction? toGroupChatMessageInfo,
    VInfoMessageRouteFunction? toBroadcastChatMessageInfo,
    VMediaViewerFunction? toImageViewer,
    VMediaViewerFunction? toVideoPlayer,
    VToUserProfileFunction? toUserProfilePage,
    VToSingleOrOrderSettingsFunction? toSingleSettings,
    VToSingleOrOrderSettingsFunction? toOrderSettings,
    VToChatSettingsFunction? toGroupSettings,
    VToChatSettingsFunction? toBroadcastSettings,
    Function(
      BuildContext context,
      VRoom vRoom,
    )? toMessagePage,
  }) {
    return VMessageNavigator(
      toSingleChatMessageInfo:
          toSingleChatMessageInfo ?? this.toSingleChatMessageInfo,
      toGroupChatMessageInfo:
          toGroupChatMessageInfo ?? this.toGroupChatMessageInfo,
      toBroadcastChatMessageInfo:
          toBroadcastChatMessageInfo ?? this.toBroadcastChatMessageInfo,
      toImageViewer: toImageViewer ?? this.toImageViewer,
      toVideoPlayer: toVideoPlayer ?? this.toVideoPlayer,
      toUserProfilePage: toUserProfilePage ?? this.toUserProfilePage,
      toSingleSettings: toSingleSettings ?? this.toSingleSettings,
      toOrderSettings: toOrderSettings ?? this.toOrderSettings,
      toGroupSettings: toGroupSettings ?? this.toGroupSettings,
      toBroadcastSettings: toBroadcastSettings ?? this.toBroadcastSettings,
      toMessagePage: toMessagePage ?? this.toMessagePage,
    );
  }
}

class VCallNavigator {
  final Function(
    BuildContext context,
    VCallDto dto,
  ) toCall;

  final Function(
    BuildContext context,
    VNewCallModel callModel,
  ) toPickUp;

  const VCallNavigator({
    required this.toCall,
    required this.toPickUp,
  });
}

class VNavigator {
  final VRoomNavigator roomNavigator;
  final VMessageNavigator messageNavigator;
  final VCallNavigator? callNavigator;

  const VNavigator({
    required this.roomNavigator,
    required this.messageNavigator,
    this.callNavigator,
  });
}
