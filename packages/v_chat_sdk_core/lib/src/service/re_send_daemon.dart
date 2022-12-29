import '../../v_chat_sdk_core.dart';
import '../utils/event_bus.dart';

///this class will ensure to resend all failed messages
class ReSendDaemon with VSocketIntervalStream {
  final _messagesRef = VChatController.I.nativeApi.local.message;

  ReSendDaemon() {
    initSocketIntervalStream(
      EventBusSingleton.instance.vChatEvents.on<VSocketIntervalEvent>(),
    );
  }

  void start() {
    onIntervalFire();
  }

  @override
  void onIntervalFire() async {
    final unSendMessages = await _messagesRef.getUnSendMessages();
    for (final e in unSendMessages) {
      MessageUploaderQueue.instance.addToQueue(
        await MessageFactory.createUploadMessage(e),
      );
    }
  }

  void close() {
    closeSocketIntervalStream();
  }
}
