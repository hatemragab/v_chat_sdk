import 'package:flutter_test/flutter_test.dart';
import 'package:v_chat_sdk/src/vchat_controller.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';

import 'audio_player.dart';

void main() async {
  test('if audio player works', () {
    final a = TestAudioPlayer();
    a.urlPlay();
  });


  // //first  init chat_sdk
  // await VChatController.instance.init(
  //   baseUrl: backendBaseUrl,
  //   appName: appName,
  //   isUseFirebase: isUseFirebase,
  //   lightTheme: lightTheme,
  //   darkTheme: darkTheme,
  //   enableLogger: enableLogger,
  //   navKey: navKey,
  // );
  //
  // //login to get your access token
  // //Email is unique id between your system and my system it may be phone number or any unique String
  // await VChatController.instance
  //     .login(VChatLoginDto(email: email, password: password));
  //
  // //login to get your access token
  // //Email is unique id between your system and my system it may be phone number or any unique String
  // await VChatController.instance.register(VChatRegisterDto(
  //   name: name,
  //   password: password,
  //   email: email,
  //   userImage: null,
  // ));
  //
  // //connect to socket and listen for notifications
  // VChatController.instance.bindChatControllers();
  //
  // //create single chat if there is no chats this will show alert dialog else will open the message page
  // VChatController.instance.createSingleChat(peerEmail: peerEmail, ctx: ctx);
  //
  // //use this Widget to show all user rooms
  // const VChatRoomsView();
  //
  // //delete local user rooms and stop notifications
  // await VChatController.instance.logOut();


}
