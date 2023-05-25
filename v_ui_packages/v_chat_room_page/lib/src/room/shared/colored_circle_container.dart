// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:textless/textless.dart';

class ColoredCircleContainer extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String text;
  final EdgeInsets padding;

  const ColoredCircleContainer({
    Key? key,
    required this.backgroundColor,
    required this.text,
    this.padding = const EdgeInsets.all(8),
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      padding: padding,
      child: text.cap.color(textColor),
    );
  }
}
