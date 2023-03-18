// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:event_bus_plus/res/event_bus.dart';

abstract class VEventBusSingleton {
  static EventBus vEventBus = EventBus();

  // VEventBusSingleton._privateConstructor();
  //
  // static final VEventBusSingleton instance =
  //     VEventBusSingleton._privateConstructor();

  // static void close() {
  //   vEventBus.dispose();
  // }
}
