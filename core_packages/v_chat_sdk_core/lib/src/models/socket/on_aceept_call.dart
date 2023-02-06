import 'dart:convert';

class VOnAcceptCall {
  final String roomId;
  final String meetId;
  final Map<String, dynamic> peerAnswer;

  const VOnAcceptCall({
    required this.roomId,
    required this.meetId,
    required this.peerAnswer,
  });

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'meetId': meetId,
      'peerAnswer': peerAnswer,
    };
  }

  factory VOnAcceptCall.fromMap(Map<String, dynamic> map) {
    return VOnAcceptCall(
      roomId: map['roomId'] as String,
      meetId: map['meetId'] as String,
      peerAnswer:
          jsonDecode(map['peerAnswer'] as String) as Map<String, dynamic>,
    );
  }
}
