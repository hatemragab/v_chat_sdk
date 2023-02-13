import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

abstract class VCallEvents extends VAppEvent {
  final String roomId;

  const VCallEvents({
    required this.roomId,
  });

  @override
  List<Object?> get props => [roomId];

  @override
  String toString() {
    return 'VCallEvents{roomId: $roomId}';
  }
}

class VOnNewCallEvent extends VCallEvents {
  final VNewCallModel data;

  const VOnNewCallEvent({
    required super.roomId,
    required this.data,
  });

  @override
  String toString() {
    return 'VOnNewCallEvent{data: $data}';
  }
}

class VCallTimeoutEvent extends VCallEvents {
  const VCallTimeoutEvent({
    required super.roomId,
  });

  @override
  String toString() {
    return 'VCallTimeoutEvent{}';
  }
}

class VCallCanceledEvent extends VCallEvents {
  const VCallCanceledEvent({
    required super.roomId,
  });

  @override
  String toString() {
    return 'VCallCanceledEvent{}';
  }
}

class VCallRejectedEvent extends VCallEvents {
  const VCallRejectedEvent({
    required super.roomId,
  });

  @override
  String toString() {
    return 'VCallRejectedEvent{}';
  }
}

class VOnRtcIceEvent extends VCallEvents {
  final Map<String,dynamic> data;
  const VOnRtcIceEvent({
    required super.roomId,
    required this.data,
  });

  @override
  String toString() {
    return 'VCallRejectedEvent{ data $data}';
  }
}

class VCallAcceptedEvent extends VCallEvents {
  final VOnAcceptCall data;
  const VCallAcceptedEvent({
    required super.roomId,
    required this.data,
  });

  @override
  String toString() {
    return 'VCallAcceptedEvent{} data $data';
  }
}

class VCallEndedEvent extends VCallEvents {
  const VCallEndedEvent({
    required super.roomId,
  });

  @override
  String toString() {
    return 'VCallEndedEvent{}';
  }
}
