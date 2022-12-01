import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:v_chat_sdk_core/src/models/v_message/voice_message/voice_stream.dart';
import 'package:v_chat_voice_player/v_chat_voice_player.dart';

import '../../../../v_chat_sdk_core.dart';
import '../../../local_db/tables/message_table.dart';
import '../base_message/base_message.dart';
import '../core/message_voice_data.dart';
import 'i_voice_message.dart';

class VVoiceMessage extends VBaseMessage implements IVoiceMessageController {
  late final VoiceMessageController _controller;
  final VMessageVoiceData fileSource;

  VVoiceMessage({
    required super.id,
    required super.senderId,
    required super.messageStatus,
    required super.senderName,
    required super.senderImageThumb,
    required super.platform,
    required super.roomId,
    required super.content,
    required super.messageType,
    required super.localId,
    required super.createdAt,
    required super.updatedAt,
    required super.replyTo,
    required super.seenAt,
    required super.deliveredAt,
    required super.forwardId,
    required super.deletedAt,
    required super.parentBroadcastId,
    required super.isStared,
    required this.fileSource,
  }) {
    _controller = _getVoiceController();
  }

  VVoiceMessage.fromRemoteMap(super.map)
      : fileSource = VMessageVoiceData.fromMap(
          map['msgAtt'] as Map<String, dynamic>,
        ),
        super.fromRemoteMap() {
    _controller = _getVoiceController();
  }

  VVoiceMessage.fromLocalMap(super.map)
      : fileSource = VMessageVoiceData.fromMap(
          jsonDecode(map[MessageTable.columnAttachment] as String)
              as Map<String, dynamic>,
        ),
        super.fromLocalMap() {
    _controller = _getVoiceController();
  }

  // @override
  // Map<String, dynamic> toRemoteMap() {
  //   return {...super.toRemoteMap(), 'msgAtt': voiceUrlAttachment.toMap()};
  // }

  @override
  Map<String, dynamic> toLocalMap() {
    return {
      ...super.toLocalMap(),
      MessageTable.columnAttachment: jsonEncode(fileSource.toMap())
    };
  }

  @override
  List<PartValue> toListOfPartValue() {
    return [
      ...super.toListOfPartValue(),
      PartValue(
        'attachment',
        jsonEncode(fileSource.toMap()),
      ),
    ];
  }

  VVoiceMessage.buildMessage({
    required super.roomId,
    required this.fileSource,
    super.forwardId,
    super.broadcastId,
    super.replyTo,
  }) : super.buildMessage(
          content: AppConstants.thisContentIsVoice,
          messageType: MessageType.voice,
        ) {
    initVoiceController();
  }

  void initVoiceController() {
    _controller = _getVoiceController();
  }

  VoiceMessageController _getVoiceController() {
    return VoiceMessageController(
      id: id,
      audioSrc: _getAudioSrc(),
      maxDuration: fileSource.durationObj,
      onComplete: (id) {
        voiceStreamEmitter.sink.add(VoiceComplete(id));
      },
      onPause: (id) {},
      onPlaying: (id) {
        voiceStreamEmitter.sink.add(VoiceOnPlay(id));
      },
    );
  }

  AudioSrc _getAudioSrc() {
    if (fileSource.fileSource.bytes != null) {
      return BytesSrc(fileSource.fileSource.bytes!);
    }
    if (fileSource.fileSource.filePath != null) {
      return FileSrc(fileSource.fileSource.filePath!);
    }
    return UrlSrc(fileSource.fileSource.url!.fullUrl);
  }

  @override
  VoiceMessageController getVoiceController() => _controller;
}
