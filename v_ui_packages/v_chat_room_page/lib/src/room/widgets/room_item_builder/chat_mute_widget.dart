// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:v_chat_room_page/src/room/shared/shared.dart';

class ChatMuteWidget extends StatelessWidget {
  final bool isMuted;
  const ChatMuteWidget({Key? key, required this.isMuted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vRoomTheme = context.vRoomTheme;

    if (!isMuted) return const SizedBox.shrink();
    return vRoomTheme.muteIcon;
  }
}
