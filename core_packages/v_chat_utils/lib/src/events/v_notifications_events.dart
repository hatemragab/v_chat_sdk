import '../../v_chat_utils.dart';

class VOnNotificationsClickedEvent extends VAppEvent {
  final Object message;
  final Object room;

  const VOnNotificationsClickedEvent(this.message, this.room);

  @override
  List<Object?> get props => [message];
}

class VOnNewNotifications extends VAppEvent {
  final Object message;
  final Object? room;
  const VOnNewNotifications(this.message, this.room);

  @override
  List<Object?> get props => [];
}

class VOnUpdateNotificationsToken extends VAppEvent {
  final String token;

  const VOnUpdateNotificationsToken(this.token);

  @override
  List<Object?> get props => [token];
}
