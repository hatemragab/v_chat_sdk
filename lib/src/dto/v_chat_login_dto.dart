/// dto login object
class VChatLoginDto {
  final String email;
  late String password;
  late String? fcmToken;
  late String platform;

  VChatLoginDto({
    required this.email,
    this.fcmToken,
  });

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'email': email,
      'password': password,
      'fcmToken': fcmToken,
      'platform': platform,
    } as Map<String, dynamic>;
  }
}
