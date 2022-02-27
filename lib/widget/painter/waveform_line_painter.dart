import "package:flutter/material.dart";
import "package:flutter_waveforms/widget/painter/waveform_painter.dart";

// TODO(pierre/low): add semantics
// TODO(pierre/high): support Peak_level > 0
class WaveformLinePainter extends WaveformPainter {
  const WaveformLinePainter({
    required this.waveformData,
    required this.backgroundColor,
    required this.lineColor,
  }) : super();

  final List<double> waveformData;
  final Color backgroundColor;
  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    final elementSize = size.width / waveformData.length;
    final yCenter = size.height / 2;
    var i = 0.0;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = backgroundColor,
    );

    for (final data in waveformData) {
      final a = withMinAndMaxChecker(
        offset: getOffset(
          x: i,
          y: (data * size.height) + yCenter,
        ),
        size: size,
      );
      final b = withMinAndMaxChecker(
        offset: getOffset(
          x: i,
          y: (data * size.height) - yCenter,
          isAbs: true,
        ),
        size: size,
      );

      final paint = Paint()
        ..color = lineColor
        ..strokeWidth = 1.0;

      canvas.drawLine(
        a,
        b,
        paint,
      );

      i += elementSize;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
