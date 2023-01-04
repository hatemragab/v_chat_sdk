import 'package:event_bus_plus/res/event_bus.dart';

class VEventBusSingleton {
  static EventBus vEventBus = EventBus();

  // VEventBusSingleton._privateConstructor();
  //
  // static final VEventBusSingleton instance =
  //     VEventBusSingleton._privateConstructor();

  static void close() {
    vEventBus.dispose();
  }
}
