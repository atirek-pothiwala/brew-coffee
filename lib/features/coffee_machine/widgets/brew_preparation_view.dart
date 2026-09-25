import 'package:brew_coffee/core/theme/app_colors.dart';
import 'package:brew_coffee/core/utils/currency_format.dart';
import 'package:brew_coffee/core/widgets/coffee_cup_view.dart';
import 'package:brew_coffee/domain/entities/coffee_customization.dart';
import 'package:brew_coffee/domain/entities/cup_visual_state.dart';
import 'package:brew_coffee/domain/entities/enums.dart';
import 'package:flutter/material.dart';

class BrewPreparationView extends StatelessWidget {
  const BrewPreparationView({
    super.key,
    required this.customization,
    required this.cupVisual,
    required this.progress,
    required this.phase,
  });

  final CoffeeCustomization? customization;
  final CupVisualState cupVisual;
  final double progress;
  final CoffeeMachinePhase phase;

  static const _steps = [
    CoffeeMachinePhase.grindingBeans,
    CoffeeMachinePhase.brewing,
    CoffeeMachinePhase.addingMilk,
    CoffeeMachinePhase.addingFlavor,
    CoffeeMachinePhase.addingToppings,
    CoffeeMachinePhase.finalizing,
    CoffeeMachinePhase.completed,
  ];

  @override
  Widget build(BuildContext context) {
    final c = customization;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (c != null) _DrinkSummaryCard(customization: c),
        const SizedBox(height: 28),
        Center(
          child: SizedBox(
            width: 240,
            height: 240,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 220,
                  height: 220,
                  child: CircularProgressIndicator(
                    value: progress > 0 ? progress : null,
                    strokeWidth: 7,
                    backgroundColor: AppColors.borderDivider,
                    color: AppColors.primaryCoffee,
                  ),
                ),
                CoffeeCupView(visual: cupVisual, size: 150),
              ],
            ),
          ),
        ),
        const SizedBox(height: 28),
        _PhaseTimeline(current: phase),
      ],
    );
  }
}

class _DrinkSummaryCard extends StatelessWidget {
  const _DrinkSummaryCard({required this.customization});

  final CoffeeCustomization customization;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_cafe, color: AppColors.primaryCoffee),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    customization.coffee.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                Text(
                  formatCurrency(customization.unitPrice),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primaryCoffee,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: customization.summaryLines().map((line) {
                return Chip(
                  label: Text(line),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhaseTimeline extends StatelessWidget {
  const _PhaseTimeline({required this.current});

  final CoffeeMachinePhase current;

  @override
  Widget build(BuildContext context) {
    final currentIndex = switch (current) {
      CoffeeMachinePhase.preparing || CoffeeMachinePhase.idle => -1,
      CoffeeMachinePhase.completed => _steps.length,
      _ => _steps.indexOf(current),
    };
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preparation',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondaryCoffee,
                  ),
            ),
            const SizedBox(height: 8),
            for (var i = 0; i < _steps.length; i++)
              _PhaseRow(
                label: _labelFor(_steps[i]),
                done: currentIndex > i,
                active: currentIndex == i,
              ),
          ],
        ),
      ),
    );
  }

  static String _labelFor(CoffeeMachinePhase phase) {
    return switch (phase) {
      CoffeeMachinePhase.grindingBeans => 'Grind beans',
      CoffeeMachinePhase.brewing => 'Pull espresso',
      CoffeeMachinePhase.addingMilk => 'Steam milk',
      CoffeeMachinePhase.addingFlavor => 'Add flavour',
      CoffeeMachinePhase.addingToppings => 'Finish toppings',
      CoffeeMachinePhase.finalizing => 'Final touches',
      CoffeeMachinePhase.completed => 'Ready',
      _ => phase.operationLabel,
    };
  }

  static const _steps = BrewPreparationView._steps;
}

class _PhaseRow extends StatelessWidget {
  const _PhaseRow({
    required this.label,
    required this.done,
    required this.active,
  });

  final String label;
  final bool done;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final icon = done
        ? Icons.check_circle
        : active
            ? Icons.radio_button_checked
            : Icons.radio_button_off;
    final color = done
        ? AppColors.success
        : active
            ? AppColors.primaryCoffee
            : AppColors.secondaryText;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                  color: active ? AppColors.primaryText : AppColors.secondaryText,
                ),
          ),
        ],
      ),
    );
  }
}
