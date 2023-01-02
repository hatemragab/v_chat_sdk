import 'package:v_chat_utils/v_chat_utils.dart';

class VSocketIntervalEvent extends VAppEvent {
  @override
  List<Object?> get props => [DateTime.now().microsecondsSinceEpoch];
}
