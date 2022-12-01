import '../../../../v_chat_sdk_core.dart';

class MsgInfoAtt {
  final MessageInfoType action;
  final String targetName;
  final String targetId;
  final String adminName;

//<editor-fold desc="Data Methods">

  MsgInfoAtt({
    required this.action,
    required this.targetName,
    required this.targetId,
    required this.adminName,
  });

  @override
  String toString() {
    return 'MsgInfoAtt{ action: $action, targetName: $targetName, adminName: $adminName,}';
  }

  bool get isMe => AppConstants.myId == targetId;

  bool get isDark {
    if (action == MessageInfoType.kick) {
      return true;
    }
    return false;
  }

  Map<String, dynamic> toMap() {
    return {
      'action': action.name,
      'targetName': targetName,
      'adminName': adminName,
      'targetId': targetId,
    };
  }

  factory MsgInfoAtt.fromMap(Map<String, dynamic> map) {
    return MsgInfoAtt(
      action: MessageInfoType.values.byName(map['action'] as String),
      targetName: map['targetName'] as String,
      adminName: map['adminName'] as String,
      targetId: map['targetId'] as String,
    );
  }

//</editor-fold>
}
