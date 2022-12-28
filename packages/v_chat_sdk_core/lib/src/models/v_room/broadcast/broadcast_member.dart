//
// class BroadcastMember {
//   final String id;
//   final BaseUser peerUser;
//   final String userId;
//   final DateTime joinedAt;
//
// //<editor-fold desc="Data Methods">
//
//   const BroadcastMember({
//     required this.id,
//     required this.peerUser,
//     required this.userId,
//     required this.joinedAt,
//   });
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       (other is BroadcastMember &&
//           runtimeType == other.runtimeType &&
//           id == other.id &&
//           joinedAt == other.joinedAt);
//
//   String get userImageS3 => peerUser.userImages.chatImageS3;
//
//   bool get isMe => userId == AppAuth.myId;
//
//   @override
//   String toString() {
//     return 'GroupMember{ id: $id, userRole: , joinedAt: $joinedAt,}';
//   }
//
//   String get createdAtStr => t.format(DateTime.parse(joinedAt).toLocal());
//
//   factory BroadcastMember.fromMap(Map<String, dynamic> map) {
//     return BroadcastMember(
//       id: map['_id'] as String,
//       peerUser: BaseUser.fromMap(map['userData'] as Map<String, dynamic>),
//       userId: map['uId'] as String,
//       joinedAt: map['createdAt'] as String,
//     );
//   }
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
// //</editor-fold>
// }
