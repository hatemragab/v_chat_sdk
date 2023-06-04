// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart' as cache;
import 'package:just_audio/just_audio.dart' as js_audio;
import 'package:just_audio/just_audio.dart';
import 'package:v_platform/v_platform.dart';

import 'helpers/bytes_custom_source.dart';
import 'helpers/play_status.dart';
import 'helpers/utils.dart';

class VVoiceMessageController extends ValueNotifier implements TickerProvider {
  final VPlatformFile audioSrc;
  late Duration maxDuration;
  Duration _currentDuration = Duration.zero;
  final Function(String id)? onComplete;
  final Function(String id)? onPlaying;
  final Function(String id)? onPause;
  final double noiseWidth = 50.5.w();
  final String id;
  late AnimationController animController;
  final AudioPlayer _player = AudioPlayer();
  PlayStatus _playStatus = PlayStatus.init;
  PlaySpeed _speed = PlaySpeed.x1;
  final randoms = <double>[];
  StreamSubscription? _positionStream;
  StreamSubscription? _playerStateStream;

  bool _isSeeking = false;

  ///state
  bool get isPlaying => _playStatus == PlayStatus.playing;

  bool get isInit => _playStatus == PlayStatus.init;

  bool get isDownloading => _playStatus == PlayStatus.downloading;

  bool get isDownloadError => _playStatus == PlayStatus.downloadError;

  bool get isStop => _playStatus == PlayStatus.stop;

  double get currentMillSeconds {
    final c = _currentDuration.inMilliseconds.toDouble();
    if (c >= maxMillSeconds) {
      return maxMillSeconds;
    }
    return c;
  }

  bool get isPause => _playStatus == PlayStatus.pause;

  double get maxMillSeconds => maxDuration.inMilliseconds.toDouble();

  VVoiceMessageController({
    required this.id,
    required this.audioSrc,
    this.maxDuration = const Duration(days: 1),
    this.onComplete,
    this.onPause,
    this.onPlaying,
  }) : super(null) {
    _setRandoms();
    animController = AnimationController(
      vsync: this,
      upperBound: noiseWidth,
      duration: maxDuration,
    );
    _listenToRemindingTime();
    _listenToPlayerState();
  }

  // bool get _isIosWebm =>
  //     VPlatforms.isIOS &&
  //     extension(audioSrc.url ?? audioSrc.fileLocalPath!) == ".webm";

  Future initAndPlay() async {
    _playStatus = PlayStatus.downloading;
    _updateUi();
    try {
      if (kIsWeb) {
        await _setMaxDurationForJs();
        await startPlayingForJs();
      } else {
        final path = await _getFileFromCache();
        await _setMaxDurationForIo(path);
        await _startPlayingForIo(path);
      }
      if (onPlaying != null) {
        onPlaying!(id);
      }
    } catch (err) {
      _playStatus = PlayStatus.downloadError;
      _updateUi();
      rethrow;
    }
    _updateUi();
  }

  bool get isFile => audioSrc.isFromPath;

  bool get isBytes => audioSrc.isFromBytes;

  bool get isUrl => audioSrc.isFromUrl;

  Future<String> _getFileFromCache() async {
    if (isFile) {
      return audioSrc.fileLocalPath!;
    }
    if (isBytes) {
      throw "bytes file not supported for play voice";
    }
    final p = await cache.DefaultCacheManager()
        .getSingleFile(audioSrc.url!, key: audioSrc.getUrlPath);

    return p.path;
  }

  void _listenToRemindingTime() {
    _positionStream = _player.positionStream.listen((Duration p) async {
      _currentDuration = p;
      final value = (noiseWidth * currentMillSeconds) / maxMillSeconds;
      animController.value = value;
      _updateUi();
      if (p.inMilliseconds >= maxMillSeconds) {
        await _player.stop();
        _currentDuration = Duration.zero;
        _playStatus = PlayStatus.init;
        animController.reset();
        _updateUi();
        if (onComplete != null) {
          onComplete!(id);
        }
      }
    });
  }

  void _updateUi() {
    notifyListeners();
  }

  Future _startPlayingForIo(String path) async {
    await _player.setAudioSource(
      AudioSource.uri(Uri.file(path)),
      initialPosition: _currentDuration,
    );
    _player.play();
    _player.setSpeed(_speed.getSpeed);
  }

  Future startPlayingForJs() async {
    if (isBytes) {
      await _player.setAudioSource(
        BytesCustomSource(audioSrc.bytes!),
        initialPosition: _currentDuration,
      );
    }
    if (isUrl) {
      await _player.setAudioSource(
        AudioSource.uri(Uri.parse(audioSrc.url!)),
        initialPosition: _currentDuration,
      );
    }
    _player.play();
    _player.setSpeed(_speed.getSpeed);
  }

  @override
  Future<void> dispose() async {
    await _player.dispose();
    _positionStream?.cancel();
    _playerStateStream?.cancel();
    animController.dispose();
    super.dispose();
  }

  void onSeek(Duration duration) {
    _isSeeking = false;
    _currentDuration = duration;
    _updateUi();
    _player.seek(duration);
  }

  void pausePlaying() {
    _player.pause();
    _playStatus = PlayStatus.pause;
    _updateUi();
    if (onPause != null) {
      onPause!(id);
    }
  }

  void _listenToPlayerState() {
    _playerStateStream = _player.playerStateStream.listen((event) async {
      if (event.processingState == ProcessingState.completed) {
        // await _player.stop();
        // currentDuration = Duration.zero;
        // playStatus = PlayStatus.init;
        // animController.reset();
        // _updateUi();
        // onComplete(id);
      } else if (event.playing) {
        _playStatus = PlayStatus.playing;
        _updateUi();
      }
    });
  }

  String get playSpeedStr {
    switch (_speed) {
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
    switch (_speed) {
      case PlaySpeed.x1:
        _speed = PlaySpeed.x1_25;
        break;
      case PlaySpeed.x1_25:
        _speed = PlaySpeed.x1_5;
        break;
      case PlaySpeed.x1_5:
        _speed = PlaySpeed.x1_75;
        break;
      case PlaySpeed.x1_75:
        _speed = PlaySpeed.x2;
        break;
      case PlaySpeed.x2:
        _speed = PlaySpeed.x1;
        break;
    }
    await _player.setSpeed(_speed.getSpeed);
    _updateUi();
  }

  void onChangeSliderStart(double value) {
    _isSeeking = true;
    pausePlaying();
  }

  void _setRandoms() {
    for (var i = 0; i < 40; i++) {
      randoms.add(5.74.w() * Random().nextDouble() + .26.w());
    }
  }

  void onChanging(double d) {
    _currentDuration = Duration(milliseconds: d.toInt());
    final value = (noiseWidth * d) / maxMillSeconds;
    animController.value = value;
    _updateUi();
  }

  String get remindingTime {
    if (_currentDuration == Duration.zero) {
      return maxDuration.getStringTime;
    }
    if (_isSeeking) {
      return _currentDuration.getStringTime;
    }
    if (isPause || isInit) {
      return maxDuration.getStringTime;
    }
    return _currentDuration.getStringTime;
  }

  Future<void> _setMaxDurationForIo(String path) async {
    try {
      final maxDuration = await js_audio.AudioPlayer().setFilePath(path);
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

  Future _setMaxDurationForJs() async {
    try {
      if (isUrl) {
        final maxDuration = await js_audio.AudioPlayer()
            .setAudioSource(AudioSource.uri(Uri.parse(audioSrc.url!)));
        if (maxDuration != null) {
          this.maxDuration = maxDuration;
          animController.duration = maxDuration;
        }
      }
      if (isBytes) {
        final maxDuration = await js_audio.AudioPlayer().setAudioSource(
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

  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }
}
