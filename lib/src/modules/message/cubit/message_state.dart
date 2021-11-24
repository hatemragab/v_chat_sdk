part of 'message_cubit.dart';

@immutable
abstract class MessageState {}

class MessageInitial extends MessageState {}

class MessageLoaded extends MessageState {
  final List<VChatMessage> messages;

  MessageLoaded(this.messages);
}
