import 'package:brew_coffee/domain/entities/coffee.dart';
import 'package:brew_coffee/domain/entities/enums.dart';

abstract class CoffeeRepository {
  Future<List<Coffee>> getAllCoffees();
  Future<Coffee?> getCoffeeById(String id);
  Future<List<Coffee>> getByCategory(CoffeeCategoryId category);
  Future<List<Coffee>> getFeatured();
  Future<List<Coffee>> getPopular();
  Future<Coffee?> getSeasonal();
}
