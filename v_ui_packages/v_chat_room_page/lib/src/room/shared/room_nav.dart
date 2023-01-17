import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../v_chat_room_page.dart';

final roomDefaultNavigator = VRoomNavigator(
  toForwardPage: (context, currentRoomId) async {
    return await context.toPage(VChooseRoomsPage(
      currentRoomId: currentRoomId,
    ));
  },
);
