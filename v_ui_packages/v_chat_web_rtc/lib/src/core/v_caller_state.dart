import 'enums.dart';

class VCallerState {
  Duration time;
  CallStatus status;

  VCallerState({
    this.time = Duration.zero,
    this.status = CallStatus.connecting,
  });

  @override
  String toString() {
    return '{time: $time, status: $status}';
  }
}
