import '../../../v_chat_sdk_core.dart';

class OnDeliverRoomMessagesModel {
  final String roomId;
  final String userId;
  final String date;

  const OnDeliverRoomMessagesModel({
    required this.roomId,
    required this.userId,
    required this.date,
  });

  bool get isMe => AppConstants.myId == userId;

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

  factory OnDeliverRoomMessagesModel.fromMap(Map<String, dynamic> map) {
    return OnDeliverRoomMessagesModel(
      roomId: map['roomId'] as String,
      userId: map['userId'] as String,
      date: map['date'] as String,
    );
  }
}
