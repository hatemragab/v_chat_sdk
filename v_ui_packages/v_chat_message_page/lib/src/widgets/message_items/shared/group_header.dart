// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class GroupHeader extends StatelessWidget {
  final bool isGroup;
  final String senderName;
  final String senderImage;
  final VoidCallback onTab;

  const GroupHeader({
    Key? key,
    required this.isGroup,
    required this.senderName,
    required this.senderImage,
    required this.onTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isGroup) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(4),
      child: InkWell(
        onTap: onTab,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            VCircleAvatar(
              fullUrl: senderImage,
              radius: 10,
            ),
            const SizedBox(
              width: 5,
            ),
            senderName.cap.color(Colors.blue).black,
          ],
        ),
      ),
    );
  }
}
