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

    final surfaceY = fillFraction > 0.01
        ? liquidTop
        : body.top + body.height * 0.55;
    _drawToppings(canvas, body, surfaceY);
    if (visual.showSteam) {
      _drawSteam(canvas, Offset(body.center.dx, body.top - 8));
    }
  }

  void _drawToppings(Canvas canvas, Rect body, double surfaceY) {
    final rim = Offset(body.center.dx, surfaceY.clamp(body.top + 8, body.bottom - 12));
    final hasPowder =
        visual.showCinnamon || visual.showCocoa || visual.showCaramelDrizzle;

    if (hasPowder && !visual.showWhippedCream) {
      canvas.save();
      canvas.clipPath(_mugInteriorPath(body));
      if (visual.showCaramelDrizzle) {
        _drawCaramelDrizzle(canvas, body, rim, onCream: false);
      }
      if (visual.showCocoa) {
        _drawPowderDust(
          canvas,
          rim,
          baseColor: AppColors.darkCoffee,
          speckleColor: const Color(0xFF2A1810),
          intensity: 0.55,
        );
      }
      if (visual.showCinnamon) {
        _drawPowderDust(
          canvas,
          rim,
          baseColor: AppColors.caramelAccent,
          speckleColor: const Color(0xFFA66B3D),
          intensity: 0.45,
        );
      }
      canvas.restore();
    }

    if (visual.showWhippedCream) {
      final creamCenter = Offset(body.center.dx, body.top + 6);
      _drawWhippedCream(canvas, creamCenter);
      if (visual.showCaramelDrizzle) {
        _drawCaramelDrizzle(canvas, body, creamCenter.translate(0, -2), onCream: true);
      }
      if (visual.showCocoa) {
        _drawPowderDust(
          canvas,
          creamCenter.translate(0, 4),
          baseColor: AppColors.darkCoffee,
          speckleColor: const Color(0xFF2A1810),
          intensity: 0.35,
          radiusScale: 0.85,
        );
      }
      if (visual.showCinnamon) {
        _drawPowderDust(
          canvas,
          creamCenter.translate(0, 2),
          baseColor: AppColors.caramelAccent,
          speckleColor: const Color(0xFFA66B3D),
          intensity: 0.4,
          radiusScale: 0.8,
        );
      }
    }
  }

  void _drawWhippedCream(Canvas canvas, Offset center) {
    const peaks = <Offset>[
      Offset(0, -6),
      Offset(-16, 0),
      Offset(16, 0),
      Offset(-9, 10),
      Offset(10, 9),
      Offset(0, 12),
    ];
    const radii = <double>[15, 12, 12, 10, 10, 11];

    canvas.drawOval(
      Rect.fromCenter(
        center: center.translate(0, 14),
        width: 44,
        height: 10,
      ),
      Paint()..color = AppColors.darkCoffee.withOpacity(0.06),
    );

    for (var i = 0; i < peaks.length; i++) {
      final pos = center + peaks[i];
      final r = radii[i];
      final paint = Paint()
        ..shader = ui.Gradient.radial(
          pos + Offset(-r * 0.25, -r * 0.35),
          r * 1.1,
          [
            const Color(0xFFFFFDF9),
            const Color(0xFFFFF3E6),
            const Color(0xFFE8D2BE),
          ],
          [0.0, 0.55, 1.0],
        );
      canvas.drawCircle(pos, r, paint);
      canvas.drawCircle(
        pos + Offset(-r * 0.2, -r * 0.25),
        r * 0.22,
        Paint()..color = Colors.white.withOpacity(0.65),
      );
    }
  }

  void _drawPowderDust(
    Canvas canvas,
    Offset center, {
    required Color baseColor,
    required Color speckleColor,
    required double intensity,
    double radiusScale = 1,
  }) {
    final w = 38 * radiusScale;
    final h = 14 * radiusScale;
    canvas.drawOval(
      Rect.fromCenter(center: center.translate(0, 3), width: w, height: h),
      Paint()..color = baseColor.withOpacity(intensity * 0.35),
    );

    const speckles = <Offset>[
      Offset(-14, -2),
      Offset(-8, 3),
      Offset(-2, -1),
      Offset(4, 4),
      Offset(10, 0),
      Offset(15, 3),
      Offset(-11, 6),
      Offset(0, 5),
      Offset(7, -3),
      Offset(-5, -4),
      Offset(12, -2),
      Offset(-16, 2),
    ];
    for (final o in speckles) {
      final size = 0.9 + (o.dx.abs() % 3) * 0.35;
      canvas.drawCircle(
        center + o,
        size,
        Paint()..color = speckleColor.withOpacity(intensity * 0.85),
      );
    }
  }

  void _drawCaramelDrizzle(
    Canvas canvas,
    Rect body,
    Offset anchor, {
    required bool onCream,
  }) {
    final drips = onCream
        ? <List<Offset>>[
            [Offset(-10, -4), Offset(-4, 14), Offset(-8, 26)],
            [Offset(2, -6), Offset(6, 12), Offset(2, 24)],
            [Offset(12, -2), Offset(14, 10), Offset(10, 22)],
          ]
        : <List<Offset>>[
            [Offset(-12, 0), Offset(-6, 18), Offset(-10, 34)],
            [Offset(0, -2), Offset(4, 16), Offset(0, 32)],
            [Offset(10, 1), Offset(12, 20), Offset(8, 36)],
          ];

    for (final pts in drips) {
      final path = Path();
      path.moveTo(anchor.dx + pts[0].dx, anchor.dy + pts[0].dy);
      path.quadraticBezierTo(
        anchor.dx + pts[1].dx,
        anchor.dy + pts[1].dy,
        anchor.dx + pts[2].dx,
        anchor.dy + pts[2].dy,
      );
      canvas.drawPath(
        path,
        Paint()
          ..color = const Color(0xFF9A5E28).withOpacity(0.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5
          ..strokeCap = StrokeCap.round,
      );
      canvas.drawPath(
        path,
        Paint()
          ..color = const Color(0xFFD4A574)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round,
      );
      canvas.drawPath(
        path,
        Paint()
          ..color = const Color(0xFFFFE8C8).withOpacity(0.55)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..strokeCap = StrokeCap.round,
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
