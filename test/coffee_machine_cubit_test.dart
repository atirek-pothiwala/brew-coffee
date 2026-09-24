import 'package:brew_coffee/data/mock/catalog_data.dart';
import 'package:brew_coffee/domain/entities/coffee_customization.dart';
import 'package:brew_coffee/domain/entities/enums.dart';
import 'package:brew_coffee/features/coffee_machine/coffee_machine_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('coffee machine reaches completed after full sequence', () async {
    final cubit = CoffeeMachineCubit(phaseTick: const Duration(milliseconds: 1));
    final coffee = CatalogData.coffees.first;
    final customization = CoffeeCustomization(
      coffee: coffee,
      unitPrice: 200,
    );

    await cubit.startBrew(customization);
    expect(cubit.state.phase, CoffeeMachinePhase.completed);
    expect(cubit.state.progress, 1);
    await cubit.close();
  });
}
