import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class MessageRecordBtn extends StatelessWidget {
  final VoidCallback onRecordClick;

  const MessageRecordBtn({super.key, required this.onRecordClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onRecordClick,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green,
        ),
        child: const Icon(
          PhosphorIcons.microphoneFill,
          color: Colors.white,
        ),
      ),
    );
  }
}
