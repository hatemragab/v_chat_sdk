import 'dart:io';

/// dto register object
class VChatRegisterDto {
  final String name;
  final String email;
  late String password;
  final File? userImage;
  late String? fcmToken;

//<editor-fold desc="Data Methods" defaultstate="collapsed">
  VChatRegisterDto({
    required this.name,
    required this.email,
    required this.userImage,
  });

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
