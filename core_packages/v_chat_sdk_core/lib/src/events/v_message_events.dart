// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

/// Abstract base class for message events.
/// All message event classes should extend this class.
abstract class VMessageEvents extends VAppEvent {
  final String roomId; // The ID of the room associated with the event.
  final String localId; // The local ID associated with the event.

  const VMessageEvents({
    required this.roomId,
    required this.localId,
  });

  @override
  List<Object?> get props => [roomId, localId];
}

/// Event for inserting a new message.
class VInsertMessageEvent extends VMessageEvents {
  final VBaseMessage messageModel; // The message to insert.

  const VInsertMessageEvent({
    required super.roomId,
    required super.localId,
    required this.messageModel,
  });
}

/// Event for updating a message.
class VUpdateMessageEvent extends VMessageEvents {
  final VBaseMessage messageModel; // The message to update.

  const VUpdateMessageEvent({
    required super.roomId,
    required super.localId,
    required this.messageModel,
  });
}

/// Event for deleting a message from me.
class VDeleteMessageEvent extends VMessageEvents {
  final VBaseMessage? upMessage; // The message to delete. Can be null.

  const VDeleteMessageEvent({
    required super.roomId,
    required super.localId,
    this.upMessage,
  });

  @override
  List<Object?> get props => [super.props, upMessage];
}

/// Event for deleting a message from all.
class VUpdateMessageAllDeletedEvent extends VMessageEvents {
  final VBaseMessage message; // The message to update.

  const VUpdateMessageAllDeletedEvent({
    required super.roomId,
    required super.localId,
    required this.message,
  });

  @override
  List<Object?> get props => [super.props, message];
}

/// Event for updating the status [seen,deliver,send,error,pending] of a message.
class VUpdateMessageStatusEvent extends VMessageEvents {
  final VMessageEmitStatus emitState; // The new status of the message.

  const VUpdateMessageStatusEvent({
    required super.roomId,
    required super.localId,
    required this.emitState,
  });

  @override
  List<Object?> get props => [super.props, emitState];
}

/// Event for updating the 'seen' status of all room messages.
class VUpdateMessageSeenEvent extends VMessageEvents {
  final VSocketOnRoomSeenModel model; // The model to update the 'seen' status.

  const VUpdateMessageSeenEvent({
    required super.roomId,
    required super.localId,
    required this.model,
  });

  @override
  List<Object?> get props => [super.props, model];
}

/// Event for updating the delivery status of all room messages.
class VUpdateMessageDeliverEvent extends VMessageEvents {
  final VSocketOnDeliverMessagesModel
      model; // The model to update the delivery status.

  const VUpdateMessageDeliverEvent({
    required super.roomId,
    required super.localId,
    required this.model,
  });

  @override
  List<Object?> get props => [super.props, model];
}
