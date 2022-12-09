import 'package:flutter/material.dart';

class VMessageAppBare extends StatelessWidget {
  final String title;
  const VMessageAppBare({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
    );
  }
}
