import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../v_chat_room_page.dart';
import '../message/page/message_status/message_status_page.dart';

final messageDefaultNavigator = VNavigator(
  toForwardPage: (context, currentRoomId) async {
    return await context.toPage(VChooseRoomsPage(
      currentRoomId: currentRoomId,
    ));
  },
  toMessagePage: (context, vRoom) {
    context.toPage(VMessagePage(vRoom: vRoom));
  },
  toVideoPlayer: (context, source) {
    context.toPage(
      VImageViewer(
        platformFileSource: source,
        appName: VAppConstants.appName,
        //todo trans
        successfullyDownloaded: "successfullyDownloaded",
      ),
    );
  },
  toImageViewer: (context, source) {
    context.toPage(
      VVideoPlayer(
        platformFileSource: source,
      ),
    );
  },
  toMessageInfo: (context, room, baseMessage) {
    context.toPage(VMessageStatusPage(
      message: baseMessage,
      room: room,
    ));
  },
);
