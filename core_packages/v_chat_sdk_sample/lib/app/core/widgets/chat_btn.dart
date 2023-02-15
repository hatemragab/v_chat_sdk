// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

class ChatBtn extends StatelessWidget {
  final VoidCallback onPress;

  const ChatBtn({Key? key, required this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPress,
      heroTag: "${DateTime.now().microsecondsSinceEpoch}",
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.message),
          SizedBox(
            width: 5,
          ),
          Text("Chat"),
        ],
      ),
    );
  }
}
