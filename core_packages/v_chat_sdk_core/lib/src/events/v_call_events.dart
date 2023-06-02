// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

/// Abstract base class for call events.
/// All call event classes should extend this class.
abstract class VCallEvents extends VAppEvent {
  final String roomId; // The ID of the room associated with the event.

  const VCallEvents({
    required this.roomId,
  });

  @override
  List<Object?> get props => [roomId];
}

/// Event for a new call.
class VOnNewCallEvent extends VCallEvents {
  final VNewCallModel data; // The data for the new call.

  const VOnNewCallEvent({
    required super.roomId,
    required this.data,
  });
}

/// Event for a call timeout.
class VCallTimeoutEvent extends VCallEvents {
  const VCallTimeoutEvent({
    required super.roomId,
  });
}

/// Event for a canceled call.
class VCallCanceledEvent extends VCallEvents {
  const VCallCanceledEvent({
    required super.roomId,
  });
}

/// Event for a rejected call.
class VCallRejectedEvent extends VCallEvents {
  const VCallRejectedEvent({
    required super.roomId,
  });
}

/// Event for an RTC ICE event. RTC ICE (Interactive Connectivity Establishment) is a framework
/// to allow your web browser to connect with peers.
class VOnRtcIceEvent extends VCallEvents {
  final Map<String, dynamic> data; // The data for the RTC ICE event.

  const VOnRtcIceEvent({
    required super.roomId,
    required this.data,
  });
}

/// Event for an accepted call.
class VCallAcceptedEvent extends VCallEvents {
  final VOnAcceptCall data; // The data for the accepted call.

  const VCallAcceptedEvent({
    required super.roomId,
    required this.data,
  });
}

/// Event for an ended call.
class VCallEndedEvent extends VCallEvents {
  const VCallEndedEvent({
    required super.roomId,
  });
}
