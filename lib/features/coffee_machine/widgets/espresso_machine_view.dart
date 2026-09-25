import 'package:brew_coffee/core/theme/app_colors.dart';
import 'package:brew_coffee/core/widgets/coffee_cup_view.dart';
import 'package:brew_coffee/domain/entities/cup_visual_state.dart';
import 'package:brew_coffee/domain/entities/enums.dart';
import 'package:brew_coffee/features/coffee_machine/widgets/coffee_pour_stream.dart';
import 'package:brew_coffee/features/coffee_machine/widgets/machine_pour_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Flat machine artwork with a pour stream from the spout into the cup.
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
  late final AnimationController _pourAnim;

  @override
  void initState() {
    super.initState();
    _pourAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat();
  }

  @override
  void dispose() {
    _pourAnim.dispose();
    super.dispose();
  }

  bool get _pouringEspresso => widget.phase == CoffeeMachinePhase.brewing;

  bool get _pouringMilk => widget.phase == CoffeeMachinePhase.addingMilk;

  bool get _isPouring => _pouringEspresso || _pouringMilk;

  Color get _streamColor {
    if (_pouringMilk) {
      return const Color(0xFFF5F0E8);
    }
    return const Color(0xFF3B2418);
  }

  @override
  Widget build(BuildContext context) {
    const w = MachinePourLayout.machineWidth;
    final machineH = MachinePourLayout.machineHeight;
    const cupSize = MachinePourLayout.cupWidth;
    const cupGap = MachinePourLayout.cupGap;
    const cupBlockH = cupSize * 1.1 + 36;
    final totalH = machineH + cupGap + cupBlockH;

    final nozzleX = w * MachinePourLayout.nozzleX;
    final nozzleY = machineH * MachinePourLayout.nozzleY;
    final cupTop = machineH + cupGap;
    final cupLeft = (w - cupSize) / 2;

    return SizedBox(
      width: w,
      height: totalH,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            left: 0,
            width: w,
            height: machineH,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.cardBackground,
                border: Border.all(color: AppColors.borderDivider),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                child: SvgPicture.asset(
                  'assets/images/espresso_machine_flat.svg',
                  fit: BoxFit.contain,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _pourAnim,
            builder: (context, _) {
              return CoffeePourStream(
                top: nozzleY,
                bottom: cupTop + 8,
                centerX: nozzleX,
                color: _streamColor,
                t: _pourAnim.value,
                active: _isPouring,
              );
            },
          ),
          Positioned(
            top: cupTop,
            left: cupLeft,
            width: cupSize,
            child: Column(
              children: [
                CoffeeCupView(visual: widget.cupVisual, size: cupSize),
                const SizedBox(height: 8),
                Text(
                  widget.phase.operationLabel,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.secondaryCoffee,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
