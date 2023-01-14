import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../v_chat_message_page.dart';
import '../page/message_status/message_status_page.dart';

final messageDefaultNavigator = VMessageNavigator(
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
