import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart' as cache;
import 'package:just_audio/just_audio.dart' as jsAudio;
import 'package:just_audio/just_audio.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import 'helpers/bytes_custom_source.dart';
import 'helpers/play_status.dart';
import 'helpers/utils.dart';

// abstract class AudioSrc {
// }
//
// class FileSrc extends AudioSrc {
//   final String path;
//
//   FileSrc(this.path);
// }
//
// class UrlSrc extends AudioSrc {
//   final String url;
//
//   UrlSrc(this.url);
// }
//
// class BytesSrc extends AudioSrc {
//   final List<int> bytes;
//
//   BytesSrc(this.bytes);
// }

class VoiceMessageController extends MyTicker {
  final VPlatformFileSource audioSrc;
  late Duration maxDuration;
  Duration currentDuration = Duration.zero;
  final Function(String id) onComplete;
  final Function(String id) onPlaying;
  final Function(String id) onPause;
  final double noiseWidth = 50.5.w();
  final String id;
  late AnimationController animController;
  final AudioPlayer _player = AudioPlayer();

  PlayStatus playStatus = PlayStatus.init;
  PlaySpeed speed = PlaySpeed.x1;
  ValueNotifier updater = ValueNotifier(null);
  final randoms = <double>[];
  StreamSubscription? positionStream;
  StreamSubscription? playerStateStream;

  bool isSeeking = false;

  ///state
  bool get isPlaying => playStatus == PlayStatus.playing;

  bool get isInit => playStatus == PlayStatus.init;

  bool get isDownloading => playStatus == PlayStatus.downloading;

  bool get isDownloadError => playStatus == PlayStatus.downloadError;

  bool get isStop => playStatus == PlayStatus.stop;

  double get currentMillSeconds {
    final c = currentDuration.inMilliseconds.toDouble();
    if (c >= maxMillSeconds) {
      return maxMillSeconds;
    }
    return c;
  }

  bool get isPause => playStatus == PlayStatus.pause;

  double get maxMillSeconds => maxDuration.inMilliseconds.toDouble();

  VoiceMessageController({
    required this.id,
    required this.audioSrc,
    this.maxDuration = Duration.zero,
    required this.onComplete,
    required this.onPause,
    required this.onPlaying,
  }) {
    _setRandoms();
    animController = AnimationController(
      vsync: this,
      upperBound: noiseWidth,
      duration: maxDuration,
    );
    _listenToRemindingTime();
    _listenToPlayerState();
  }

  Future initAndPlay() async {
    playStatus = PlayStatus.downloading;
    _updateUi();
    try {
      if (kIsWeb) {
        await setMaxDurationForJs();
        await startPlayingForJs();
      } else {
        final path = await _getFileFromCache();
        await setMaxDurationForIo(path);
        await startPlayingForIo(path);
      }
      onPlaying(id);
    } catch (err) {
      playStatus = PlayStatus.downloadError;
      _updateUi();
      rethrow;
    }
  }

  bool get isFile => audioSrc.isFromPath;

  bool get isBytes => audioSrc.isFromBytes;

  bool get isUrl => audioSrc.isFromUrl;

  Future<String> _getFileFromCache() async {
    if (isFile) {
      return audioSrc.filePath!;
    }
    if (isBytes) {
      throw "isBytes should not call here !";
    }
    final p = await cache.DefaultCacheManager().getSingleFile(
      audioSrc.url!.fullUrl,
    );
    return p.path;
  }

  void _listenToRemindingTime() {
    positionStream = _player.positionStream.listen((Duration p) async {
      currentDuration = p;
      final value = (noiseWidth * currentMillSeconds) / maxMillSeconds;
      animController.value = value;
      _updateUi();
      if (p.inMilliseconds >= maxMillSeconds) {
        await _player.stop();
        currentDuration = Duration.zero;
        playStatus = PlayStatus.init;
        animController.reset();
        _updateUi();
        onComplete(id);
      }
    });
  }

  void _updateUi() {
    updater.notifyListeners();
  }

  Future stopPlaying() async {
    _player.pause();
    playStatus = PlayStatus.stop;
  }

  Future startPlayingForIo(String path) async {
    await _player.setAudioSource(
      AudioSource.uri(Uri.file(path)),
      initialPosition: currentDuration,
    );
    _player.play();
    _player.setSpeed(speed.getSpeed);
  }

  Future startPlayingForJs() async {
    if (isBytes) {
      await _player.setAudioSource(
        BytesCustomSource(audioSrc.bytes!),
        initialPosition: currentDuration,
      );
    }
    if (isUrl) {
      await _player.setAudioSource(
        AudioSource.uri(Uri.parse(audioSrc.url!.fullUrl)),
        initialPosition: currentDuration,
      );
    }
    _player.play();
    _player.setSpeed(speed.getSpeed);
  }

  Future<void> dispose() async {
    await _player.dispose();
    positionStream?.cancel();
    playerStateStream?.cancel();
    animController.dispose();
  }

  void onSeek(Duration duration) {
    isSeeking = false;
    currentDuration = duration;
    _updateUi();
    _player.seek(duration);
  }

  void pausePlaying() {
    _player.pause();
    playStatus = PlayStatus.pause;
    _updateUi();
    onPause(id);
  }

  void _listenToPlayerState() {
    playerStateStream = _player.playerStateStream.listen((event) async {
      if (event.processingState == ProcessingState.completed) {
        // await _player.stop();
        // currentDuration = Duration.zero;
        // playStatus = PlayStatus.init;
        // animController.reset();
        // _updateUi();
        // onComplete(id);
      } else if (event.playing) {
        playStatus = PlayStatus.playing;
        _updateUi();
      }
    });
  }

  String get playSpeedStr {
    switch (speed) {
      case PlaySpeed.x1:
        return "1.00x";
      case PlaySpeed.x1_25:
        return "1.25x";
      case PlaySpeed.x1_5:
        return "1.50x";
      case PlaySpeed.x1_75:
        return "1.75x";
      case PlaySpeed.x2:
        return "2.00x";
    }
  }

  void changeSpeed() async {
    switch (speed) {
      case PlaySpeed.x1:
        speed = PlaySpeed.x1_25;
        break;
      case PlaySpeed.x1_25:
        speed = PlaySpeed.x1_5;
        break;
      case PlaySpeed.x1_5:
        speed = PlaySpeed.x1_75;
        break;
      case PlaySpeed.x1_75:
        speed = PlaySpeed.x2;
        break;
      case PlaySpeed.x2:
        speed = PlaySpeed.x1;
        break;
    }
    await _player.setSpeed(speed.getSpeed);
    _updateUi();
  }

  void onChangeSliderStart(double value) {
    isSeeking = true;
    pausePlaying();
  }

  void _setRandoms() {
    for (var i = 0; i < 50; i++) {
      randoms.add(5.74.w() * Random().nextDouble() + .26.w());
    }
  }

  void onChanging(double d) {
    currentDuration = Duration(milliseconds: d.toInt());
    final value = (noiseWidth * d) / maxMillSeconds;
    animController.value = value;
    _updateUi();
  }

  String get remindingTime {
    if (currentDuration == Duration.zero) {
      return maxDuration.getStringTime;
    }
    if (isSeeking) {
      return currentDuration.getStringTime;
    }
    if (isPause || isInit) {
      return maxDuration.getStringTime;
    }
    return currentDuration.getStringTime;
  }

  Future setMaxDurationForIo(String path) async {
    try {
      final maxDuration = await jsAudio.AudioPlayer().setFilePath(path);
      if (maxDuration != null) {
        this.maxDuration = maxDuration;
        animController.duration = maxDuration;
      }
    } catch (err) {
      if (kDebugMode) {
        print("cant get the max duration from the path $path");
      }
    }
  }

  Future setMaxDurationForJs() async {
    try {
      if (isUrl) {
        final maxDuration = await jsAudio.AudioPlayer()
            .setAudioSource(AudioSource.uri(Uri.parse(audioSrc.url!.fullUrl)));
        if (maxDuration != null) {
          this.maxDuration = maxDuration;
          animController.duration = maxDuration;
        }
      }
      if (isBytes) {
        final maxDuration = await jsAudio.AudioPlayer().setAudioSource(
          BytesCustomSource(audioSrc.bytes!),
        );
        if (maxDuration != null) {
          this.maxDuration = maxDuration;
          animController.duration = maxDuration;
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print(
          "cant get the max duration from the BytesSrc BytesSrc BytesSrc !",
        );
      }
    }
  }
}

class MyTicker extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }
}
