import 'package:flutter/cupertino.dart';
import 'package:v_chat_ui/src/core/extension.dart';

class RoomMuteWidget extends StatelessWidget {
  final bool isMuted;
  const RoomMuteWidget({Key? key, required this.isMuted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vRoomTheme = context.vRoomTheme;

    if (!isMuted) return const SizedBox.shrink();
    return vRoomTheme.muteIcon;
  }
}
