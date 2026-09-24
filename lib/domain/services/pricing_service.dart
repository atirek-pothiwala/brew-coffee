import 'package:brew_coffee/domain/entities/coffee.dart';
import 'package:brew_coffee/domain/entities/coffee_customization.dart';
import 'package:brew_coffee/domain/entities/enums.dart';

class PricingConfig {
  const PricingConfig({
    this.sizeMultiplier = const {
      CoffeeSize.small: 0.85,
      CoffeeSize.medium: 1.0,
      CoffeeSize.large: 1.2,
    },
    this.milkSurcharge = const {
      MilkType.whole: 0,
      MilkType.oat: 20,
      MilkType.almond: 25,
      MilkType.soy: 15,
      MilkType.none: 0,
    },
    this.extraShotPrice = const {ExtraShot.none: 0, ExtraShot.one: 30, ExtraShot.two: 55},
    this.flavorPrice = const {
      Flavor.none: 0,
      Flavor.vanilla: 20,
      Flavor.caramel: 20,
      Flavor.hazelnut: 25,
      Flavor.chocolate: 25,
    },
    this.toppingPrice = const {
      Topping.none: 0,
      Topping.whippedCream: 30,
      Topping.cinnamon: 0,
      Topping.cocoa: 15,
      Topping.caramelDrizzle: 20,
    },
    this.icedSurcharge = 15,
  });

  final Map<CoffeeSize, double> sizeMultiplier;
  final Map<MilkType, int> milkSurcharge;
  final Map<ExtraShot, int> extraShotPrice;
  final Map<Flavor, int> flavorPrice;
  final Map<Topping, int> toppingPrice;
  final int icedSurcharge;
}

class PricingService {
  PricingService({PricingConfig? config}) : _config = config ?? const PricingConfig();

  final PricingConfig _config;

  int calculateUnitPrice(Coffee coffee, CoffeeCustomization draft) {
    final base = coffee.basePrice * _config.sizeMultiplier[draft.size]!;
    var total = base.round();
    total += _config.milkSurcharge[draft.milk] ?? 0;
    total += _config.extraShotPrice[draft.extraShot] ?? 0;
    total += _config.flavorPrice[draft.flavor] ?? 0;
    total += _config.toppingPrice[draft.topping] ?? 0;
    if (draft.temperature == Temperature.iced) {
      total += _config.icedSurcharge;
    }
    return total;
  }

  CoffeeCustomization withPrice(Coffee coffee, CoffeeCustomization draft) {
    return draft.copyWith(unitPrice: calculateUnitPrice(coffee, draft));
  }

  int cartSubtotal(List<int> lineTotals) => lineTotals.fold(0, (a, b) => a + b);

  int taxFromSubtotal(int subtotal, double rate) => (subtotal * rate).round();

  int serviceFeeFromSubtotal(int subtotal, double rate) => (subtotal * rate).round();
}
