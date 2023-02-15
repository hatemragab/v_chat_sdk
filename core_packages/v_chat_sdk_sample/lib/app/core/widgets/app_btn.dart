// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:textless/textless.dart';

class AppBtn extends StatelessWidget {
  final VoidCallback onPress;
  final String title;
  final Object? heroTag;

  const AppBtn({
    Key? key,
    required this.onPress,
    required this.title,
    this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPress,
      heroTag: heroTag,
      child: title.text.alignCenter,
    );
  }
}
