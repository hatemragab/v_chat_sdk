import 'package:flutter/material.dart';

class ListViewArrowDown extends StatefulWidget {
  const ListViewArrowDown({
    super.key,
    required this.onPress,
    required this.scrollController,
  });

  final VoidCallback onPress;
  final ScrollController scrollController;

  @override
  State<ListViewArrowDown> createState() => _ListViewArrowDownState();
}

class _ListViewArrowDownState extends State<ListViewArrowDown> {
  bool isShown = false;

  @override
  void initState() {
    widget.scrollController.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isShown) {
      return const SizedBox.shrink();
    }
    return InkWell(
      onTap: widget.onPress,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.withOpacity(.8),
        ),
        child: const Icon(Icons.keyboard_double_arrow_down),
      ),
    );
  }

  void _listener() {
    if (widget.scrollController.offset > 150.0) {
      setState(() {
        isShown = true;
      });
    } else {
      setState(() {
        isShown = false;
      });
    }
  }
}
