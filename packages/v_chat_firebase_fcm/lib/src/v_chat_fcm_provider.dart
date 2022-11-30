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
    return FirebaseMessaging.instance.getToken();
  }

  @override
  Future<bool> init() async {
    ///this function will throw if the device not support google play service!
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
      return true;
    } else {
      return false;
    }
  }

  @override
  VChatPushService serviceName() {
    return VChatPushService.firebase;
  }
}
