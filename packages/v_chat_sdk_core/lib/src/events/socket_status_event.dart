import 'package:v_chat_utils/v_chat_utils.dart';

class VSocketStatusEvent extends VAppEvent {
  final bool isConnected;

  const VSocketStatusEvent(this.isConnected);

  @override
  List<Object?> get props => [isConnected];
}
