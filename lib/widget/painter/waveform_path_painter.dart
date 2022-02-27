import "package:flutter/material.dart";
import "package:flutter_waveforms/widget/painter/waveform_painter.dart";

class WaveformPathPainter extends WaveformPainter {
  const WaveformPathPainter({
    required this.waveformData,
    required this.backgroundColor,
    required this.pathColor,
    required this.paintingStyle,
  }) : super();

  final List<double> waveformData;
  final Color backgroundColor;
  final Color pathColor;
  final PaintingStyle paintingStyle;

  @override
  void paint(Canvas canvas, Size size) {
    final elementSize = size.width / waveformData.length;
    final yCenter = size.height / 2;
    var i = 0.0;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = backgroundColor,
    );

    final maxPoints = <Offset>[];
    final minPoints = <Offset>[];

    for (final data in waveformData) {
      final maxOffset = withMinAndMaxChecker(
        offset: getOffset(x: i, y: (data * size.height) + yCenter),
        size: size,
      );

      maxPoints.add(maxOffset);

      final minOffset = withMinAndMaxChecker(
        offset: getOffset(x: i, y: (data * size.height) - yCenter, isAbs: true),
        size: size,
      );

      minPoints.add(minOffset);

      i += elementSize;
    }

    final path = Path()..moveTo(0, yCenter);

    for (final offset in maxPoints) {
      path.lineTo(offset.dx, offset.dy);
    }

    path.lineTo(size.width, yCenter);

    for (final offset in minPoints.reversed) {
      path.lineTo(offset.dx, offset.dy);
    }

    path.lineTo(0, yCenter);

    final pathPaint = Paint()
      ..color = pathColor
      ..style = paintingStyle
      ..strokeWidth = 1;

    canvas.drawPath(path, pathPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
