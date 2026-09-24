import 'package:brew_coffee/domain/entities/coffee.dart';
import 'package:brew_coffee/domain/entities/enums.dart';
import 'package:equatable/equatable.dart';

class CoffeeCustomization extends Equatable {
  const CoffeeCustomization({
    required this.coffee,
    this.size = CoffeeSize.medium,
    this.milk = MilkType.whole,
    this.sugarPortions = 0,
    this.temperature = Temperature.hot,
    this.extraShot = ExtraShot.none,
    this.flavor = Flavor.none,
    this.topping = Topping.none,
    required this.unitPrice,
  });

  final Coffee coffee;
  final CoffeeSize size;
  final MilkType milk;
  final int sugarPortions;
  final Temperature temperature;
  final ExtraShot extraShot;
  final Flavor flavor;
  final Topping topping;
  final int unitPrice;

  CoffeeCustomization copyWith({
    CoffeeSize? size,
    MilkType? milk,
    int? sugarPortions,
    Temperature? temperature,
    ExtraShot? extraShot,
    Flavor? flavor,
    Topping? topping,
    int? unitPrice,
  }) {
    return CoffeeCustomization(
      coffee: coffee,
      size: size ?? this.size,
      milk: milk ?? this.milk,
      sugarPortions: sugarPortions ?? this.sugarPortions,
      temperature: temperature ?? this.temperature,
      extraShot: extraShot ?? this.extraShot,
      flavor: flavor ?? this.flavor,
      topping: topping ?? this.topping,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }

  List<String> summaryLines() {
    final lines = <String>[
      size.label,
      milk.label,
      if (sugarPortions > 0) 'Sugar × $sugarPortions',
      temperature.label,
      if (extraShot != ExtraShot.none) extraShot.label,
      if (flavor != Flavor.none) flavor.label,
      if (topping != Topping.none) topping.label,
    ];
    return lines;
  }

  @override
  List<Object?> get props => [
        coffee.id,
        size,
        milk,
        sugarPortions,
        temperature,
        extraShot,
        flavor,
        topping,
      ];
}
