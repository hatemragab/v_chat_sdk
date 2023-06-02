// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:event_bus_plus/res/event_bus.dart';

/// vEventBus is a singleton instance of [EventBus] for v chat service
abstract class VEventBusSingleton {
  static EventBus vEventBus = EventBus();
}
