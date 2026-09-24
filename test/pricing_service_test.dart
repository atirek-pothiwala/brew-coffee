import 'package:brew_coffee/data/mock/catalog_data.dart';
import 'package:brew_coffee/domain/entities/coffee_customization.dart';
import 'package:brew_coffee/domain/entities/enums.dart';
import 'package:brew_coffee/domain/services/pricing_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final service = PricingService();
  final coffee = CatalogData.coffees.firstWhere((c) => c.id == 'latte-honey');

  test('medium oat latte with extras calculates expected total', () {
    final draft = CoffeeCustomization(
      coffee: coffee,
      size: CoffeeSize.medium,
      milk: MilkType.oat,
      sugarPortions: 2,
      extraShot: ExtraShot.one,
      flavor: Flavor.caramel,
      unitPrice: 0,
    );
    final price = service.calculateUnitPrice(coffee, draft);
    // base 200 + oat 20 + shot 30 + caramel 20 = 270
    expect(price, 270);
  });

  test('large iced adds surcharge', () {
    final draft = CoffeeCustomization(
      coffee: coffee,
      size: CoffeeSize.large,
      temperature: Temperature.iced,
      unitPrice: 0,
    );
    final price = service.calculateUnitPrice(coffee, draft);
    expect(price, greaterThan(coffee.basePrice));
  });
}
