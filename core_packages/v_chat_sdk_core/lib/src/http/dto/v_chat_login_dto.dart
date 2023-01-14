class VChatLoginDto {
  final String identifier;
  final String deviceId;
  final String language;
  String? pushKey;
  final String platform;
  final String password;

  VChatLoginDto({
    required this.identifier,
    required this.deviceId,
    required this.language,
    required this.platform,
    required this.password,
    this.pushKey,
  });

  Map<String, dynamic> toMap() {
    return {
      "identifier": identifier,
      "deviceId": deviceId,
      "language": language,
      "pushKey": pushKey,
      "password": password,
      "platform": platform,
    };
  }
}
