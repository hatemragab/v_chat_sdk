import '../../v_chat_utils.dart';

class VOnNotificationsClickedEvent extends VAppEvent {
  final Map<String, dynamic> message;

  const VOnNotificationsClickedEvent(this.message);

  @override
  List<Object?> get props => [message];
}

class VOnNewNotifications extends VAppEvent {
  final Map<String, dynamic> message;

  const VOnNewNotifications(this.message);

  @override
  List<Object?> get props => [];
}

class VOnUpdateNotificationsToken extends VAppEvent {
  final String token;

  const VOnUpdateNotificationsToken(this.token);

  @override
  List<Object?> get props => [token];
}
