import 'package:flutter/cupertino.dart';
import 'package:v_chat_sdk_core/src/models/models.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

typedef VInfoMessageRouteFunction = Function(
  BuildContext context,
  VRoom room,
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
  final VInfoMessageRouteFunction toMessageInfo;
  final VMediaViewerFunction toImageViewer;
  final VMediaViewerFunction toVideoPlayer;
  final VToUserProfileFunction? toUserProfile;
  final VToChatSettingsFunction? toGroupSettings;
  final VToChatSettingsFunction? toBroadcastSettings;

  final Function(
    BuildContext context,
    VRoom vRoom,
  ) toMessagePage;

  const VMessageNavigator({
    required this.toMessagePage,
    required this.toMessageInfo,
    required this.toImageViewer,
    required this.toVideoPlayer,
    this.toUserProfile,
    this.toBroadcastSettings,
    this.toGroupSettings,
  });
}

class VNavigator {
  final VRoomNavigator roomNavigator;
  final VMessageNavigator messageNavigator;

  const VNavigator({
    required this.roomNavigator,
    required this.messageNavigator,
  });
}
