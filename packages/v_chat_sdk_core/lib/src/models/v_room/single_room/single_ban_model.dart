import '../../../utils/api_constants.dart';

class VSingleBanModel {
  final bool banned;
  final String? bannerId;

  const VSingleBanModel({
    required this.banned,
    required this.bannerId,
  });

  VSingleBanModel.empty()
      : banned = false,
        bannerId = null;

  bool get isMyBanner => VAppConstants.myId == bannerId;

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

  factory VSingleBanModel.fromMap(Map<String, dynamic> map) {
    return VSingleBanModel(
      banned: map['banned'] as bool,
      bannerId: map['bannerId'] as String?,
    );
  }
}
