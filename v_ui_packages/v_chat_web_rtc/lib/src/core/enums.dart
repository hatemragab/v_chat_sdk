import 'package:flutter/cupertino.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

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

extension CallStatusTr on CallStatus {
  String tr(BuildContext context) {
    switch (this) {
      case CallStatus.connecting:
        return VTrans.labelsOf(context).connecting;

      case CallStatus.busy:
        return VTrans.labelsOf(context).busy;
      case CallStatus.ring:
        return VTrans.labelsOf(context).ring;
      case CallStatus.accepted:
        return "Accepted";
      case CallStatus.roomAlreadyInCall:
        return VTrans.labelsOf(context).roomAlreadyInCall;
      case CallStatus.timeout:
        return VTrans.labelsOf(context).timeout;
      case CallStatus.callEnd:
        return VTrans.labelsOf(context).callEnd;
      case CallStatus.rejected:
        return VTrans.labelsOf(context).read;
    }
  }
}
