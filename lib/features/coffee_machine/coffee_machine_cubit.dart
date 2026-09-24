import 'dart:async';

import 'package:brew_coffee/domain/entities/coffee_customization.dart';
import 'package:brew_coffee/domain/entities/cup_visual_state.dart';
import 'package:brew_coffee/domain/entities/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoffeeMachineState extends Equatable {
  const CoffeeMachineState({
    this.phase = CoffeeMachinePhase.idle,
    this.progress = 0,
    this.estimatedSecondsRemaining = 0,
    this.cupVisual = const CupVisualState(),
    this.customization,
    this.errorMessage,
  });

  final CoffeeMachinePhase phase;
  final double progress;
  final int estimatedSecondsRemaining;
  final CupVisualState cupVisual;
  final CoffeeCustomization? customization;
  final String? errorMessage;

  CoffeeMachineState copyWith({
    CoffeeMachinePhase? phase,
    double? progress,
    int? estimatedSecondsRemaining,
    CupVisualState? cupVisual,
    CoffeeCustomization? customization,
    String? errorMessage,
  }) {
    return CoffeeMachineState(
      phase: phase ?? this.phase,
      progress: progress ?? this.progress,
      estimatedSecondsRemaining:
          estimatedSecondsRemaining ?? this.estimatedSecondsRemaining,
      cupVisual: cupVisual ?? this.cupVisual,
      customization: customization ?? this.customization,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [phase, progress, estimatedSecondsRemaining, cupVisual, customization];
}

class CoffeeMachineCubit extends Cubit<CoffeeMachineState> {
  CoffeeMachineCubit({Duration? phaseTick})
      : _phaseTick = phaseTick ?? const Duration(seconds: 1),
        super(const CoffeeMachineState());

  final Duration _phaseTick;

  static const _phaseDurations = {
    CoffeeMachinePhase.preparing: 1,
    CoffeeMachinePhase.grindingBeans: 2,
    CoffeeMachinePhase.brewing: 3,
    CoffeeMachinePhase.addingMilk: 2,
    CoffeeMachinePhase.addingFlavor: 2,
    CoffeeMachinePhase.addingToppings: 2,
    CoffeeMachinePhase.finalizing: 1,
  };

  static const _sequence = [
    CoffeeMachinePhase.preparing,
    CoffeeMachinePhase.grindingBeans,
    CoffeeMachinePhase.brewing,
    CoffeeMachinePhase.addingMilk,
    CoffeeMachinePhase.addingFlavor,
    CoffeeMachinePhase.addingToppings,
    CoffeeMachinePhase.finalizing,
    CoffeeMachinePhase.completed,
  ];

  bool _cancelled = false;

  Future<void> startBrew(CoffeeCustomization customization) async {
    _cancelled = false;
    emit(CoffeeMachineState(
      phase: CoffeeMachinePhase.preparing,
      progress: 0,
      customization: customization,
      cupVisual: const CupVisualState(),
    ));

    final totalSeconds = _phaseDurations.values.fold<int>(0, (a, b) => a + b);
    var elapsed = 0;

    for (final phase in _sequence) {
      if (_cancelled) return;
      if (phase == CoffeeMachinePhase.completed) {
        emit(state.copyWith(
          phase: CoffeeMachinePhase.completed,
          progress: 1,
          estimatedSecondsRemaining: 0,
          cupVisual: _cupForPhase(phase, customization),
        ));
        return;
      }

      final duration = _phaseDurations[phase] ?? 1;
      for (var s = 0; s < duration; s++) {
        if (_cancelled) return;
        await Future<void>.delayed(_phaseTick);
        elapsed += 1;
        final progress = elapsed / totalSeconds;
        emit(state.copyWith(
          phase: phase,
          progress: progress.clamp(0, 0.99),
          estimatedSecondsRemaining: totalSeconds - elapsed,
          cupVisual: _cupForPhase(phase, customization),
        ));
      }
    }
  }

  CupVisualState _cupForPhase(
    CoffeeMachinePhase phase,
    CoffeeCustomization customization,
  ) {
    switch (phase) {
      case CoffeeMachinePhase.preparing:
        return const CupVisualState();
      case CoffeeMachinePhase.grindingBeans:
        return const CupVisualState(showSteam: true);
      case CoffeeMachinePhase.brewing:
        return const CupVisualState(espressoLevel: 0.55, showSteam: true);
      case CoffeeMachinePhase.addingMilk:
        return CupVisualState(
          espressoLevel: 0.55,
          milkLevel: customization.milk == MilkType.none ? 0 : 0.35,
          milkOpacity: 0.5,
          liquidColor: 0xFF6B4E3D,
          showSteam: true,
        );
      case CoffeeMachinePhase.addingFlavor:
        return CupVisualState(
          espressoLevel: 0.55,
          milkLevel: 0.4,
          milkOpacity: 0.55,
          liquidColor: 0xFF8B6046,
        );
      case CoffeeMachinePhase.addingToppings:
        return CupVisualState(
          espressoLevel: 0.55,
          milkLevel: 0.4,
          milkOpacity: 0.55,
          liquidColor: 0xFF8B6046,
          showWhippedCream: customization.topping == Topping.whippedCream,
          showCinnamon: customization.topping == Topping.cinnamon,
          showCocoa: customization.topping == Topping.cocoa,
          showCaramelDrizzle: customization.topping == Topping.caramelDrizzle,
        );
      case CoffeeMachinePhase.finalizing:
      case CoffeeMachinePhase.completed:
        return CupVisualState(
          espressoLevel: 0.55,
          milkLevel: 0.42,
          milkOpacity: 0.6,
          liquidColor: 0xFF8B6046,
          showWhippedCream: customization.topping == Topping.whippedCream,
          showCinnamon: customization.topping == Topping.cinnamon,
          showCocoa: customization.topping == Topping.cocoa,
          showCaramelDrizzle: customization.topping == Topping.caramelDrizzle,
        );
      default:
        return const CupVisualState();
    }
  }

  void reset() {
    _cancelled = true;
    emit(const CoffeeMachineState());
  }

  @override
  Future<void> close() {
    _cancelled = true;
    return super.close();
  }
}
