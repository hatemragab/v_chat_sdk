abstract class RtcHelper {
  static Map<String, dynamic> iceServers = {
    "sdpSemantics": "plan-b",
    'iceServers': [
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
          'stun:stun2.l.google.com:19302'
        ]
      }
    ]
  };
  static final Map<String, dynamic> offerSdpConstraints = {
    'mandatory': {},
    'optional': [
      {'DtlsSrtpKeyAgreement': true},
    ],
  };
}
