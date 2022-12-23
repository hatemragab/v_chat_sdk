import 'package:flutter/material.dart';

class MiddleItemHolder extends StatelessWidget {
  final Widget child;
  const MiddleItemHolder({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
