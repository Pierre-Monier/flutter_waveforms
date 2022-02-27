import "package:ffmpeg_kit_flutter/media_information.dart";

extension MediaInformationX on MediaInformation {
  bool isAudioFile() {
    final String format = getFormat() ?? "unknown";
    return format == "wav" || format == "mp3" || format == "flac";
  }

  String? getSampleRate() {
    try {
      return getStreams().first.getSampleRate();
    } on Exception catch (_) {
      return null;
    }
  }
}
