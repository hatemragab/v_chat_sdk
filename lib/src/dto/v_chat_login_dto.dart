class VChatLoginDto {
  final String email;
  final String password;
  late String? fcmToken;

   VChatLoginDto({
    required this.email,
    required this.password,
    this.fcmToken,
  });

  factory VChatLoginDto.fromMap(Map<String, dynamic> map) {
    return VChatLoginDto(
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'email': email,
      'password': password,
      'fcmToken': fcmToken,
    } as Map<String, dynamic>;
  }
}
