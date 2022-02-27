import "package:flutter_waveforms/domain/audio_file_peak_level_input.dart";
import "package:flutter_waveforms/service/ffmpeg_service.dart";
import "package:flutter_waveforms/util/app_logger.dart";
import "package:isolate_handler/isolate_handler.dart";

abstract class IsolateService {
  static final isolates = IsolateHandler();

  static void spawnAudioFilePeakLevelIsolate({
    required String isolateName,
    required AudioFilePeakLevelInput input,
  }) {
    isolates.spawn<String>(
      getAudioFilePeakLevelEntryPoint,
      name: isolateName,
      onReceive: (message) {
        AppLogger.i("receive data from isolate: $message");
        isolates.kill(isolateName);
      },
      onInitialized: () => isolates.send(
        input.endode(),
        to: isolateName,
      ),
    );
  }

  static void getAudioFilePeakLevelEntryPoint(Map<String, dynamic> context) {
    // Calling initialize from the entry point with the context is
    // required if communication is desired. It returns a messenger which
    // allows listening and sending information to the main isolate.
    final messenger = HandledIsolate.initialize(context);

    // Triggered every time data is received from the main isolate.
    messenger.listen((msg) async {
      final input =
          AudioFilePeakLevelInput.fromEncodedData(msg as Map<String, String>);

      // ignore: lines_longer_than_80_chars
      // final response = "got ${input.audioFile.path} and ${input.waveformType}";
      final response = await FFmpegService.getAudioFilePeakLevel(input);
      // THIS SHOULD TRIGGER ONRECEIVED
      messenger.send(response.toString());
    });
  }
}
