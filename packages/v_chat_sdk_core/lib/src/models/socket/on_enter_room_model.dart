import '../../../v_chat_sdk_core.dart';

class OnEnterRoomModel {
  final String roomId;
  final String userId;
  final String date;

  const OnEnterRoomModel({
    required this.roomId,
    required this.userId,
    required this.date,
  });

  DateTime get localDate => DateTime.parse(date).toLocal();

  @override
  String toString() {
    return 'OnEnterRoomModel{roomId: $roomId, userId: $userId, date: $date}';
  }

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'userId': userId,
      'date': date,
    };
  }

  bool get isMe => AppConstants.myId == userId;

  factory OnEnterRoomModel.fromMap(Map<String, dynamic> map) {
    return OnEnterRoomModel(
      roomId: map['roomId'] as String,
      userId: map['userId'] as String,
      date: map['date'] as String,
    );
  }
}
