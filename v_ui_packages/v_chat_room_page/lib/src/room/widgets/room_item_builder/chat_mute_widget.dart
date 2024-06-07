// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:v_chat_room_page/src/room/shared/shared.dart';

/// A [StatelessWidget] that displays a mute icon for a chat conversation if [isMuted] is true. /// /// The [ChatMuteWidget] is a simple widget that displays a mute icon /// using an [Icon] widget if the [isMuted] bool is true, and nothing otherwise. /// /// This widget is intended to be used within a [ChatMessageTile] or /// similar widget, to indicate whether the current chat is muted. /// /// To use the [ChatMuteWidget], simply create a new instance of the widget /// and pass in a boolean value for [isMuted] - this should be set to true /// if the chat conversation is currently muted, and false otherwise. /// /// Example usage: /// /// /// ChatMuteWidget(isMuted: true) /// class ChatMuteWidget extends StatelessWidget { final bool isMuted;
class ChatMuteWidget extends StatelessWidget {
  /// Flag indicating whether the current chat is muted.
  final bool isMuted;

  /// Creates a new instance of [ChatMuteWidget].
  const ChatMuteWidget({super.key, required this.isMuted});

  @override
  Widget build(BuildContext context) {
    final vRoomTheme = context.vRoomTheme;

    if (!isMuted) return const SizedBox.shrink();
    return vRoomTheme.muteIcon;
  }
}
