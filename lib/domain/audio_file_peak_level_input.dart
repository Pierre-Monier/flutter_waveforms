import "dart:io";

import "package:flutter_waveforms/flutter_waveforms.dart";

class AudioFilePeakLevelInput {
  const AudioFilePeakLevelInput({
    required this.audioFile,
    required this.waveformType,
  });

  factory AudioFilePeakLevelInput.fromEncodedData(
    Map<String, String> encodedData,
  ) =>
      AudioFilePeakLevelInput(
        audioFile: File(encodedData["audioFile"]!),
        waveformType:
            WaveformType.values[int.parse(encodedData["waveformType"]!)],
      );

  Map<String, String> endode() => {
        "audioFile": audioFile.path,
        "waveformType": waveformType.index.toString()
      };

  final File audioFile;
  final WaveformType waveformType;
}
