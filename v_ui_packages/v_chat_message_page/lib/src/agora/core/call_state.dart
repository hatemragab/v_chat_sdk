import '../../../v_chat_message_page.dart';

class CallState {
  CallStatus status = CallStatus.connecting;
  String? meetId;
  bool isMicEnabled = true;
  bool isSpeakerEnabled = false;
  bool isVideoEnabled = false;
}
