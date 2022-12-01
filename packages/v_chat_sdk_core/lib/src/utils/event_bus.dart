import 'package:event_bus_plus/res/event_bus.dart';

class EventBusSingleton {
  final vChatEvents = EventBus();

  EventBusSingleton._privateConstructor();

  static final EventBusSingleton instance =
      EventBusSingleton._privateConstructor();

  void close() {
    vChatEvents.dispose();
  }
}
