import 'dart:async';

class VRtcAppLog {
  final String title;
  final String desc;

  const VRtcAppLog({
    required this.title,
    required this.desc,
  });
}

final vRtcLoggerStream = StreamController<VRtcAppLog>.broadcast();
