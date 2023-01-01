import 'package:flutter/material.dart';

import '../../v_chat_sdk_core.dart';

class VSocketStatusWidget extends StatefulWidget {
  final BoxDecoration decoration;
  final EdgeInsets padding;
  final String connectingString;
  final Duration delay;

  const VSocketStatusWidget({
    Key? key,
    this.decoration = const BoxDecoration(color: Colors.red),
    this.padding = const EdgeInsets.all(8),
    this.connectingString = "Connecting...",
    this.delay = const Duration(seconds: 5),
  }) : super(key: key);

  @override
  State<VSocketStatusWidget> createState() => _VSocketStatusWidgetState();
}

class _VSocketStatusWidgetState extends State<VSocketStatusWidget> {
  final _socket = VChatController.I.nativeApi.remote.socketIo;
  bool show = false;

  @override
  void initState() {
    _delay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!show) {
      return const SizedBox.shrink();
    }
    return StreamBuilder<VSocketStatusEvent>(
      stream: _socket.socketStatusStream,
      initialData: VSocketStatusEvent(_socket.isConnected),
      builder: (context, snapshot) {
        if (!snapshot.data!.isConnected) {
          return Container(
            decoration: widget.decoration,
            child: Padding(
              padding: widget.padding,
              child: Text(
                widget.connectingString,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _delay() async {
    await Future.delayed(widget.delay);
    setState(() {
      show = true;
    });
  }
}
