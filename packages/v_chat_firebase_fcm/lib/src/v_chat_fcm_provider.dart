import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class VChatFcmProver extends VChatPushProviderBase {
  @override
  Future<void> deleteToken() async {
    return;
  }

  @override
  Future<String?> getToken() async {
    try {
      //todo add vapidKey if web
      return await FirebaseMessaging.instance.getToken();
    } catch (err) {
      //todo set logger here
      return null;
    }
  }

  @override
  Future<bool> init() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
      //todo set logger here app already init
      return true;
    }
    //todo set logger here app has been init
    return false;
  }
}
