import 'package:v_chat_sdk_core/src/models/v_room/single_room/single_ban_model.dart';

class VMySingleRoomInfo {
  String lastSeenAt;
  VSingleBanModel ban;

//<editor-fold desc="Data Methods">

  VMySingleRoomInfo({
    required this.ban,
    required this.lastSeenAt,
  });

  VMySingleRoomInfo.empty()
      : ban = VSingleBanModel.empty(),
        lastSeenAt = DateTime.now().toIso8601String();
  //
  // String get lastSeenTimeAgo => t.format(
  //       DateTime.parse(lastSeenAt).toLocal(),
  //       locale: AppConstants.sdkLanguage,
  //     );

  @override
  String toString() {
    return 'MySingleRoomInfo{ ban: $ban  lastSeenAt: $lastSeenAt,}';
  }

  Map<String, dynamic> toMap() {
    return {
      ...ban.toMap(),
      'lastSeenAt': lastSeenAt,
    };
  }

  factory VMySingleRoomInfo.fromMap(Map<String, dynamic> map) {
    return VMySingleRoomInfo(
      ban: VSingleBanModel.fromMap(map),
      lastSeenAt: map['lastSeenAt'] as String,
    );
  }

//</editor-fold>
}
