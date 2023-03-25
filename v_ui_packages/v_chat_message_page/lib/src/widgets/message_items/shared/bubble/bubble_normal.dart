import 'package:flutter/material.dart';

const double BUBBLE_RADIUS = 16;

class BubbleNormal extends StatelessWidget {
  final double bubbleRadius;
  final bool isSender;
  final Color color;
  final bool tail;
  final Widget child;

  const BubbleNormal({
    Key? key,
    this.bubbleRadius = BUBBLE_RADIUS,
    required this.isSender,
    required this.child,
    required this.color,
    this.tail = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(bubbleRadius),
          topRight: Radius.circular(bubbleRadius),
          bottomLeft: Radius.circular(
            tail
                ? isSender
                    ? bubbleRadius
                    : 0
                : BUBBLE_RADIUS,
          ),
          bottomRight: Radius.circular(
            tail
                ? isSender
                    ? 0
                    : bubbleRadius
                : BUBBLE_RADIUS,
          ),
        ),
      ),
      child: child,
    );
  }
}
