import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../corner_box.dart';

class ChatAvatarImage extends StatelessWidget {
  final VFullUrlModel imageUrl;
  final bool isOnline;

  const ChatAvatarImage({
    Key? key,
    required this.imageUrl,
    required this.isOnline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        VCircleAvatar(
          radius: 28,
          fullUrl: imageUrl,
        ),
        CornerBox(
          child: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
              border: Border.all(
                width: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
    return AdvancedAvatar(
      statusSize: 10,
      size: 60,
      statusColor: isOnline ? Colors.green : Colors.transparent,
      image: CachedNetworkImageProvider(imageUrl.fullUrl),
    );
  }
}
