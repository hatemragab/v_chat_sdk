import 'package:flutter/material.dart';

class MessageGroupStatusController extends ValueNotifier {
  MessageGroupStatusController() : super([]);

  void close() {
    dispose();
  }
}
