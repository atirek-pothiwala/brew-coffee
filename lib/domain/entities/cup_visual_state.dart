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
        showSteam,
        showWhippedCream,
      ];
}
