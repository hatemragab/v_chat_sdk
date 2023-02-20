// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class ForwardItemWidget extends StatelessWidget {
  final bool isFroward;

  const ForwardItemWidget({
    Key? key,
    required this.isFroward,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isFroward) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.forward,
            color: Colors.grey,
            size: 18,
          ),
          const SizedBox(
            width: 6,
          ),
          VTrans.of(context).labels.forwarded.cap.color(Colors.grey)
        ],
      ),
    );
  }
}
