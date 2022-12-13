import 'dart:async';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:textless/textless.dart';
import 'package:uuid/uuid.dart' as u;
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_ui/src/core/extension.dart';
import 'package:v_chat_ui/src/message_input/src/recorder/recorders.dart';

class RecordWidget extends StatefulWidget {
  const RecordWidget({
    super.key,
    required this.onCancel,
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
  final uuid = const u.Uuid();
  late AppRecorder recorder;

  @override
  void initState() {
    super.initState();
    if (Platforms.isMobile) {
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
    if (Platforms.isWeb) {
      await recorder.start();
    } else {
      final path = await _getDir();
      await recorder.start(path);
    }
    if (await recorder.isRecording()) {
      startCounterUp();
      return true;
    }
    return false;
  }

  Future<VMessageVoiceData> stopRecord() async {
    pauseCounter();
    await Future.delayed(const Duration(milliseconds: 10));
    final path = await recorder.stop();
    if (path != null) {
      List<int>? bytes;
      late final XFile? xFile;
      if (Platforms.isWeb) {
        xFile = XFile(path);
        bytes = await xFile.readAsBytes();
      }
      final uri = Uri.parse(path);
      final data = VMessageVoiceData(
        duration: recordMilli,
        fileSource: Platforms.isWeb
            ? PlatformFileSource.fromBytes(
                name: "${DateTime.now().microsecondsSinceEpoch}.wave",
                bytes: bytes!,
              )
            : PlatformFileSource.fromPath(
                filePath: uri.path,
              ),
      );
      await close();
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
                  close();
                  widget.onCancel();
                },
                child: const Icon(
                  PhosphorIcons.trash,
                  color: Colors.redAccent,
                  size: 30,
                ),
              ),
              const InkWell(
                child: Icon(
                  Icons.pause_circle_outline,
                  size: 30,
                  color: Colors.grey,
                ),
              ),
              const SizedBox()
            ],
          ),
        ],
      ),
    );
  }

  // @override
  // void dispose() {
  //   close();
  //   super.dispose();
  // }

  Future close() async {
    stopCounter();
    await recorder.stop();
    _stopWatchTimer.dispose();
    await recorder.close();
  }
}
