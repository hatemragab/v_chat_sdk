// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:textless/textless.dart';

/// A widget that displays typing indicator in the chat.
/// This widget receives a [text] parameter, which is a string that represents
/// the text to be displayed along with the typing indicator.
/// This widget is stateless, so any changes to the [text] property will cause
/// a rebuild of the widget tree. */ class ChatTypingWidget extends StatelessWidget { final String text; const ChatTypingWidget({Key? key, required this.text}) : super(key: key); }
class ChatTypingWidget extends StatelessWidget {
  final String text;

  const ChatTypingWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return text.text.color(Colors.green);
  }
}
