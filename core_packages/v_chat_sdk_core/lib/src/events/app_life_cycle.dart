import 'package:v_chat_utils/v_chat_utils.dart';

class VAppLifeCycle extends VAppEvent {
  final bool isGoBackground;

  const VAppLifeCycle({
    required this.isGoBackground,
  });

  @override
  List<Object?> get props => [isGoBackground];
}
