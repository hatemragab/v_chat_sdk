// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class LocationMessageItem extends StatelessWidget {
  final VLocationMessage message;

  const LocationMessageItem({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          PhosphorIcons.mapPin,
          size: 44,
        ),
        Expanded(
          child: ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            dense: true,
            title: Text(message.data.linkPreviewData.title.toString()),
            subtitle: Text(
              message.data.linkPreviewData.desc.toString(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
      ],
    );
  }
}
