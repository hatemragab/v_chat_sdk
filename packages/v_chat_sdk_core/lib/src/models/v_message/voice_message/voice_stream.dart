import 'dart:async';

final voiceStreamEmitter = StreamController<VoiceStream>.broadcast();
final voiceStream = voiceStreamEmitter.stream;

abstract class VoiceStream {}

class VoiceOnPlay extends VoiceStream {
  final String messageId;

  VoiceOnPlay(this.messageId);
}

class VoiceComplete extends VoiceStream {
  final String messageId;

  VoiceComplete(this.messageId);
}
