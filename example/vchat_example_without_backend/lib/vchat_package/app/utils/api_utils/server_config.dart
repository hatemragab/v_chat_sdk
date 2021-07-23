import '../../../vchat_constants.dart';

class ServerConfig {
  // if you found bug contact me whats app +0201012309598

  static final appVersion = '3.0.0';
  static final appName = 'vChatProStable';

  ///note !!!!!!!!!!!!!!!!!!!!
  //10.0.2.2 only works for emulator if u run on real device you should get your ipv4 from terminal
  // type ipconfig then copy it like this format 192.168.1.*

  //192.168.1.3
  static const String IP = KServerIp;
  static const SERVER_IP = "http://$IP/api/v1/";

  static const USE_ONE_SINGLE = false;

  //http://localhost:3000/api/v1/public/images/messages/image_picker6911144535190976387.jpg
  static const MESSAGE_IMAGES = 'http://$IP/api/v1/public/images/messages/';
  static const MESSAGE_PROFILE_IMAGES =
      'http://$IP/api/v1/public/images/profile_images/';
  static const SOCKET_IP = 'http://$IP';

  static const PROFILE_IMAGES_BASE_URL = "${SERVER_IP}public/profile/";
  static const POSTS_BASE_URL = "${SERVER_IP}public/posts/";
  static const MESSAGES_BASE_URL = "${SERVER_IP}public/messages/";

  static const IS_IN_DEVELOPMENT = true;


  static const MAX_MESSAGE_FILE_SIZE = 50 * 1000 * 1000; // = 50 mb
}
