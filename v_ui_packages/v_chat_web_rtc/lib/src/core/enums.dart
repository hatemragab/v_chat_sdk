enum CallStatus {
  //when init the stream
  connecting,
  busy,
  ring,
  //call started
  accepted,
  roomAlreadyInCall,
  timeout,
  //when any user close the chat
  callEnd,
  rejected,
}

extension CallStatusExt on CallStatus {
  bool get isConnecting => this == CallStatus.connecting;
  bool get busy => this == CallStatus.busy;
  bool get ring => this == CallStatus.ring;
  bool get accepted => this == CallStatus.accepted;
  bool get timeout => this == CallStatus.timeout;
  bool get callEnd => this == CallStatus.callEnd;
  bool get rejected => this == CallStatus.rejected;
  bool get roomAlreadyInCall => this == CallStatus.roomAlreadyInCall;
}
