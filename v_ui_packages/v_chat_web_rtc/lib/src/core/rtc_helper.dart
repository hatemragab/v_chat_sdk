// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

abstract class RtcHelper {
  ///get your credential from here
  //https://www.metered.ca/tools/openrelay
  static final _u = "0f81b1074c38cbf36da4f3d8";
  static final _p = "AOThSbLAsf0fJw0w";
  static Map<String, dynamic> iceServers = {
    "sdpSemantics": "plan-b",
    'iceServers': [
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
          'stun:stun01.sipphone.com',
          'stun:stun.schlund.de',
          'stun:stun.voipstunt.com',
          'stun:stun.xten.com',
        ]
      },
      {
        "urls": "turn:relay.metered.ca:80",
        "username": _u,
        "credential": _p,
      },
      {
        "urls": "turn:relay.metered.ca:443",
        "username": _u,
        "credential": _p,
      },
      {
        "urls": "turn:relay.metered.ca:443?transport=tcp",
        "username": _u,
        "credential": _p,
      },
    ],
    'mandatory': {},
    'optional': [
      {'DtlsSrtpKeyAgreement': true},
    ],
  };
  static final Map<String, dynamic> offerSdpConstraints = {
    'mandatory': {},
    'optional': [
      {'DtlsSrtpKeyAgreement': true},
    ],
  };
}
