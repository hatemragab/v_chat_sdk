import 'package:flutter/material.dart';

class CenterItemHolder extends StatelessWidget {
  const CenterItemHolder({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
