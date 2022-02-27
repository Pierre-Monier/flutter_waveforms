import "package:flutter/material.dart";

abstract class WaveformPainter extends CustomPainter {
  const WaveformPainter();

  @override
  void paint(Canvas canvas, Size size) {
    throw UnimplementedError();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    throw UnimplementedError();
  }

  Offset withMinAndMaxChecker({required Offset offset, required Size size}) {
    final y = offset.dy;

    if (y.abs() > size.height || y <= 0) {
      final dy = y.isNegative ? 0.0 : size.height;
      return Offset(offset.dx, dy);
    }

    return offset;
  }

  Offset getOffset({
    required double x,
    required double y,
    bool isAbs = false,
  }) {
    final yOffset = isAbs ? y.abs() : y;
    return Offset(x, yOffset);
  }
}
