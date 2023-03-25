import 'package:flutter/material.dart';

const _darkMeSenderColor = Colors.indigo;
const _darkReceiverColor = Color(0xff515156);

const _lightReceiverColor = Color(0xffffffff);
const _lightMySenderColor = Colors.blue;

const _lightTextMeSenderColor = TextStyle(
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.normal,
);
const _lightTextMeReceiverColor = TextStyle(
  color: Colors.black,
  fontSize: 16,
  fontWeight: FontWeight.normal,
);

const _darkTextMeSenderColor = TextStyle(
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.normal,
);
const _darkTextReceiverColor = TextStyle(
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.normal,
);

abstract class VBaseMessageTheme {
  /// Used as a background color of a chat widget.
  final Color bubbleMeSenderColor;
  final Color bubbleMeReceiverColor;

  final TextStyle textMeReceiverColor;
  final TextStyle textMeSenderColor;

  VBaseMessageTheme({
    required this.bubbleMeSenderColor,
    required this.bubbleMeReceiverColor,
    required this.textMeSenderColor,
    required this.textMeReceiverColor,
  });
}

class VLightMessageTheme extends VBaseMessageTheme {
  VLightMessageTheme({
    super.bubbleMeSenderColor = _lightMySenderColor,
    super.bubbleMeReceiverColor = _lightReceiverColor,
    super.textMeSenderColor = _lightTextMeSenderColor,
    super.textMeReceiverColor = _lightTextMeReceiverColor,
  });
}

class VDarkMessageTheme extends VBaseMessageTheme {
  VDarkMessageTheme({
    super.bubbleMeSenderColor = _darkMeSenderColor,
    super.bubbleMeReceiverColor = _darkReceiverColor,
    super.textMeSenderColor = _darkTextMeSenderColor,
    super.textMeReceiverColor = _darkTextReceiverColor,
  });
}
