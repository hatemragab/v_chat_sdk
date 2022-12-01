import 'package:event_bus_plus/res/app_event.dart';

import '../../v_chat_sdk_core.dart';
import '../models/socket/on_deliver_room_messages_model.dart';
import '../models/socket/on_enter_room_model.dart';

abstract class VMessageEvents extends AppEvent {
  final String roomId;
  final String localId;

  const VMessageEvents({required this.roomId, required this.localId});

  @override
  List<Object?> get props => [roomId, localId];
}

class VInsertMessageEvent extends VMessageEvents {
  final VBaseMessage messageModel;

  const VInsertMessageEvent({
    required super.roomId,
    required super.localId,
    required this.messageModel,
  });
}

class VDeleteMessageEvent extends VMessageEvents {
  final VBaseMessage? upMessage;

  const VDeleteMessageEvent({
    required super.roomId,
    required super.localId,
    this.upMessage,
  });

  @override
  List<Object?> get props => [super.props, upMessage];
}

class VUpdateMessageTypeEvent extends VMessageEvents {
  final MessageType messageType;

  const VUpdateMessageTypeEvent({
    required super.roomId,
    required super.localId,
    required this.messageType,
  });

  @override
  List<Object?> get props => [super.props, messageType];
}

class VUpdateMessageStatusEvent extends VMessageEvents {
  final MessageSendingStatusEnum messageSendingStatusEnum;

  const VUpdateMessageStatusEvent({
    required super.roomId,
    required super.localId,
    required this.messageSendingStatusEnum,
  });

  @override
  List<Object?> get props => [super.props, messageSendingStatusEnum];
}

class VUpdateMessageSeenEvent extends VMessageEvents {
  final OnEnterRoomModel onEnterRoomModel;

  const VUpdateMessageSeenEvent({
    required super.roomId,
    required super.localId,
    required this.onEnterRoomModel,
  });

  @override
  List<Object?> get props => [super.props, onEnterRoomModel];
}

class VUpdateMessageDeliverEvent extends VMessageEvents {
  final OnDeliverRoomMessagesModel deliverRoomMessagesModel;

  const VUpdateMessageDeliverEvent({
    required super.roomId,
    required super.localId,
    required this.deliverRoomMessagesModel,
  });

  @override
  List<Object?> get props => [super.props, deliverRoomMessagesModel];
}
