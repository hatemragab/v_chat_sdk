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

class VNavigator {
  final VInfoMessageRouteFunction toMessageInfo;
  final VMediaViewerFunction toImageViewer;
  final Function(
    BuildContext context,
    VRoom vRoom,
  ) toMessagePage;
  final Future<List<String>?> Function(
    BuildContext context,
    String? currentRoomId,
  ) toForwardPage;
  final VMediaViewerFunction toVideoPlayer;

  const VNavigator({
    required this.toMessagePage,
    required this.toMessageInfo,
    required this.toImageViewer,
    required this.toVideoPlayer,
    required this.toForwardPage,
  });
}
