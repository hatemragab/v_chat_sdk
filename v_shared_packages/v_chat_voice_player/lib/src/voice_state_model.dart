// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'helpers/play_status.dart';

class VoiceStateModel {
  PlayStatus playStatus;
  PlaySpeed speed;
  bool isSeeking;
  Duration currentDuration;
  Duration maxDuration;

  VoiceStateModel({
    required this.playStatus,
    required this.speed,
    required this.isSeeking,
    required this.currentDuration,
    required this.maxDuration,
  });

  bool get isPlaying => playStatus == PlayStatus.playing;

  bool get isInit => playStatus == PlayStatus.init;

  bool get isDownloading => playStatus == PlayStatus.downloading;

  bool get isDownloadError => playStatus == PlayStatus.downloadError;

  bool get isStop => playStatus == PlayStatus.stop;

  bool get isPause => playStatus == PlayStatus.pause;
}
