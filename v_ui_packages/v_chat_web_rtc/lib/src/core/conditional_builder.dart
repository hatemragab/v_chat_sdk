// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

class VConditionalBuilder extends StatelessWidget {
  final bool _condition;
  final Function _thenBuilder;
  final Function? _elseBuilder;

  const VConditionalBuilder({
    super.key,
    required bool condition,
    required Function thenBuilder,
    Function? elseBuilder,
  })  : _condition = condition,
        _thenBuilder = thenBuilder,
        _elseBuilder = elseBuilder;

  @override
  Widget build(BuildContext context) {
    return _condition
        ? _thenBuilder.call() ?? const SizedBox.shrink()
        : _elseBuilder?.call() ?? const SizedBox.shrink();
  }
}
