import 'package:brew_coffee/domain/entities/order.dart';

abstract class OrderRepository {
  Future<List<Order>> getOrders();
  Future<Order?> getOrderById(String id);
  Future<void> saveOrder(Order order);
  Future<void> updateOrder(Order order);
}
