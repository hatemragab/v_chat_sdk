import 'dart:async';

mixin StreamMix {
  final streamsMix = <StreamSubscription>[];

  void closeStreamMix() {
    for (final stream in streamsMix) {
      stream.cancel();
    }
  }
}
