// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../shared/constraint_image.dart';

class ImageMessageItem extends StatelessWidget {
  final VImageMessage message;

  const ImageMessageItem({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return VConstraintImage(
      data: message.data,
      borderRadius: BorderRadius.circular(15),
    );
  }
}
