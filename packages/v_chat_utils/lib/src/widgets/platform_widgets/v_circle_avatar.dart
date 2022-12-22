import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../v_chat_utils.dart';

class VCircleAvatar extends StatelessWidget {
  final int radius;
  final VFullUrlModel fullUrl;

  const VCircleAvatar({
    Key? key,
    this.radius = 28,
    required this.fullUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      foregroundColor: Theme.of(context).primaryColor,
      backgroundColor: Colors.transparent,
      radius: double.tryParse(radius.toString()),
      backgroundImage: CachedNetworkImageProvider(
        fullUrl.fullUrl,
      ),
    );
  }
}
