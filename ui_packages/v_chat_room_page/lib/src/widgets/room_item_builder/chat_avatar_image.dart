import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class ChatAvatarImage extends StatelessWidget {
  final VFullUrlModel imageUrl;
  final bool isOnline;
  final String chatTitle;

  const ChatAvatarImage({
    Key? key,
    required this.imageUrl,
    required this.isOnline,
    required this.chatTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdvancedAvatar(
      size: 60,
      statusColor: isOnline ? Colors.green : null,
      name: chatTitle,
      image: CachedNetworkImageProvider(
        imageUrl.fullUrl,
      ),
    );
  }
}
