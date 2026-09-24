import 'package:brew_coffee/core/theme/app_colors.dart';
import 'package:brew_coffee/features/cart/cart_cubit.dart';
import 'package:brew_coffee/features/coffee_customization/customization_cubit.dart';
import 'package:brew_coffee/features/coffee_machine/coffee_machine_cubit.dart';
import 'package:brew_coffee/core/widgets/coffee_cup_view.dart';
import 'package:brew_coffee/domain/entities/cup_visual_state.dart';
import 'package:brew_coffee/domain/entities/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CoffeeMachineScreen extends StatefulWidget {
  const CoffeeMachineScreen({super.key, required this.coffeeId});

  final String coffeeId;

  @override
  State<CoffeeMachineScreen> createState() => _CoffeeMachineScreenState();
}

class _CoffeeMachineScreenState extends State<CoffeeMachineScreen> {
  @override
  void initState() {
    super.initState();
    final customization = context.read<CustomizationCubit>().state.customization;
    if (customization != null) {
      context.read<CoffeeMachineCubit>().startBrew(customization);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoffeeMachineCubit, CoffeeMachineState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.primaryBackground,
          appBar: AppBar(title: const Text('COFFEE MACHINE')),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _MachineFrame(cupVisual: state.cupVisual),
                const SizedBox(height: 24),
                Text(
                  state.phase.operationLabel,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: state.progress,
                  backgroundColor: AppColors.borderDivider,
                  color: AppColors.primaryCoffee,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(state.progress * 100).round()}% · ~${state.estimatedSecondsRemaining}s remaining',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.secondaryText,
                      ),
                ),
                const Spacer(),
                if (state.phase == CoffeeMachinePhase.completed)
                  ElevatedButton(
                    onPressed: () {
                      final c = state.customization;
                      if (c != null) {
                        context.read<CartCubit>().addFromCustomization(c);
                        context.read<CoffeeMachineCubit>().reset();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to cart')),
                        );
                        context.go('/cart');
                      }
                    },
                    child: const Text('ADD TO CART'),
                  )
                else
                  OutlinedButton(
                    onPressed: () => context.pop(),
                    child: const Text('CANCEL'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MachineFrame extends StatelessWidget {
  const _MachineFrame({required this.cupVisual});

  final CupVisualState cupVisual;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 200,
          height: 140,
          decoration: BoxDecoration(
            color: const Color(0xFF5C5C5C),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF333333), width: 3),
          ),
          child: const Center(
            child: Icon(Icons.coffee, color: Colors.white70, size: 48),
          ),
        ),
        Container(width: 60, height: 8, color: const Color(0xFF333333)),
        const SizedBox(height: 16),
        CoffeeCupView(visual: cupVisual, size: 140),
      ],
    );
  }
}
