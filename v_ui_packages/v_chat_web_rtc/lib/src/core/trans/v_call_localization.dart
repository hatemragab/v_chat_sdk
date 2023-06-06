import '../enums.dart';

class VCallLocalization {
  final String exitFromTheCall;
  final String areYouSureToEndTheCall;
  final String cancel;
  final String ok;

  ///----
  final String connecting;
  final String busy;
  final String ring;
  final String accepted;
  final String roomAlreadyInCall;
  final String timeout;
  final String callEnd;
  final String rejected;
  final String endToEndEncryption;

  VCallLocalization.fromEnglish()
      : exitFromTheCall = 'Exit from the call',
        areYouSureToEndTheCall = 'Are you sure to end the call?',
        cancel = 'Cancel',
        ok = 'Ok',
        connecting = 'Connecting...',
        busy = 'Busy',
        ring = 'Ring...',
        accepted = 'Accepted',
        roomAlreadyInCall = 'Room already in call',
        timeout = 'Timeout',
        callEnd = 'Call end',
        rejected = 'Rejected',
        endToEndEncryption = 'End to end encryption';

  const VCallLocalization({
    required this.exitFromTheCall,
    required this.areYouSureToEndTheCall,
    required this.cancel,
    required this.ok,
    required this.connecting,
    required this.busy,
    required this.ring,
    required this.accepted,
    required this.roomAlreadyInCall,
    required this.timeout,
    required this.callEnd,
    required this.rejected,
    required this.endToEndEncryption,
  });

  String transCallStatus(CallStatus status) {
    switch (status) {
      case CallStatus.connecting:
        return connecting;
      case CallStatus.busy:
        return busy;
      case CallStatus.ring:
        return ring;
      case CallStatus.accepted:
        return accepted;
      case CallStatus.roomAlreadyInCall:
        return roomAlreadyInCall;
      case CallStatus.timeout:
        return timeout;
      case CallStatus.callEnd:
        return callEnd;
      case CallStatus.rejected:
        return rejected;
    }
  }
}
