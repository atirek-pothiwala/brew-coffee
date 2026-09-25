import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Animated liquid from machine nozzle down to the cup rim.
class CoffeePourStream extends StatelessWidget {
  const CoffeePourStream({
    super.key,
    required this.top,
    required this.bottom,
    required this.centerX,
    required this.color,
    required this.t,
    required this.active,
  });

  final double top;
  final double bottom;
  final double centerX;
  final Color color;
  final double t;
  final bool active;

  @override
  Widget build(BuildContext context) {
    if (!active || bottom <= top + 4) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: 0,
      right: 0,
      top: top,
      height: bottom - top,
      child: CustomPaint(
        painter: _PourPainter(
          centerX: centerX,
          color: color,
          t: t,
        ),
      ),
    );
  }
}

class _PourPainter extends CustomPainter {
  _PourPainter({
    required this.centerX,
    required this.color,
    required this.t,
  });

  final double centerX;
  final Color color;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final streamPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(centerX, 0);
    for (var y = 0.0; y <= size.height; y += 3) {
      final wobble = math.sin((y / size.height * 4 + t) * math.pi) * 2.5;
      path.lineTo(centerX + wobble, y);
    }
    canvas.drawPath(path, streamPaint);

    final glow = Paint()
      ..color = color.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 11
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, glow);

    final dropPaint = Paint()..color = color;
    for (var i = 0; i < 4; i++) {
      final phase = t * math.pi * 2 + i * 1.2;
      final dy = (size.height * (0.25 + i * 0.18) + math.sin(phase) * 6)
          .clamp(0.0, size.height);
      canvas.drawCircle(
        Offset(centerX + math.sin(phase) * 3, dy),
        2.2,
        dropPaint,
      );
    }

    canvas.drawCircle(Offset(centerX, size.height), 4, dropPaint);
  }

  @override
  bool shouldRepaint(covariant _PourPainter oldDelegate) =>
      oldDelegate.t != t || oldDelegate.color != color;
}
