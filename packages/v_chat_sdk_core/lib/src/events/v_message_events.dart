import 'package:event_bus_plus/res/app_event.dart';

abstract class VMessageEvents extends AppEvent {
  final String roomId;
  final String localId;

  const VMessageEvents({required this.roomId, required this.localId});

  @override
  List<Object?> get props => [roomId, localId];
}

class VInsertMessageEvent extends VMessageEvents {
  final String msg;

  const VInsertMessageEvent({
    required this.msg,
    required super.roomId,
    required super.localId,
  });

  @override
  List<Object?> get props => [...super.props, msg];
}
