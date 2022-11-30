import 'package:event_bus_plus/res/app_event.dart';

class VSocketIntervalEvent extends AppEvent {
  @override
  List<Object?> get props => [DateTime.now().microsecondsSinceEpoch];
}
