import 'dart:async';

import 'package:flutter/material.dart';

class VSearchAppBare extends StatefulWidget {
  final VoidCallback onClose;
  final int delay;
  final Function(String value) onSearch;
  final bool requestFocus;

  const VSearchAppBare({
    Key? key,
    required this.onClose,
    this.delay = 1200,
    required this.onSearch,
    this.requestFocus = true,
  }) : super(key: key);

  @override
  State<VSearchAppBare> createState() => _VSearchAppBareState();
}

class _VSearchAppBareState extends State<VSearchAppBare> {
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      titleSpacing: 0,
      leading: const SizedBox(
        width: 1,
      ),
      automaticallyImplyLeading: false,
      title: ListTile(
        contentPadding: EdgeInsets.zero,
        dense: true,
        minLeadingWidth: 0,
        title: TextField(
          autofocus: widget.requestFocus,
          decoration: const InputDecoration(hintText: "Search..."),
          onChanged: onSearchChanged,
          onSubmitted: (t) {
            widget.onSearch(t);
          },
        ),
      ),
      actions: [
        IconButton(onPressed: widget.onClose, icon: const Icon(Icons.close))
      ],
    );
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: widget.delay), () {
      widget.onSearch(query);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
