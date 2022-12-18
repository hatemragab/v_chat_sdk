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
    ..sampleRate = 16000;

  @override
  Future<void> start([String? path]) async {
    await recorder.record(path);
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
