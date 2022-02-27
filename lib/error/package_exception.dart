class NotAnAudioFileException implements Exception {
  @override
  String toString() {
    return "You are trying to get the waveform of an non-audio file,"
        " currently this package only support |wav|mp3|flac|"
        " if you want to support other audio file, please open an issue"
        " on github";
  }
}

class FFprobeCommandeFailedException implements Exception {
  @override
  String toString() {
    return "FFprobe command failed";
  }
}

class EmptyOutputException implements Exception {
  @override
  String toString() {
    return "FFprobe output is empty";
  }
}

class ParsingOutputException implements Exception {
  @override
  String toString() {
    return "Unable to retrieve waveform data from FFprobe output";
  }
}

class UnimplementedPainterException implements Exception {
  const UnimplementedPainterException({required this.wantedType});

  final String wantedType;

  @override
  String toString() {
    return "The painter $wantedType is not implemented yet";
  }
}
