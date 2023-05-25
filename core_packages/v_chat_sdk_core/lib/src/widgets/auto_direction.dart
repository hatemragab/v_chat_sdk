// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

library auto_direction;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class AutoDirection extends StatefulWidget {
  final String text;
  final Widget child;
  final void Function(bool isRTL)? onDirectionChange;

  const AutoDirection({
    super.key,
    required this.text,
    required this.child,
    this.onDirectionChange,
  });

  @override
  AutoDirectionState createState() => AutoDirectionState();
}

class AutoDirectionState extends State<AutoDirection> {
  late String text;
  late Widget childWidget;

  @override
  Widget build(BuildContext context) {
    text = widget.text;
    childWidget = widget.child;
    return Directionality(
      textDirection: isRTL(text) ? TextDirection.rtl : TextDirection.ltr,
      child: childWidget,
    );
  }

  @override
  void didUpdateWidget(AutoDirection oldWidget) {
    if (isRTL(oldWidget.text) != isRTL(widget.text)) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => widget.onDirectionChange?.call(isRTL(widget.text)));
    }
    super.didUpdateWidget(oldWidget);
  }

  bool isRTL(String text) {
    if (text.isEmpty) return Directionality.of(context) == TextDirection.rtl;
    return intl.Bidi.detectRtlDirectionality(text);
  }
}
