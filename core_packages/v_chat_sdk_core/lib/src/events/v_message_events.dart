// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

abstract class VMessageEvents extends VAppEvent {
  final String roomId;
  final String localId;

  const VMessageEvents({
    required this.roomId,
    required this.localId,
  });

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

class VUpdateMessageEvent extends VMessageEvents {
  final VBaseMessage messageModel;

  const VUpdateMessageEvent({
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
  final VMessageType messageType;

  const VUpdateMessageTypeEvent({
    required super.roomId,
    required super.localId,
    required this.messageType,
  });

  @override
  List<Object?> get props => [super.props, messageType];
}

class VUpdateMessageStatusEvent extends VMessageEvents {
  final VMessageEmitStatus emitState;

  const VUpdateMessageStatusEvent({
    required super.roomId,
    required super.localId,
    required this.emitState,
  });

  @override
  List<Object?> get props => [super.props, emitState];
}

class VUpdateMessageSeenEvent extends VMessageEvents {
  final VSocketOnRoomSeenModel model;

  const VUpdateMessageSeenEvent({
    required super.roomId,
    required super.localId,
    required this.model,
  });

  @override
  List<Object?> get props => [super.props, model];
}

class VUpdateMessageDeliverEvent extends VMessageEvents {
  final VSocketOnDeliverMessagesModel model;

  const VUpdateMessageDeliverEvent({
    required super.roomId,
    required super.localId,
    required this.model,
  });

  @override
  List<Object?> get props => [super.props, model];
}
