import 'package:event_bus_plus/event_bus_plus.dart';

class VSocketStatusEvent extends AppEvent {
  final bool isConnected;

  const VSocketStatusEvent(this.isConnected);

  @override
  List<Object?> get props => [isConnected];
}
