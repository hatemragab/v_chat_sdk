import 'package:flutter/material.dart';

class MessageSingleStatusController extends ValueNotifier {
  MessageSingleStatusController() : super([]);

  void close() {
    dispose();
  }
}
