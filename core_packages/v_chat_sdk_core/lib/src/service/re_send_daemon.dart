import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

///this class will ensure to resend all failed messages
class ReSendDaemon with VSocketIntervalStream {
  final _messagesRef = VChatController.I.nativeApi.local.message;

  ReSendDaemon() {
    initSocketIntervalStream(
      VEventBusSingleton.vEventBus.on<VSocketIntervalEvent>(),
    );
  }

  void start() {
    onIntervalFire();
  }

  @override
  Future<void> onIntervalFire() async {
    final unSendMessages = await _messagesRef.getUnSendMessages();
    for (final e in unSendMessages) {
      if (e is VTextMessage) {
        await MessageUploaderQueue.instance.addToQueue(
          await MessageFactory.createUploadMessage(e),
        );
      } else {
        MessageUploaderQueue.instance.addToQueue(
          await MessageFactory.createUploadMessage(e),
        );
      }
    }
  }

  void close() {
    closeSocketIntervalStream();
  }
}
