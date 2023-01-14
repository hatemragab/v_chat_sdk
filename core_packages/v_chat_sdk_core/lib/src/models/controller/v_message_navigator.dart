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
  final Function(
    BuildContext context,
    VRoom vRoom,
  ) toMessagePage;

  final VMediaViewerFunction toVideoPlayer;

  const VMessageNavigator({
    required this.toMessagePage,
    required this.toMessageInfo,
    required this.toImageViewer,
    required this.toVideoPlayer,
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
