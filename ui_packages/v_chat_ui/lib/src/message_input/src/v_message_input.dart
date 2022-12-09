import 'package:flutter/material.dart';

class VMessageInput extends StatelessWidget {
  const VMessageInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const TextField(
      decoration: InputDecoration(hintText: "write your message ..."),
    );
  }
}
