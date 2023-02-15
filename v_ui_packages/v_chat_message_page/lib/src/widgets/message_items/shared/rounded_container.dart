// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;
  final Alignment alignment;
  final BoxShape boxShape;

  const RoundedContainer({
    super.key,
    required this.child,
    this.height,
    this.width,
    this.padding,
    this.color = Colors.transparent,
    this.alignment = Alignment.center,
    this.borderRadius,
    this.boxShape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        shape: boxShape,
      ),
      height: height,
      width: width,
      padding: padding,
      child: child,
    );
  }
}
