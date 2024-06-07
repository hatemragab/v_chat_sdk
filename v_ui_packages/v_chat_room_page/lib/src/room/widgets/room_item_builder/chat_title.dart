// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v_chat_room_page/src/room/shared/shared.dart';

import '../../../../v_chat_room_page.dart';

/// A widget that displays the title of a chat. /// /// This widget is created using the [StatelessWidget] class, which means it does not have any mutable state. /// The [title] parameter is required to display the title of the chat. class ChatTitle extends StatelessWidget { /// The title of the chat. final String title;
/// Creates a [ChatTitle] widget. /// /// The [title] parameter is required to display the title of the chat. const ChatTitle({ Key? key, required this.title, }) : super(key: key);
// ... }
class ChatTitle extends StatelessWidget {
  /// The title of the chat.
  final String title;

  /// Creates a [ChatTitle] widget.
  const ChatTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return context.vRoomTheme.getChatTitle(title);
  }
}
