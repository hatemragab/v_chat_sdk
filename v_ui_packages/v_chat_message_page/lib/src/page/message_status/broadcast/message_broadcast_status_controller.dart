import 'package:flutter/material.dart';

class MessageBroadcastStatusController extends ValueNotifier {
  MessageBroadcastStatusController() : super([]);

  void close() {
    dispose();
  }
}
