import 'package:flutter/material.dart';

class PopupItem extends PopupMenuItem {
  final int flag;
  final Function(int f) onDone;

  const PopupItem({
    required this.flag,
    required this.onDone,
    required Widget child,
  }) : super(child: child);

  @override
  _PopupItemState createState() => _PopupItemState(flag: flag, onTap: onDone);
}

class _PopupItemState extends PopupMenuItemState {
  final int flag;
  final Function(int f) onTap;

  _PopupItemState({
    required this.flag,
    required this.onTap,
  });

  @override
  void handleTap() {
    Navigator.pop(context, widget.value);
    onTap(flag);
  }
}
