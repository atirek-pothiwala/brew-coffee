import 'package:brew_coffee/data/mock/catalog_data.dart';
import 'package:brew_coffee/domain/entities/coffee.dart';
import 'package:brew_coffee/domain/entities/enums.dart';
import 'package:brew_coffee/domain/repositories/coffee_repository.dart';

class MockCoffeeRepository implements CoffeeRepository {
  @override
  Future<List<Coffee>> getAllCoffees() async => CatalogData.coffees;

  @override
  Future<Coffee?> getCoffeeById(String id) async {
    for (final coffee in CatalogData.coffees) {
      if (coffee.id == id) return coffee;
    }
    return null;
  }

  @override
  Future<List<Coffee>> getByCategory(CoffeeCategoryId category) async {
    return CatalogData.coffees.where((c) => c.category == category).toList();
  }

  @override
  Future<List<Coffee>> getFeatured() async {
    return CatalogData.coffees.where((c) => c.isFeatured).toList();
  }

  @override
  Future<List<Coffee>> getPopular() async {
    return CatalogData.coffees.where((c) => c.isPopular).toList();
  }

  @override
  Future<Coffee?> getSeasonal() async {
    for (final coffee in CatalogData.coffees) {
      if (coffee.isSeasonal) return coffee;
    }
    return CatalogData.coffees.first;
  }
}
