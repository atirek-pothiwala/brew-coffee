import 'package:brew_coffee/domain/entities/coffee.dart';
import 'package:brew_coffee/domain/entities/enums.dart';
import 'package:brew_coffee/domain/repositories/coffee_repository.dart';

/// Placeholder for future HTTP integration.
class ApiCoffeeRepository implements CoffeeRepository {
  @override
  Future<List<Coffee>> getAllCoffees() => throw UnimplementedError();

  @override
  Future<Coffee?> getCoffeeById(String id) => throw UnimplementedError();

  @override
  Future<List<Coffee>> getByCategory(CoffeeCategoryId category) =>
      throw UnimplementedError();

  @override
  Future<List<Coffee>> getFeatured() => throw UnimplementedError();

  @override
  Future<List<Coffee>> getPopular() => throw UnimplementedError();

  @override
  Future<Coffee?> getSeasonal() => throw UnimplementedError();
}
