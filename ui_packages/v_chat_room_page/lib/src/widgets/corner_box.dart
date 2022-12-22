import 'package:flutter/widgets.dart';

/// Common positioned widget wrapper.
class CornerBox extends StatelessWidget {
  const CornerBox({
    Key? key,
    required this.child,
    this.offset = Offset.zero,
  }) : super(key: key);

  /// Offset position.
  final Offset offset;

  /// Child widget.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      width: 0,
      height: 0,
      right: 2,
      bottom: 13,
      child: OverflowBox(
        alignment: Alignment.center,
        minWidth: 0,
        minHeight: 0,
        maxWidth: double.maxFinite,
        maxHeight: double.maxFinite,
        child: child,
      ),
    );
  }
}
