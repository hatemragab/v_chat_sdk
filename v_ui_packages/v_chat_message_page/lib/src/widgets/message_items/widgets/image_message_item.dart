import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../shared/constraint_image.dart';

class ImageMessageItem extends StatelessWidget {
  final VImageMessage message;

  const ImageMessageItem({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VConstraintImage(
      data: message.data,
      borderRadius: BorderRadius.circular(15),
    );
  }
}
