import 'package:brew_coffee/core/theme/app_colors.dart';
import 'package:brew_coffee/core/utils/brew_audio_service.dart';
import 'package:brew_coffee/features/cart/cart_cubit.dart';
import 'package:brew_coffee/features/coffee_customization/customization_cubit.dart';
import 'package:brew_coffee/features/coffee_machine/coffee_machine_cubit.dart';
import 'package:brew_coffee/features/coffee_machine/widgets/espresso_machine_view.dart';
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
  final BrewAudioService _audio = BrewAudioService();

  @override
  void initState() {
    super.initState();
    final customization = context.read<CustomizationCubit>().state.customization;
    if (customization != null) {
      context.read<CoffeeMachineCubit>().startBrew(customization);
    }
  }

  @override
  void dispose() {
    _audio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoffeeMachineCubit, CoffeeMachineState>(
      listenWhen: (prev, next) => prev.phase != next.phase,
      listener: (context, state) {
        _audio.onPhaseChanged(state.phase);
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.primaryBackground,
          appBar: AppBar(
            title: const Text('COFFEE MACHINE'),
            actions: [
              IconButton(
                tooltip: _audio.muted ? 'Unmute sounds' : 'Mute sounds',
                onPressed: () {
                  setState(() {
                    _audio.toggleMute();
                    if (_audio.muted) {
                      _audio.onPhaseChanged(CoffeeMachinePhase.idle);
                    } else {
                      _audio.onPhaseChanged(state.phase);
                    }
                  });
                },
                icon: Icon(_audio.muted ? Icons.volume_off : Icons.volume_up),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                EspressoMachineView(
                  phase: state.phase,
                  cupVisual: state.cupVisual,
                  progress: state.progress,
                ),
                const SizedBox(height: 24),
                Text(
                  state.phase.operationLabel,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
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
                const SizedBox(height: 32),
                if (state.phase == CoffeeMachinePhase.completed)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
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
                    ),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        _audio.onPhaseChanged(CoffeeMachinePhase.idle);
                        context.read<CoffeeMachineCubit>().reset();
                        context.pop();
                      },
                      child: const Text('CANCEL'),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
