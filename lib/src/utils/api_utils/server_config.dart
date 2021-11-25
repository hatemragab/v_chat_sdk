import '../../services/v_chat_app_service.dart';

class ServerConfig {
  ServerConfig._();
  /// if you found bug contact me whats app +0201012309598
  /// note !!!!!!!!!!!!!!!!!!!!
  /// 10.0.2.2 only works for emulator if u run on real device you should get your ipv4 from terminal
  /// type ipconfig then copy it like this format 192.168.1.*

  //192.168.1.3
  static late String serverIp ;
  static String serverBaseUrl = "$serverIp/api/v1/";

  static const useOneSingle = false;

  //http://localhost:3000/api/v1/public/images/messages/image_picker6911144535190976387.jpg
  static String messageImages =
      'http://$serverIp/api/v1/public/images/messages/';


  static String profileImageBaseUrl = "${serverBaseUrl}public/profile/";

  static String messagesMediaBaseUrl = "${serverBaseUrl}public/messages/";

  static  late int maxMessageFileSize ; // = 50 mb;
}
