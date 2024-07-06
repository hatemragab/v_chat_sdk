// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

class CallActionButton extends StatelessWidget {
  const CallActionButton({
    super.key,
    this.onTap,
    required this.icon,
    this.isEnabled = true,
    this.backgroundColor,
    this.radius = 26,
    this.iconSize = 24,
    this.iconColor,
  });

  final Function()? onTap;
  final IconData icon;
  final bool isEnabled;
  final Color? backgroundColor;
  final int radius;
  final int iconSize;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isEnabled ? onTap : null,
      child: CircleAvatar(
        backgroundColor: backgroundColor ??
            (isEnabled ? Colors.white : Colors.grey.shade800),
        radius: radius.toDouble(),
        child: Icon(
          icon,
          size: iconSize.toDouble(),
          color: iconColor ?? Colors.grey.shade600,
        ),
      ),
    );
  }
}
