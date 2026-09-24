import 'package:brew_coffee/domain/entities/cup_visual_state.dart';
import 'package:flutter/material.dart';

class CoffeeCupView extends StatelessWidget {
  const CoffeeCupView({super.key, required this.visual, this.size = 160});

  final CupVisualState visual;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 1.1,
      child: CustomPaint(
        painter: _CupPainter(visual: visual),
      ),
    );
  }
}

class _CupPainter extends CustomPainter {
  _CupPainter({required this.visual});

  final CupVisualState visual;

  @override
  void paint(Canvas canvas, Size size) {
    final cupRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.2, size.height * 0.25, size.width * 0.55, size.height * 0.6),
      const Radius.circular(8),
    );
    canvas.drawRRect(
      cupRect,
      Paint()..color = Colors.white.withOpacity(0.9),
    );
    canvas.drawRRect(
      cupRect,
      Paint()
        ..color = const Color(0xFFE4D8CB)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    final liquidTop = cupRect.bottom - cupRect.height * (visual.espressoLevel + visual.milkLevel);
    final liquidRect = Rect.fromLTRB(
      cupRect.left + 4,
      liquidTop,
      cupRect.right - 4,
      cupRect.bottom - 4,
    );
    if (visual.espressoLevel > 0) {
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          liquidRect,
          bottomLeft: const Radius.circular(6),
          bottomRight: const Radius.circular(6),
        ),
        Paint()..color = Color(visual.liquidColor),
      );
    }

    if (visual.showSteam) {
      final steamPaint = Paint()
        ..color = Colors.white.withOpacity(0.5)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      for (var i = 0; i < 3; i++) {
        final x = size.width * (0.35 + i * 0.08);
        canvas.drawArc(
          Rect.fromCenter(center: Offset(x, size.height * 0.18), width: 12, height: 20),
          0,
          3.14,
          false,
          steamPaint,
        );
      }
    }

    if (visual.showWhippedCream) {
      canvas.drawCircle(
        Offset(cupRect.center.dx, cupRect.top + 8),
        14,
        Paint()..color = const Color(0xFFFFF8F0),
      );
    }
    if (visual.showCinnamon) {
      canvas.drawCircle(
        Offset(cupRect.center.dx, cupRect.top + 10),
        3,
        Paint()..color = const Color(0xFFC49A6C),
      );
    }
    if (visual.showCocoa) {
      canvas.drawRect(
        Rect.fromCenter(center: Offset(cupRect.center.dx, cupRect.top + 12), width: 20, height: 4),
        Paint()..color = const Color(0xFF3B2418).withOpacity(0.6),
      );
    }
    if (visual.showCaramelDrizzle) {
      final path = Path();
      path.moveTo(cupRect.center.dx - 10, cupRect.top);
      path.quadraticBezierTo(cupRect.center.dx, cupRect.top + 30, cupRect.center.dx + 12, cupRect.top + 50);
      canvas.drawPath(
        path,
        Paint()
          ..color = const Color(0xFFC49A6C)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CupPainter oldDelegate) =>
      oldDelegate.visual != visual;
}
