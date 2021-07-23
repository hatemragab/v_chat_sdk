import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

@immutable
class VChatUser {
  final int id;
  final String name;
  final String imageThumb;
  final String email;
  final String accessToken;
  final RxBool isSelected = false.obs;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  VChatUser({
    required this.id,
    required this.name,
    required this.imageThumb,
    required this.email,
    required this.accessToken,
  });

  @override
  String toString() {
    return 'User{id: $id, name: $name, imageThumb: $imageThumb, email: $email, accessToken: $accessToken, isSelected: $isSelected}';
  }

  factory VChatUser.fromMap(Map<String, dynamic> map) {
    return VChatUser(
      id: map['_id'] as int,
      name: map['name'] as String,
      imageThumb: map['imageThumb'] as String,
      email: map['email'] as String,
      accessToken: map['accessToken'] as String,
    );
  }

  factory VChatUser.fromMapAllUsersPage(Map<String, dynamic> map) {
    return VChatUser(
      id: map['_id'] as int,
      name: map['name'] as String,
      imageThumb: map['imageThumb'] as String,
      email: map['email'] as String,
      accessToken: "",
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      '_id': id,
      'name': name,
      'imageThumb': imageThumb,
      'email': email,
      'accessToken': accessToken,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
