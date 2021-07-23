import 'dart:io';

class VchatRegisterDto {
  final String name;
  final String email;
  final String password;
  final File? userImage;
  late String? fcmToken;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  VchatRegisterDto({
    required this.name,
    required this.password,
    required this.email,
    required this.userImage,
    this.fcmToken,
  });

  VchatRegisterDto copyWith({
    String? name,
    String? email,
    String? password,
    File? userImage,
    String? fcmToken,
  }) {
    return   VchatRegisterDto(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      userImage: userImage ?? this.userImage,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  Map<String, dynamic> toMap(  String imageThumb) {
    // ignore: unnecessary_cast
    return {
      'name': name,
      'imageThumb': imageThumb,
      'email': email,
      'password': password,
      'fcmToken': fcmToken,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
