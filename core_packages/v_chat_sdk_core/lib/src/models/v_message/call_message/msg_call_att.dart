import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class VMsgCallAtt {
  final VMessageCallStatus callStatus;
  final String? duration;

//<editor-fold desc="Data Methods">

  VMsgCallAtt({
    required this.callStatus,
    required this.duration,
  });


  @override
  String toString() {
    return 'VMsgCallAtt{callStatus: $callStatus, duration: $duration}';
  }

  Map<String, dynamic> toMap() {
    return {
      'callStatus': callStatus.name,
      'duration': duration,
    };
  }

  factory VMsgCallAtt.fromMap(Map<String, dynamic> map) {
    return VMsgCallAtt(
      callStatus: VMessageCallStatus.values.byName(map['callStatus'] as String),
      duration: map['duration'] as String?,
    );
  }

//</editor-fold>
}
