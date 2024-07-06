// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import '../../../v_chat_message_page.dart';

class VCallLocalization {
  final String exitFromTheCall;
  final String areYouSureToEndTheCall;
  final String cancel;
  final String ok;
  final String incomingVoiceCall;
  final String incomingVideoCall;
  final String accept;
  final String reject;
  final String microphoneAndCameraPermissionMustBeAccepted;
  final String microphonePermissionMustBeAccepted;

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
        microphoneAndCameraPermissionMustBeAccepted =
            'Microphone and camera permission must be accepted...',
        microphonePermissionMustBeAccepted =
            'Microphone permission must be accepted',
        busy = 'Busy',
        ring = 'Ring...',
        accept = 'Accept',
        reject = 'Reject',
        accepted = 'Accepted',
        incomingVoiceCall = 'incoming voice call',
        incomingVideoCall = 'incoming video call',
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
    required this.accept,
    required this.reject,
    required this.accepted,
    required this.roomAlreadyInCall,
    required this.microphoneAndCameraPermissionMustBeAccepted,
    required this.microphonePermissionMustBeAccepted,
    required this.timeout,
    required this.incomingVoiceCall,
    required this.callEnd,
    required this.rejected,
    required this.endToEndEncryption,
    required this.incomingVideoCall,
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
