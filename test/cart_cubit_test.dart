import 'package:brew_coffee/core/constants/app_constants.dart';
import 'package:brew_coffee/data/mock/catalog_data.dart';
import 'package:brew_coffee/domain/entities/coffee_customization.dart';
import 'package:brew_coffee/features/cart/cart_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('cart totals include tax and service fee', () {
    final cubit = CartCubit();
    final coffee = CatalogData.coffees.first;
    cubit.addFromCustomization(
      CoffeeCustomization(coffee: coffee, unitPrice: 200),
    );
    final totals = cubit.state.totals;
    expect(totals.subtotal, 200);
    expect(totals.tax, (200 * AppConstants.taxRate).round());
    expect(totals.total, totals.subtotal + totals.tax + totals.serviceFee);
  });
}
