import 'package:brew_coffee/domain/entities/coffee.dart';
import 'package:brew_coffee/domain/entities/coffee_customization.dart';
import 'package:brew_coffee/domain/entities/enums.dart';
import 'package:brew_coffee/domain/repositories/coffee_repository.dart';
import 'package:brew_coffee/domain/services/pricing_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomizationState extends Equatable {
  const CustomizationState({
    this.loading = false,
    this.coffee,
    this.customization,
    this.error,
  });

  final bool loading;
  final Coffee? coffee;
  final CoffeeCustomization? customization;
  final String? error;

  CustomizationState copyWith({
    bool? loading,
    Coffee? coffee,
    CoffeeCustomization? customization,
    String? error,
  }) {
    return CustomizationState(
      loading: loading ?? this.loading,
      coffee: coffee ?? this.coffee,
      customization: customization ?? this.customization,
      error: error,
    );
  }

  @override
  List<Object?> get props => [loading, coffee, customization, error];
}

class CustomizationCubit extends Cubit<CustomizationState> {
  CustomizationCubit(this._repository, this._pricing)
      : super(const CustomizationState());

  final CoffeeRepository _repository;
  final PricingService _pricing;

  Future<void> load(String coffeeId, {CoffeeCustomization? initial}) async {
    emit(state.copyWith(loading: true, error: null));
    final coffee = await _repository.getCoffeeById(coffeeId);
    if (coffee == null) {
      emit(state.copyWith(loading: false, error: 'Coffee not found'));
      return;
    }
    final base = initial ??
        CoffeeCustomization(
          coffee: coffee,
          unitPrice: 0,
        );
    final priced = _pricing.withPrice(coffee, base);
    emit(state.copyWith(loading: false, coffee: coffee, customization: priced));
  }

  void updateSize(CoffeeSize size) => _apply(state.customization!.copyWith(size: size));
  void updateMilk(MilkType milk) => _apply(state.customization!.copyWith(milk: milk));
  void updateSugar(int portions) =>
      _apply(state.customization!.copyWith(sugarPortions: portions.clamp(0, 4)));
  void updateTemperature(Temperature temperature) =>
      _apply(state.customization!.copyWith(temperature: temperature));
  void updateExtraShot(ExtraShot shot) =>
      _apply(state.customization!.copyWith(extraShot: shot));
  void updateFlavor(Flavor flavor) =>
      _apply(state.customization!.copyWith(flavor: flavor));
  void updateTopping(Topping topping) =>
      _apply(state.customization!.copyWith(topping: topping));

  void _apply(CoffeeCustomization draft) {
    final coffee = state.coffee!;
    final priced = _pricing.withPrice(coffee, draft);
    emit(state.copyWith(customization: priced));
  }
}
