import "dart:convert";
import "dart:io";
import "dart:async";

import "package:ffmpeg_kit_flutter/ffprobe_kit.dart";
import "package:ffmpeg_kit_flutter/media_information.dart";
import "package:ffmpeg_kit_flutter/return_code.dart";
import "package:flutter_waveforms/domain/audio_file_peak_level_input.dart";
import "package:flutter_waveforms/error/package_exception.dart";
import "package:flutter_waveforms/flutter_waveforms.dart";
import "package:flutter_waveforms/util/app_logger.dart";
import "package:flutter_waveforms/extension/media_information.dart";

abstract class FFmpegService {
  static const int _defaultSampleRate = 44100;
  static const String astatsMetaData = "lavfi.astats.Overall.Peak_level";

  static Future<List<double>?> getAudioFilePeakLevel(
    AudioFilePeakLevelInput input,
  ) async {
    final audioFile = input.audioFile;
    final waveformType = input.waveformType;

    final mediaInformationSession =
        await FFprobeKit.getMediaInformation(audioFile.path);
    final mediaInformation = mediaInformationSession.getMediaInformation();

    if (mediaInformation != null && mediaInformation.isAudioFile()) {
      final command = _getFFprobeCommand(
        audioFile: audioFile,
        mediaInformation: mediaInformation,
        waveformType: waveformType,
      );

      final _completer = Completer<List<double>?>();

      await FFprobeKit.executeAsync(command, (session) async {
        final returnCode = await session.getReturnCode();
        final output = await session.getOutput();

        if (ReturnCode.isSuccess(returnCode)) {
          _completer.complete(_outputToList(output));
        } else {
          _handleFailure(returnCode: returnCode, completer: _completer);
        }
      });

      return _completer.future;
    } else {
      throw NotAnAudioFileException();
    }
  }

  static List<double> _outputToList(String? output) {
    if (output == null || output.isEmpty) {
      // return ErrorHandler.handleError(EmptyOutputException());
      throw EmptyOutputException();
    }

    try {
      final parsedOutput = jsonDecode(output);
      final frameData = parsedOutput["frames"] as List;
      return frameData
          .map<double?>((e) {
            try {
              return 1 / (double.parse(e["tags"][astatsMetaData] as String));
            } catch (e) {
              return null;
            }
          })
          .whereType<double>()
          .toList();
    } on Exception catch (_) {
      throw ParsingOutputException();
    }
  }

  static void _handleFailure({
    required ReturnCode? returnCode,
    required Completer<List<double>?> completer,
  }) {
    if (ReturnCode.isCancel(returnCode)) {
      AppLogger.i("ffprobe commande canceled");
    } else {
      final e = FFprobeCommandeFailedException();
      completer.completeError(e);
    }
  }

  static String _getFFprobeCommand({
    required File audioFile,
    required MediaInformation mediaInformation,
    required WaveformType waveformType,
  }) {
    final audioFilePath = audioFile.path;
    final sampleRate = waveformType == WaveformType.summary
        ? _getSampleRate(mediaInformation: mediaInformation)
        : "";

    return "-v error -f lavfi -i amovie=$audioFilePath$sampleRate"
        ",astats=metadata=1:reset=1 -show_entries"
        " frame_tags=$astatsMetaData -of json";
  }

  static String _getSampleRate({required MediaInformation mediaInformation}) {
    const sampleRateKey = "asetnsamples";
    final sampleRateValue =
        mediaInformation.getSampleRate() ?? _defaultSampleRate.toString();
    // must a comma before the key
    return ",$sampleRateKey=$sampleRateValue";
  }
}
