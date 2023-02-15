// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class VChatAvatarImage extends StatelessWidget {
  final String imageUrl;
  final bool isOnline;
  final String chatTitle;
  final int size;

  const VChatAvatarImage({
    Key? key,
    required this.imageUrl,
    required this.isOnline,
    required this.chatTitle,
    this.size = 60,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdvancedAvatar(
      size: size.toDouble(),
      statusColor: isOnline ? Colors.green : null,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
      foregroundDecoration:
          BoxDecoration(borderRadius: BorderRadius.circular(100)),
      name: chatTitle,
      child: VCircleAvatar(
        fullUrl: imageUrl,
      ),
    );
  }
}
