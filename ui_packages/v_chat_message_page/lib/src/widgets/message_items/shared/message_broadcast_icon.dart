import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class MessageBroadcastWidget extends StatelessWidget {
  final bool isFromBroadcast;

  const MessageBroadcastWidget({Key? key, required this.isFromBroadcast})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(right: 5),
      child: Icon(
        PhosphorIcons.speakerHigh,
        size: 16,
      ),
    );
  }
}
