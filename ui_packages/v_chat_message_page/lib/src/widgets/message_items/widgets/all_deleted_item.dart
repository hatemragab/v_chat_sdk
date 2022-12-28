import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class AllDeletedItem extends StatelessWidget {
  final VAllDeletedMessage message;
  const AllDeletedItem({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text("AllDeletedItem");
  }
}
