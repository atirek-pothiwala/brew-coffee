import 'dart:math' as math;

import 'package:brew_coffee/core/theme/app_colors.dart';
import 'package:brew_coffee/core/widgets/coffee_cup_view.dart';
import 'package:brew_coffee/domain/entities/cup_visual_state.dart';
import 'package:brew_coffee/domain/entities/enums.dart';
import 'package:flutter/material.dart';

class EspressoMachineView extends StatefulWidget {
  const EspressoMachineView({
    super.key,
    required this.phase,
    required this.cupVisual,
    required this.progress,
  });

  final CoffeeMachinePhase phase;
  final CupVisualState cupVisual;
  final double progress;

  @override
  State<EspressoMachineView> createState() => _EspressoMachineViewState();
}

class _EspressoMachineViewState extends State<EspressoMachineView>
    with TickerProviderStateMixin {
  late final AnimationController _steam;
  late final AnimationController _pulse;
  late final AnimationController _shake;

  @override
  void initState() {
    super.initState();
    _steam = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _shake = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    )..repeat(reverse: true);
    _syncMotion();
  }

  @override
  void didUpdateWidget(covariant EspressoMachineView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.phase != widget.phase) {
      _syncMotion();
    }
  }

  void _syncMotion() {
    final grinding = widget.phase == CoffeeMachinePhase.grindingBeans;
    if (grinding && !_shake.isAnimating) {
      _shake.repeat(reverse: true);
    } else if (!grinding) {
      _shake.stop();
      _shake.value = 0;
    }
  }

  @override
  void dispose() {
    _steam.dispose();
    _pulse.dispose();
    _shake.dispose();
    super.dispose();
  }

  bool get _showEspressoStream => widget.phase == CoffeeMachinePhase.brewing;

  bool get _showMilkStream => widget.phase == CoffeeMachinePhase.addingMilk;

  bool get _showSteam =>
      widget.phase == CoffeeMachinePhase.finalizing ||
      widget.cupVisual.showSteam ||
      widget.phase == CoffeeMachinePhase.grindingBeans;

  @override
  Widget build(BuildContext context) {
    final shakeX = widget.phase == CoffeeMachinePhase.grindingBeans
        ? (math.sin(_shake.value * math.pi * 2) * 2.5)
        : 0.0;

    return Column(
      children: [
        Transform.translate(
          offset: Offset(shakeX, 0),
          child: SizedBox(
            width: 280,
            height: 300,
            child: AnimatedBuilder(
              animation: Listenable.merge([_steam, _pulse, _shake]),
              builder: (context, _) {
                return CustomPaint(
                  painter: _EspressoMachinePainter(
                    phase: widget.phase,
                    progress: widget.progress,
                    steamT: _steam.value,
                    pulseT: _pulse.value,
                    showEspressoStream: _showEspressoStream,
                    showMilkStream: _showMilkStream,
                    showSteam: _showSteam,
                  ),
                  child: const SizedBox.expand(),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 280,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              if (_showEspressoStream)
                _LiquidStream(
                  t: _steam.value,
                  color: const Color(0xFF3B2418),
                  width: 5,
                  height: 36,
                ),
              if (_showMilkStream)
                Positioned(
                  right: 72,
                  child: _LiquidStream(
                    t: _steam.value,
                    color: const Color(0xFFF5F0E8),
                    width: 6,
                    height: 42,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        CoffeeCupView(visual: widget.cupVisual, size: 150),
      ],
    );
  }
}

class _LiquidStream extends StatelessWidget {
  const _LiquidStream({
    required this.t,
    required this.color,
    required this.width,
    required this.height,
  });

  final double t;
  final Color color;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _StreamPainter(t: t, color: color),
    );
  }
}

class _StreamPainter extends CustomPainter {
  _StreamPainter({required this.t, required this.color});

  final double t;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    path.moveTo(size.width / 2, 0);
    for (var y = 0.0; y < size.height; y += 4) {
      final wobble = math.sin((y / size.height + t) * math.pi * 4) * 1.5;
      path.lineTo(size.width / 2 + wobble, y);
    }
    canvas.drawPath(
      path,
      paint..style = PaintingStyle.stroke..strokeWidth = size.width,
    );
    canvas.drawCircle(
      Offset(size.width / 2, size.height),
      size.width * 0.8,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _StreamPainter oldDelegate) =>
      oldDelegate.t != t;
}

class _EspressoMachinePainter extends CustomPainter {
  _EspressoMachinePainter({
    required this.phase,
    required this.progress,
    required this.steamT,
    required this.pulseT,
    required this.showEspressoStream,
    required this.showMilkStream,
    required this.showSteam,
  });

  final CoffeeMachinePhase phase;
  final double progress;
  final double steamT;
  final double pulseT;
  final bool showEspressoStream;
  final bool showMilkStream;
  final bool showSteam;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.12, h * 0.22, w * 0.76, h * 0.58),
      const Radius.circular(14),
    );

    final bodyGrad = LinearGradient(
      colors: const [Color(0xFF8A8A8A), Color(0xFF4A4A4A), Color(0xFF6E6E6E)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    canvas.drawRRect(
      bodyRect,
      Paint()..shader = bodyGrad.createShader(bodyRect.outerRect),
    );
    canvas.drawRRect(
      bodyRect,
      Paint()
        ..color = const Color(0xFF2A2A2A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Water tank
    final tank = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.28, h * 0.04, w * 0.44, h * 0.2),
      const Radius.circular(10),
    );
    canvas.drawRRect(
      tank,
      Paint()..color = const Color(0xFF9EC5E8).withOpacity(0.55),
    );
    canvas.drawRRect(
      tank,
      Paint()
        ..color = Colors.white.withOpacity(0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Grinder hopper
    if (phase == CoffeeMachinePhase.grindingBeans) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.34, h * 0.1, w * 0.32, h * 0.08),
          const Radius.circular(4),
        ),
        Paint()..color = const Color(0xFF3B2418).withOpacity(0.7 + pulseT * 0.2),
      );
    }

    // Display
    final displayRect = Rect.fromLTWH(w * 0.22, h * 0.32, w * 0.56, h * 0.12);
    canvas.drawRRect(
      RRect.fromRectAndRadius(displayRect, const Radius.circular(6)),
      Paint()..color = Color.lerp(
            const Color(0xFF1A3D2E),
            const Color(0xFF2D6B4F),
            pulseT * 0.4,
          )!,
    );
    _drawDisplayText(canvas, displayRect);

    // Group head + portafilter
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.38, h * 0.48, w * 0.24, h * 0.08),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFF333333),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.32, h * 0.54, w * 0.36, h * 0.06),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFF1F1F1F),
    );
    // Handle
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.68, h * 0.55, w * 0.14, h * 0.04),
        const Radius.circular(8),
      ),
      Paint()..color = AppColors.darkCoffee,
    );

    // Steam wand
    final wandPath = Path();
    wandPath.moveTo(w * 0.78, h * 0.42);
    wandPath.quadraticBezierTo(w * 0.82, h * 0.5, w * 0.76, h * 0.58);
    canvas.drawPath(
      wandPath,
      Paint()
        ..color = const Color(0xFFCCCCCC)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );

    // Drip tray
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.18, h * 0.72, w * 0.64, h * 0.06),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFF2C2C2C),
    );

    // Spout highlight when brewing
    if (showEspressoStream) {
      canvas.drawCircle(
        Offset(w * 0.5, h * 0.6),
        4 + pulseT * 2,
        Paint()..color = AppColors.caramelAccent.withOpacity(0.9),
      );
    }
    if (showMilkStream) {
      canvas.drawCircle(
        Offset(w * 0.76, h * 0.58),
        3 + pulseT,
        Paint()..color = Colors.white.withOpacity(0.85),
      );
    }

    if (showSteam) {
      _drawSteam(canvas, Offset(w * 0.5, h * 0.18));
      _drawSteam(canvas, Offset(w * 0.76, h * 0.38), scale: 0.7);
    }
  }

  void _drawDisplayText(Canvas canvas, Rect rect) {
    final text = phase.operationLabel.replaceAll('…', '').toUpperCase();
    final builder = TextPainter(
      text: TextSpan(
        text: text.length > 18 ? '${text.substring(0, 16)}…' : text,
        style: const TextStyle(
          color: Color(0xFF7CFFB2),
          fontSize: 9,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout(maxWidth: rect.width - 8);
    builder.paint(
      canvas,
      Offset(rect.left + 6, rect.center.dy - builder.height / 2),
    );
  }

  void _drawSteam(Canvas canvas, Offset origin, {double scale = 1}) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * scale;
    for (var i = 0; i < 3; i++) {
      final phase = steamT * math.pi * 2 + i * 0.8;
      final path = Path();
      path.moveTo(origin.dx + i * 8 - 8, origin.dy);
      path.quadraticBezierTo(
        origin.dx + math.sin(phase) * 6,
        origin.dy - 18 * scale,
        origin.dx + i * 6 - 6,
        origin.dy - 32 * scale,
      );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _EspressoMachinePainter oldDelegate) =>
      oldDelegate.phase != phase ||
      oldDelegate.steamT != steamT ||
      oldDelegate.pulseT != pulseT ||
      oldDelegate.showEspressoStream != showEspressoStream ||
      oldDelegate.showMilkStream != showMilkStream;
}
