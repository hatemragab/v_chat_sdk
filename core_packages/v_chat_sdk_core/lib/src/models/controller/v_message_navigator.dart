import 'package:flutter/cupertino.dart';
import 'package:v_chat_sdk_core/src/models/models.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

typedef VInfoMessageRouteFunction = Function(
  BuildContext context,
  VBaseMessage baseMessage,
);
typedef VMediaViewerFunction = Function(
  BuildContext context,
  VPlatformFileSource source,
);

typedef VToUserProfileFunction = Function(
  BuildContext context,
  String identifier,
);

typedef VToChatSettingsFunction = Function(
  BuildContext context,
  VToChatSettingsModel data,
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
  final Function(BuildContext context, String roomId) toViewChatMedia;

  ///user
  final VToUserProfileFunction? toUserProfilePage;

  /// chat settings
  final VToUserProfileFunction? toSingleSettings;
  final VToChatSettingsFunction? toOrderSettings;
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
    required this.toViewChatMedia,
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
    Function(BuildContext context, String roomId)? toViewChatMedia,
    VToUserProfileFunction? toUserProfilePage,
    VToUserProfileFunction? toSingleSettings,
    VToChatSettingsFunction? toOrderSettings,
    VToChatSettingsFunction? toGroupSettings,
    VToChatSettingsFunction? toBroadcastSettings,
    Function(
      BuildContext context,
      VRoom vRoom,
    )?
        toMessagePage,
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
      toViewChatMedia: toViewChatMedia ?? this.toViewChatMedia,
      toUserProfilePage: toUserProfilePage ?? this.toUserProfilePage,
      toSingleSettings: toSingleSettings ?? this.toSingleSettings,
      toOrderSettings: toOrderSettings ?? this.toOrderSettings,
      toGroupSettings: toGroupSettings ?? this.toGroupSettings,
      toBroadcastSettings: toBroadcastSettings ?? this.toBroadcastSettings,
      toMessagePage: toMessagePage ?? this.toMessagePage,
    );
  }
}

class VNavigator {
  final VRoomNavigator roomNavigator;
  final VMessageNavigator messageNavigator;

  const VNavigator({
    required this.roomNavigator,
    required this.messageNavigator,
  });
}
