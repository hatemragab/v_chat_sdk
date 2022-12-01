import '../../../../v_chat_sdk_core.dart';

class SingleBanModel {
  final bool banned;
  final String? bannerId;

  const SingleBanModel({
    required this.banned,
    required this.bannerId,
  });

  SingleBanModel.empty()
      : banned = false,
        bannerId = null;

  bool get isMyBanner => AppConstants.myId == bannerId;

  @override
  String toString() {
    return 'MySingleRoomInfo{ banned: $banned, bannerId: $bannerId }';
  }

  Map<String, dynamic> toMap() {
    return {
      'banned': banned,
      'bannerId': bannerId,
    };
  }

  factory SingleBanModel.fromMap(Map<String, dynamic> map) {
    return SingleBanModel(
      banned: map['banned'] as bool,
      bannerId: map['bannerId'] as String?,
    );
  }
}
