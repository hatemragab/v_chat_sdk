// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:record/record.dart';

abstract class AppRecorder {
  Future<void> start([String? path]);

  Future<String?> stop();

  Future pause();

  Future<bool> isRecording();

  Future<void> close();
}

class MobileRecorder extends AppRecorder {
  final recorder = RecorderController()
    ..androidEncoder = AndroidEncoder.aac
    ..androidOutputFormat = AndroidOutputFormat.mpeg4
    ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
    ..sampleRate = 44100;

  @override
  Future<void> start([String? path]) async {
    await recorder.record(path: path);
  }

  @override
  Future<String?> stop() async {
    final path = await recorder.stop();
    if (path != null) {
      return Uri.parse(path).path;
    }
    return null;
  }

  @override
  Future pause() async {
    await recorder.pause();
  }

  @override
  Future close() async {
    recorder.dispose();
  }

  @override
  Future<bool> isRecording() async {
    return recorder.isRecording;
  }
}

class PlatformRecorder extends AppRecorder {
  final recorder = Record();

  @override
  Future close() async {
    await recorder.dispose();
  }

  @override
  Future pause() async {
    await recorder.pause();
  }

  @override
  Future<void> start([String? path]) async {
    await recorder.start();
  }

  @override
  Future<bool> isRecording() async {
    return recorder.isRecording();
  }

  @override
  Future<String?> stop() async {
    return recorder.stop();
  }
}

// class WebRecorder extends AppRecorder {
//   final recorder = FlutterSoundRecorder();
//
//   @override
//   Future close() async {
//     await recorder.closeAudioSession();
//   }
//
//   @override
//   Future pause() async {
//     await recorder.pauseRecorder();
//   }
//
//   @override
//   Future<void> start([String? path]) async {
//     await recorder.startRecorder();
//   }
//
//   @override
//   Future<bool> isRecording() async {
//     return recorder.isRecording;
//   }
//
//   @override
//   Future<String?> stop() async {
//     return recorder.stopRecorder();
//   }
// }
