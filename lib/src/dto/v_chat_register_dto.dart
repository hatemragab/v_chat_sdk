import 'dart:io';

/// dto register object
class VChatRegisterDto {
  final String name;
  final String email;
  final String password;
  final File? userImage;
  late String? fcmToken;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  VChatRegisterDto({
    required this.name,
    required this.password,
    required this.email,
    required this.userImage,
    this.fcmToken,
  });

  VChatRegisterDto copyWith({
    String? name,
    String? email,
    String? password,
    File? userImage,
    String? fcmToken,
  }) {
    return VChatRegisterDto(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      userImage: userImage ?? this.userImage,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'name': name,
      'email': email,
      'password': password,
      'fcmToken': fcmToken,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
