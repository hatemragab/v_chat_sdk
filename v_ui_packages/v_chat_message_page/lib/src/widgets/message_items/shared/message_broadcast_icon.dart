// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class MessageBroadcastWidget extends StatelessWidget {
  final bool isFromBroadcast;

  const MessageBroadcastWidget({super.key, required this.isFromBroadcast});

  @override
  Widget build(BuildContext context) {
    if (!isFromBroadcast) return const SizedBox.shrink();
    return const Padding(
      padding: EdgeInsets.only(right: 5),
      child: Icon(
        PhosphorIcons.speakerHigh,
        size: 15,
      ),
    );
  }
}
