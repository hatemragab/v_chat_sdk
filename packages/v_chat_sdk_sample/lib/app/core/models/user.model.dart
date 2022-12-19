import 'package:v_chat_utils/v_chat_utils.dart';

class UserModel {
  final String uid;
  String userName;
  final DateTime createdAt;
  String imageUrl;

//<editor-fold desc="Data Methods">

  UserModel({
    required this.uid,
    required this.userName,
    required this.createdAt,
    required this.imageUrl,
  });

  VPlatformFileSource get imgAsPlatformSource => VPlatformFileSource.fromUrl(
        fileSize: 0,
        url: imageUrl,
        isFullUrl: true,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserModel &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          userName == other.userName &&
          createdAt == other.createdAt &&
          imageUrl == other.imageUrl);

  @override
  int get hashCode =>
      uid.hashCode ^ userName.hashCode ^ createdAt.hashCode ^ imageUrl.hashCode;

  @override
  String toString() {
    return 'UserModel{ uid: $uid, userName: $userName, createdAt: $createdAt, imageUrl: $imageUrl,}';
  }

  UserModel copyWith({
    String? uid,
    String? userName,
    DateTime? createdAt,
    String? imageUrl,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      userName: userName ?? this.userName,
      createdAt: createdAt ?? this.createdAt,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'userName': userName,
      'createdAt': createdAt.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      userName: map['userName'] as String,
      createdAt: DateTime.parse(map['createdAt']),
      imageUrl: map['imageUrl'] as String,
    );
  }

//</editor-fold>
}
