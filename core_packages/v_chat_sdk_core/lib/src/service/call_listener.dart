import 'package:logging/logging.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../v_chat_sdk_core.dart';

class CallListener {
  final VNativeApi nativeApi;
  final VChatConfig vChatConfig;
  final VNavigator vNavigator;

  final _log = Logger('CallListener');

  CallListener(
    this.nativeApi,
    this.vChatConfig,
    this.vNavigator,
  ) {
    _init();
  }

  Future<void> _init() async {
    await nativeApi.remote.socketIo.socketCompleter.future;
    VEventBusSingleton.vEventBus.on<VCallEvents>().listen((event) {
      print(event);
      if (event is VOnNewCallEvent) {
        return;
      }
      if (event is VCallTimeoutEvent) {
        return;
      }
      if (event is VCallAcceptedEvent) {
        return;
      }
      if (event is VCallEndedEvent) {
        return;
      }
    });
  }
}
