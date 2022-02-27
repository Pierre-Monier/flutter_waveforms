import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_waveforms/domain/audio_file_peak_level_input.dart";
import "package:flutter_waveforms/domain/painter_type.dart";
import "package:flutter_waveforms/error/package_exception.dart";
import "package:flutter_waveforms/service/ffmpeg_service.dart";
import "package:flutter_waveforms/widget/painter/waveform_line_painter.dart";
import "package:flutter_waveforms/domain/waveform_type.dart";
import "package:flutter_waveforms/widget/painter/waveform_path_painter.dart";

class Waveform extends StatelessWidget {
  const Waveform({
    required this.audioFile,
    required this.waveformType,
    this.size,
    this.loadingWidget,
    this.errorWidget,
    this.painterType = PainterType.line,
    this.backgroundColor,
    this.waveColor = Colors.black,
    this.shouldFill = true,
    Key? key,
  }) : super(key: key);

  final File audioFile;
  final WaveformType waveformType;
  final Size? size;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final PainterType painterType;
  final Color? backgroundColor;
  final Color waveColor;
  final bool shouldFill;

  Future<List<double>?> _getAudioFileData() {
    // TODO(pierre/high): make it works
    // IsolateService.spawnAudioFilePeakLevelIsolate(
    //   isolateName: "${audioFile.path}_$waveformType",
    //   input: AudioFilePeakLevelInput(
    //     audioFile: audioFile,
    //     waveformType: waveformType,
    //   ),
    // );

    return FFmpegService.getAudioFilePeakLevel(
      AudioFilePeakLevelInput(audioFile: audioFile, waveformType: waveformType),
    );
  }

  CustomPainter _getCustomPainter({required List<double> data}) {
    switch (painterType) {
      case PainterType.line:
        return WaveformLinePainter(
          waveformData: data,
          lineColor: waveColor,
          backgroundColor: backgroundColor ?? Colors.transparent,
        );
      case PainterType.path:
        return WaveformPathPainter(
          waveformData: data,
          pathColor: waveColor,
          backgroundColor: backgroundColor ?? Colors.transparent,
          paintingStyle: shouldFill ? PaintingStyle.fill : PaintingStyle.stroke,
        );
      default:
        throw UnimplementedPainterException(wantedType: painterType.name);
    }
  }

  Widget _renderWaveform(List<double> data) {
    return CustomPaint(
      size: size ?? Size.zero,
      painter: _getCustomPainter(data: data),
    );
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<double>?>(
        future: _getAudioFileData(),
        builder: (context, snapshot) {
          final _data = snapshot.data;

          if (_data == null) {
            return loadingWidget ??
                const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return errorWidget ?? Text("Error: ${snapshot.error}");
          }

          return _renderWaveform(_data);
        },
      );
}
