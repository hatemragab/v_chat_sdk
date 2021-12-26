class VChatConfig {
  VChatConfig._();

  /// if you found bug contact me whats app +0201012309598
  /// note !!!!!!!!!!!!!!!!!!!!
  /// 10.0.2.2 only works for emulator if u run on real device you should get your ipv4 from terminal
  /// type ipconfig then copy it like this format 192.168.1.*
  static late String serverIp;

  /// serverBaseUrl
  static String serverBaseUrl = "$serverIp/api/v1/";

  /// use One Single
  static const useOneSingle = false;

  /// profile Image BaseUrl
  static String profileImageBaseUrl = "${serverBaseUrl}public/profile/";

  /// messagesMediaBaseUrl
  static String messagesMediaBaseUrl = "${serverBaseUrl}public/messages/";

  /// maxMessageFileSize
  static late int maxMessageFileSize; // = 50 mb;

  /// packageVersion
  static String packageVersion = "1.0.0";

  /// packageBuild
  static int packageBuild = 1;

  /// databaseVersion
  static int databaseVersion = 1;

  /// backendVersion
  static String backendVersion = "1.0.0";

  /// backendBuild
  static int backendBuild = 1;
}
