import 'package:flutter/material.dart';

class VMessageItemBuilder {
  VMessageItemBuilder._({
    required this.directionalItemDecoration,
    required this.directionalItemConstraints,
  });

  final BoxDecoration directionalItemDecoration;
  final BoxConstraints Function(BuildContext) directionalItemConstraints;

  factory VMessageItemBuilder.light() {
    return VMessageItemBuilder._(
      directionalItemDecoration: BoxDecoration(),
      directionalItemConstraints: (context) => BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * .80,
        maxHeight: MediaQuery.of(context).size.height * .40,
      ),
    );
  }

  factory VMessageItemBuilder.dark() {
    return VMessageItemBuilder._(
      directionalItemDecoration: BoxDecoration(color: Colors.green),
      directionalItemConstraints: (context) => BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * .80,
        maxHeight: MediaQuery.of(context).size.height * .40,
      ),
    );
  }
}
