import 'package:v_chat_sdk_core/src/models/v_room/single_room/single_ban_model.dart';

class MySingleRoomInfo {
  String lastSeenAt;
  SingleBanModel ban;

//<editor-fold desc="Data Methods">

  MySingleRoomInfo({
    required this.ban,
    required this.lastSeenAt,
  });

  MySingleRoomInfo.empty()
      : ban = SingleBanModel.empty(),
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

  factory MySingleRoomInfo.fromMap(Map<String, dynamic> map) {
    return MySingleRoomInfo(
      ban: SingleBanModel.fromMap(map),
      lastSeenAt: map['lastSeenAt'] as String,
    );
  }

//</editor-fold>
}
