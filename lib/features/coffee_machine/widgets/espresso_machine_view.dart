import 'dart:math' as math;
import 'dart:ui';

import 'package:brew_coffee/core/theme/app_colors.dart';
import 'package:brew_coffee/core/widgets/coffee_cup_view.dart';
import 'package:brew_coffee/domain/entities/cup_visual_state.dart';
import 'package:brew_coffee/domain/entities/enums.dart';
import 'package:flutter/material.dart';

/// Photo-based machine with light overlays tied to brew phase (no illustrated machine).
class EspressoMachineView extends StatefulWidget {
  const EspressoMachineView({
    super.key,
    required this.phase,
    required this.cupVisual,
  });

  final CoffeeMachinePhase phase;
  final CupVisualState cupVisual;

  @override
  State<EspressoMachineView> createState() => _EspressoMachineViewState();
}

class _EspressoMachineViewState extends State<EspressoMachineView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _steam;

  @override
  void initState() {
    super.initState();
    _steam = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();
  }

  @override
  void dispose() {
    _steam.dispose();
    super.dispose();
  }

  bool get _activeSteam =>
      widget.phase == CoffeeMachinePhase.finalizing ||
      widget.phase == CoffeeMachinePhase.grindingBeans ||
      widget.cupVisual.showSteam;

  bool get _brewingGlow =>
      widget.phase == CoffeeMachinePhase.brewing ||
      widget.phase == CoffeeMachinePhase.addingMilk;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              AspectRatio(
                aspectRatio: 3 / 2,
                child: Image.asset(
                  'assets/images/espresso_machine.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.darkCoffee.withOpacity(0.55),
                      ],
                      stops: const [0.45, 1.0],
                    ),
                  ),
                ),
              ),
              if (_brewingGlow)
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _steam,
                    builder: (context, _) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: const Alignment(0, 0.35),
                            radius: 0.9,
                            colors: [
                              AppColors.caramelAccent
                                  .withOpacity(0.12 + 0.08 * math.sin(_steam.value * math.pi * 2)),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              if (_activeSteam)
                Positioned(
                  top: 24,
                  child: AnimatedBuilder(
                    animation: _steam,
                    builder: (context, _) => _SteamWisp(t: _steam.value),
                  ),
                ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 14,
                child: _PhaseChip(phase: widget.phase),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.borderDivider),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkCoffee.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'Your cup',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.secondaryText,
                      letterSpacing: 1.2,
                    ),
              ),
              const SizedBox(height: 12),
              CoffeeCupView(visual: widget.cupVisual, size: 150),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Photo: Pexels (stock)',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.secondaryText.withOpacity(0.7),
              ),
        ),
      ],
    );
  }
}

class _PhaseChip extends StatelessWidget {
  const _PhaseChip({required this.phase});

  final CoffeeMachinePhase phase;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          color: Colors.black.withOpacity(0.35),
          child: Text(
            phase.operationLabel,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ),
    );
  }
}

class _SteamWisp extends StatelessWidget {
  const _SteamWisp({required this.t});

  final double t;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 48,
      child: CustomPaint(painter: _SteamPainter(t: t)),
    );
  }
}

class _SteamPainter extends CustomPainter {
  _SteamPainter({required this.t});

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (var i = 0; i < 3; i++) {
      final phase = t * math.pi * 2 + i;
      final path = Path();
      path.moveTo(size.width / 2 + (i - 1) * 14, size.height);
      path.quadraticBezierTo(
        size.width / 2 + math.sin(phase) * 8,
        size.height * 0.4,
        size.width / 2 + (i - 1) * 10,
        0,
      );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SteamPainter oldDelegate) => oldDelegate.t != t;
}
