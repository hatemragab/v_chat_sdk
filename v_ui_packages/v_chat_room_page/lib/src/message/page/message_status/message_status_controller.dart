import 'package:flutter/material.dart';

class MessageStatusController extends ValueNotifier {
  MessageStatusController() : super([]);

  void close() {
    dispose();
  }
}
