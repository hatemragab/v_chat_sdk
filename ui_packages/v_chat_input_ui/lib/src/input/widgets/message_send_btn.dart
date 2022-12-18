import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class MessageSendBtn extends StatelessWidget {
  final VoidCallback onSend;

  const MessageSendBtn({
    super.key,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSend,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green,
        ),
        child: const Icon(
          PhosphorIcons.paperPlaneRight,
          color: Colors.white,
        ),
      ),
    );
  }
}
