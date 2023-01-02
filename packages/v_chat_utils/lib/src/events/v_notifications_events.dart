import '../../v_chat_utils.dart';

class VOnNotificationsClickedEvent extends VAppEvent {
  @override
  List<Object?> get props => [];
}

class VOnNewNotifications extends VAppEvent {
  @override
  List<Object?> get props => [];
}

class VOnUpdateNotificationsToken extends VAppEvent {
  final String token;

  const VOnUpdateNotificationsToken(this.token);

  @override
  List<Object?> get props => [token];
}
