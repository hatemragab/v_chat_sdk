import 'package:flutter/material.dart';

class PopupItem extends PopupMenuItem {
  final int flag;
  final Function(int f) onTap;

  const PopupItem({
    required this.flag,
    required this.onTap,
    required Widget child,
  }) : super(child: child);

  @override
  _PopupItemState createState() => _PopupItemState(flag: flag, onTap: onTap);
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
