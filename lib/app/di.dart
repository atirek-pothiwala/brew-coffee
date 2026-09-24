import 'package:brew_coffee/data/repositories/local_order_repository.dart';
import 'package:brew_coffee/data/repositories/mock_coffee_repository.dart';
import 'package:brew_coffee/domain/repositories/coffee_repository.dart';
import 'package:brew_coffee/domain/repositories/order_repository.dart';
import 'package:brew_coffee/domain/services/pricing_service.dart';

class AppDependencies {
  AppDependencies({
    CoffeeRepository? coffeeRepository,
    OrderRepository? orderRepository,
    PricingService? pricingService,
  })  : coffeeRepository = coffeeRepository ?? MockCoffeeRepository(),
        orderRepository = orderRepository ?? LocalOrderRepository(),
        pricingService = pricingService ?? PricingService();

  final CoffeeRepository coffeeRepository;
  final OrderRepository orderRepository;
  final PricingService pricingService;
}
