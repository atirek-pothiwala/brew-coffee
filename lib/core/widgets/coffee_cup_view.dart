import 'dart:ui' as ui;

import 'package:brew_coffee/core/theme/app_colors.dart';
import 'package:brew_coffee/domain/entities/cup_visual_state.dart';
import 'package:flutter/material.dart';

class CoffeeCupView extends StatefulWidget {
  const CoffeeCupView({super.key, required this.visual, this.size = 160});

  final CupVisualState visual;
  final double size;

  @override
  State<CoffeeCupView> createState() => _CoffeeCupViewState();
}

class _CoffeeCupViewState extends State<CoffeeCupView>
    with SingleTickerProviderStateMixin {
  late AnimationController _fillController;
  late CupVisualState _fromVisual;
  late CupVisualState _toVisual;

  @override
  void initState() {
    super.initState();
    _fromVisual = widget.visual;
    _toVisual = widget.visual;
    _fillController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..value = 1;
  }

  @override
  void didUpdateWidget(CoffeeCupView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.visual != widget.visual) {
      _fromVisual = _lerpVisual(_fromVisual, _toVisual, _fillController.value);
      _toVisual = widget.visual;
      _fillController.forward(from: 0);
    }
  }

  CupVisualState _lerpVisual(CupVisualState from, CupVisualState to, double t) {
    final curve = Curves.easeInOut.transform(t);
    return CupVisualState(
      espressoLevel:
          ui.lerpDouble(from.espressoLevel, to.espressoLevel, curve) ?? 0,
      milkLevel: ui.lerpDouble(from.milkLevel, to.milkLevel, curve) ?? 0,
      milkOpacity: ui.lerpDouble(from.milkOpacity, to.milkOpacity, curve) ?? 0,
      liquidColor: Color.lerp(Color(from.liquidColor), Color(to.liquidColor), curve)
              ?.value ??
          to.liquidColor,
      showSteam: t > 0.5 ? to.showSteam : from.showSteam,
      showWhippedCream: t > 0.5 ? to.showWhippedCream : from.showWhippedCream,
      showCinnamon: t > 0.5 ? to.showCinnamon : from.showCinnamon,
      showCocoa: t > 0.5 ? to.showCocoa : from.showCocoa,
      showCaramelDrizzle:
          t > 0.5 ? to.showCaramelDrizzle : from.showCaramelDrizzle,
    );
  }

  @override
  void dispose() {
    _fillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fillController,
      builder: (context, _) {
        final display =
            _lerpVisual(_fromVisual, _toVisual, _fillController.value);
        const handleExtentFactor = 0.2;
        final bodyWidth = widget.size * 0.68;
        final handleExtent = widget.size * handleExtentFactor;
        final canvasWidth = bodyWidth + handleExtent;
        // Shift so the mug body (not the handle) sits on the horizontal center line.
        return Transform.translate(
          offset: Offset(handleExtent / 2, 0),
          child: SizedBox(
            width: canvasWidth,
            height: widget.size * 1.05,
            child: CustomPaint(
              painter: _MugPainter(
                visual: display,
                bodyWidth: bodyWidth,
                handleExtent: handleExtent,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MugPainter extends CustomPainter {
  _MugPainter({
    required this.visual,
    required this.bodyWidth,
    required this.handleExtent,
  });

  final CupVisualState visual;
  final double bodyWidth;
  final double handleExtent;

  Path _mugInteriorPath(Rect body) {
    return Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          body.deflate(5),
          const Radius.circular(10),
        ),
      );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final bodyLeft = 0.0;
    final body = Rect.fromLTWH(
      bodyLeft,
      size.height * 0.22,
      bodyWidth,
      size.height * 0.62,
    );

    // Soft shadow
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(body.center.dx, body.bottom + 10),
        width: body.width * 0.9,
        height: 14,
      ),
      Paint()..color = AppColors.darkCoffee.withOpacity(0.12),
    );

    // Handle (behind mug)
    final handle = Path();
    handle.moveTo(body.right - 2, body.top + body.height * 0.15);
    handle.quadraticBezierTo(
      body.right + handleExtent,
      body.center.dy,
      body.right - 2,
      body.bottom - body.height * 0.12,
    );
    canvas.drawPath(
      handle,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      handle,
      Paint()
        ..color = AppColors.borderDivider
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );

    final interior = body.deflate(5);
    final fillFraction =
        (visual.espressoLevel + visual.milkLevel).clamp(0.0, 0.92);
    final liquidTop = interior.bottom - interior.height * fillFraction;

    // Pure white ceramic
    canvas.drawRRect(
      RRect.fromRectAndRadius(body, const Radius.circular(14)),
      Paint()..color = Colors.white,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(body.deflate(3), const Radius.circular(12)),
      Paint()
        ..color = AppColors.borderDivider.withOpacity(0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(body, const Radius.circular(14)),
      Paint()
        ..color = AppColors.borderDivider
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );

    // Coffee inside mug (clipped, on top of ceramic)
    canvas.save();
    canvas.clipPath(_mugInteriorPath(body));
    if (fillFraction > 0.01) {
      final coffeePaint = Paint()..color = Color(visual.liquidColor);
      canvas.drawRect(
        Rect.fromLTRB(interior.left, liquidTop, interior.right, interior.bottom),
        coffeePaint,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(interior.center.dx, liquidTop),
          width: interior.width - 4,
          height: 10,
        ),
        Paint()..color = Color(visual.liquidColor).withOpacity(0.9),
      );
      if (visual.milkLevel > 0.05) {
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(interior.center.dx, liquidTop + 6),
            width: interior.width * 0.7,
            height: 6,
          ),
          Paint()
            ..color = const Color(0xFFF5F0E8)
                .withOpacity(visual.milkOpacity.clamp(0.2, 0.9)),
        );
      }
    }
    canvas.restore();

    // Rim
    canvas.drawArc(
      Rect.fromLTWH(body.left, body.top - 4, body.width, 14),
      3.14159,
      3.14159,
      false,
      Paint()
        ..color = Colors.white.withOpacity(0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    _drawToppings(canvas, body);
    if (visual.showSteam) {
      _drawSteam(canvas, Offset(body.center.dx, body.top - 8));
    }
  }

  void _drawToppings(Canvas canvas, Rect body) {
    final center = Offset(body.center.dx, body.top + 10);
    if (visual.showWhippedCream) {
      canvas.drawCircle(center, 16, Paint()..color = const Color(0xFFFFF8F0));
      canvas.drawCircle(
        center + const Offset(-8, 4),
        10,
        Paint()..color = const Color(0xFFFFFDF9),
      );
      canvas.drawCircle(
        center + const Offset(8, 4),
        10,
        Paint()..color = const Color(0xFFFFFDF9),
      );
    }
    if (visual.showCinnamon) {
      canvas.drawCircle(center, 4, Paint()..color = AppColors.caramelAccent);
    }
    if (visual.showCocoa) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: center.translate(0, 4), width: 22, height: 5),
          const Radius.circular(2),
        ),
        Paint()..color = AppColors.darkCoffee.withOpacity(0.55),
      );
    }
    if (visual.showCaramelDrizzle) {
      final path = Path();
      path.moveTo(center.dx - 8, body.top + 2);
      path.quadraticBezierTo(
        center.dx,
        body.top + 28,
        center.dx + 10,
        body.top + 42,
      );
      canvas.drawPath(
        path,
        Paint()
          ..color = AppColors.caramelAccent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
    }
  }

  void _drawSteam(Canvas canvas, Offset origin) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (var i = -1; i <= 1; i++) {
      final path = Path();
      path.moveTo(origin.dx + i * 10, origin.dy);
      path.quadraticBezierTo(
        origin.dx + i * 14,
        origin.dy - 18,
        origin.dx + i * 8,
        origin.dy - 32,
      );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MugPainter oldDelegate) =>
      oldDelegate.visual != visual;
}
