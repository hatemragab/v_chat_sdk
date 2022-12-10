import 'package:flutter/material.dart';

class IconBuilder {
  final Icon sendMessageIcon;
  final Icon deliverMessageIcon;
  final Icon seenMessageIcon;
  final Icon pendingMessageIcon;
  final Icon errorMessageIcon;
  final Icon muteIcon;

  IconBuilder.dark({
    Color? seenColor = Colors.green,
  })  : sendMessageIcon = const Icon(Icons.done, color: Colors.white, size: 22),
        deliverMessageIcon =
            const Icon(Icons.done_all_outlined, color: Colors.white, size: 22),
        seenMessageIcon =
            Icon(Icons.done_all_outlined, color: seenColor, size: 22),
        pendingMessageIcon = const Icon(Icons.access_time_rounded,
            color: Colors.white, size: 22),
        errorMessageIcon =
            const Icon(Icons.refresh, color: Colors.white, size: 22),
        muteIcon = const Icon(Icons.notifications_off_outlined,
            color: Colors.white, size: 22);

  IconBuilder.light({Color? seenColor = Colors.blue})
      : sendMessageIcon = const Icon(
          Icons.done,
          color: Colors.black,
        ),
        deliverMessageIcon =
            const Icon(Icons.done_all_outlined, color: Colors.black, size: 22),
        seenMessageIcon =
            Icon(Icons.done_all_outlined, color: seenColor, size: 22),
        pendingMessageIcon = const Icon(Icons.access_time_rounded,
            color: Colors.black, size: 22),
        errorMessageIcon =
            const Icon(Icons.refresh, color: Colors.black, size: 22),
        muteIcon = const Icon(Icons.notifications_off_outlined,
            color: Colors.black, size: 22);

  const IconBuilder({
    this.sendMessageIcon = const Icon(
      Icons.done,
      size: 22,
    ),
    this.deliverMessageIcon = const Icon(
      Icons.done_all_outlined,
      size: 22,
    ),
    this.seenMessageIcon = const Icon(
      Icons.done_all_outlined,
      size: 22,
      color: Colors.green,
    ),
    this.pendingMessageIcon = const Icon(
      Icons.access_time_rounded,
      size: 22,
    ),
    this.errorMessageIcon = const Icon(
      Icons.refresh,
      size: 22,
    ),
    this.muteIcon = const Icon(
      Icons.notifications_off_outlined,
      size: 22,
    ),
  });
}
