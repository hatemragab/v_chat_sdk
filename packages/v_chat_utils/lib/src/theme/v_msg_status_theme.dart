import 'package:flutter/material.dart';

class VMsgStatusTheme {
  final Widget pendingIcon;
  final Widget sendIcon;
  final Widget deliverIcon;
  final Widget seenIcon;
  final Widget refreshIcon;

  const VMsgStatusTheme._({
    required this.pendingIcon,
    required this.sendIcon,
    required this.deliverIcon,
    required this.seenIcon,
    required this.refreshIcon,
  });

  static const double _iconSize = 19.0;

  const VMsgStatusTheme.light({
    this.pendingIcon = const Icon(
      Icons.timer_outlined,
      color: Colors.black26,
      size: _iconSize,
    ),
    this.sendIcon = const Icon(
      Icons.done,
      color: Colors.black26,
      size: _iconSize,
    ),
    this.deliverIcon = const Icon(
      Icons.done_all,
      color: Colors.black26,
      size: _iconSize,
    ),
    this.seenIcon = const Icon(
      Icons.done_all,
      color: Colors.blue,
      size: _iconSize,
    ),
    this.refreshIcon = const Icon(
      Icons.refresh,
      color: Colors.red,
      size: _iconSize,
    ),
  });

  const VMsgStatusTheme.dark({
    this.pendingIcon = const Icon(
      Icons.timer_outlined,
      color: Colors.grey,
      size: _iconSize,
    ),
    this.sendIcon = const Icon(
      Icons.done,
      color: Colors.grey,
      size: _iconSize,
    ),
    this.deliverIcon = const Icon(
      Icons.done_all,
      color: Colors.grey,
      size: _iconSize,
    ),
    this.seenIcon = const Icon(
      Icons.done_all,
      color: Colors.blue,
      size: _iconSize,
    ),
    this.refreshIcon = const Icon(
      Icons.refresh,
      color: Colors.red,
      size: _iconSize,
    ),
  });

  VMsgStatusTheme copyWith({
    Widget? pendingIcon,
    Widget? sendIcon,
    Widget? deliverIcon,
    Widget? seenIcon,
    Widget? refreshIcon,
  }) {
    return VMsgStatusTheme._(
      pendingIcon: pendingIcon ?? this.pendingIcon,
      sendIcon: sendIcon ?? this.sendIcon,
      deliverIcon: deliverIcon ?? this.deliverIcon,
      seenIcon: seenIcon ?? this.seenIcon,
      refreshIcon: refreshIcon ?? this.refreshIcon,
    );
  }
}
