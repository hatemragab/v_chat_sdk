import '../../../../v_chat_sdk_core.dart';
import '../../../utils/api_constants.dart';

class VMsgCallAtt {
  final CallStatus status;
  final int? duration;
  final String callerId;

//<editor-fold desc="Data Methods">

  VMsgCallAtt({
    required this.status,
    required this.duration,
    required this.callerId,
  });

  bool get isMe => AppConstants.myId == callerId;

  Map<String, dynamic> toMap() {
    return {
      'status': status.name,
      'duration': duration,
      'callerId': callerId,
    };
  }

  factory VMsgCallAtt.fromMap(Map<String, dynamic> map) {
    return VMsgCallAtt(
      status: CallStatus.values.byName(map['status'] as String),
      duration: map['duration'] as int?,
      callerId: map['callerId'] as String,
    );
  }

//</editor-fold>
}
