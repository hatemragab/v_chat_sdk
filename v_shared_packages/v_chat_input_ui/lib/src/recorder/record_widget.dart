// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:v_chat_input_ui/src/recorder/recorders.dart';
import 'package:v_chat_input_ui/v_chat_input_ui.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class RecordWidget extends StatefulWidget {
  final Duration maxTime;

  const RecordWidget({
    super.key,
    required this.onCancel,
    required this.maxTime,
  });

  final VoidCallback onCancel;

  @override
  State<RecordWidget> createState() => RecordWidgetState();
}

class RecordWidgetState extends State<RecordWidget> {
  final _stopWatchTimer = StopWatchTimer();
  String currentTime = "00:00";
  int recordMilli = 0;

  //todo get from user this value
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
  final uuid = const Uuid();
  AppRecorder? recorder;

  @override
  void initState() {
    super.initState();
    if (VPlatforms.isMobile) {
      recorder = MobileRecorder();
    } else {
      recorder = PlatformRecorder();
    }
    _stopWatchTimer.rawTime.listen((value) {
      recordMilli = value;
      currentTime = StopWatchTimer.getDisplayTime(
        value,
        hours: false,
        milliSecond: false,
      );
      if (mounted) {
        setState(() {});
      }
    });
    _start();
  }

  void startCounterUp() {
    if (_stopWatchTimer.isRunning) {
      stopCounter();
    }
    _stopWatchTimer.onStartTimer();
  }

  Future stopCounter() async {
    _stopWatchTimer.onResetTimer();
    pauseCounter();
    recordMilli = 0;
  }

  Future pauseCounter() async {
    _stopWatchTimer.onStopTimer();
  }

  Future<String> _getDir() async {
    final appDirectory = await getApplicationDocumentsDirectory();
    return "${appDirectory.path}/${uuid.v4()}.aac";
  }

  Future<bool> _start() async {
    if (VPlatforms.isWeb) {
      await recorder!.start();
    } else {
      final path = await _getDir();
      await recorder!.start(path);
    }
    if (await recorder!.isRecording()) {
      startCounterUp();
      return true;
    }
    return false;
  }

  Future<VMessageVoiceData> stopRecord() async {
    pauseCounter();
    await Future.delayed(const Duration(milliseconds: 10));
    final path = await recorder!.stop();
    if (path != null) {
      List<int>? bytes;
      late final XFile? xFile;
      if (VPlatforms.isWeb) {
        xFile = XFile(path);
        bytes = await xFile.readAsBytes();
      }
      final uri = Uri.parse(path);
      final data = VMessageVoiceData(
        duration: recordMilli,
        fileSource: VPlatforms.isWeb
            ? VPlatformFileSource.fromBytes(
                name: "${DateTime.now().microsecondsSinceEpoch}.wave",
                bytes: bytes!,
              )
            : VPlatformFileSource.fromPath(
                filePath: uri.path,
              ),
      );
      //await close();
      return data;
    }
    throw "record path is null here ! while stop the record";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              currentTime.text.black
                  .color(context.isDark ? Colors.white : Colors.black54),
              const SizedBox(
                width: 15,
              ),
              if (recorder is MobileRecorder)
                Expanded(
                  child: AudioWaveforms(
                    size: Size(MediaQuery.of(context).size.width, 35.0),
                    recorderController: (recorder as MobileRecorder).recorder,
                  ),
                )
              else
                const Text("")
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  // close();
                  widget.onCancel();
                },
                child: context.vInputTheme.trashIcon,
              ),
              // const InkWell(
              //   child: Icon(
              //     Icons.pause_circle_outline,
              //     size: 30,
              //     color: Colors.grey,
              //   ),
              // ),
              const SizedBox()
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    close();
    super.dispose();
  }

  Future<void> close() async {
    stopCounter();
    await recorder?.stop();
    _stopWatchTimer.dispose();
    await recorder?.close();
  }
}
