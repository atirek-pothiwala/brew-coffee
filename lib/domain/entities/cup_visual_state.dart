import 'package:brew_coffee/domain/entities/enums.dart';
import 'package:equatable/equatable.dart';

class CupVisualState extends Equatable {
  const CupVisualState({
    this.espressoLevel = 0,
    this.milkLevel = 0,
    this.milkOpacity = 0,
    this.liquidColor = 0xFF3B2418,
    this.showSteam = false,
    this.showWhippedCream = false,
    this.showCinnamon = false,
    this.showCocoa = false,
    this.showCaramelDrizzle = false,
  });

  final double espressoLevel;
  final double milkLevel;
  final double milkOpacity;
  final int liquidColor;
  final bool showSteam;
  final bool showWhippedCream;
  final bool showCinnamon;
  final bool showCocoa;
  final bool showCaramelDrizzle;

  /// Live preview on the customization receipt (filled cup + selected topping).
  factory CupVisualState.customizationPreview({
    required MilkType milk,
    required Temperature temperature,
    required Topping topping,
  }) {
    final hasMilk = milk != MilkType.none;
    final base = CupVisualState(
      espressoLevel: 0.52,
      milkLevel: hasMilk ? 0.38 : 0.14,
      milkOpacity: hasMilk ? 0.55 : 0.25,
      liquidColor: temperature == Temperature.iced ? 0xFF6B4E3D : 0xFF8B6046,
      showSteam: temperature != Temperature.iced,
    );
    return base.withTopping(topping);
  }

  CupVisualState withTopping(Topping topping) {
    return copyWith(
      showWhippedCream: topping == Topping.whippedCream,
      showCinnamon: topping == Topping.cinnamon,
      showCocoa: topping == Topping.cocoa,
      showCaramelDrizzle: topping == Topping.caramelDrizzle,
    );
  }

  CupVisualState copyWith({
    double? espressoLevel,
    double? milkLevel,
    double? milkOpacity,
    int? liquidColor,
    bool? showSteam,
    bool? showWhippedCream,
    bool? showCinnamon,
    bool? showCocoa,
    bool? showCaramelDrizzle,
  }) {
    return CupVisualState(
      espressoLevel: espressoLevel ?? this.espressoLevel,
      milkLevel: milkLevel ?? this.milkLevel,
      milkOpacity: milkOpacity ?? this.milkOpacity,
      liquidColor: liquidColor ?? this.liquidColor,
      showSteam: showSteam ?? this.showSteam,
      showWhippedCream: showWhippedCream ?? this.showWhippedCream,
      showCinnamon: showCinnamon ?? this.showCinnamon,
      showCocoa: showCocoa ?? this.showCocoa,
      showCaramelDrizzle: showCaramelDrizzle ?? this.showCaramelDrizzle,
    );
  }

  @override
  List<Object?> get props => [
        espressoLevel,
        milkLevel,
        milkOpacity,
        liquidColor,
        showSteam,
        showWhippedCream,
        showCinnamon,
        showCocoa,
        showCaramelDrizzle,
      ];
}
