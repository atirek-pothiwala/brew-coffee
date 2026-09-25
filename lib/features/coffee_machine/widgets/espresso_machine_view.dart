import 'package:brew_coffee/core/theme/app_colors.dart';
import 'package:brew_coffee/core/widgets/coffee_cup_view.dart';
import 'package:brew_coffee/domain/entities/cup_visual_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Static flat machine artwork and cup (brew progress shown via text/progress bar).
class EspressoMachineView extends StatelessWidget {
  const EspressoMachineView({
    super.key,
    required this.cupVisual,
  });

  final CupVisualState cupVisual;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.cardBackground,
            border: Border.all(color: AppColors.borderDivider),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SvgPicture.asset(
              'assets/images/espresso_machine_flat.svg',
              width: 320,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 24),
        CoffeeCupView(visual: cupVisual, size: 150),
      ],
    );
  }
}
