import 'dart:convert';

import 'package:brew_coffee/domain/entities/cart_item.dart';
import 'package:brew_coffee/domain/entities/coffee.dart';
import 'package:brew_coffee/domain/entities/coffee_customization.dart';
import 'package:brew_coffee/domain/entities/enums.dart';
import 'package:brew_coffee/domain/entities/order.dart';
import 'package:brew_coffee/domain/repositories/order_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalOrderRepository implements OrderRepository {
  static const _storageKey = 'brew_coffee_orders_v1';

  @override
  Future<List<Order>> getOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_storageKey) ?? [];
    return raw.map(_decodeOrder).whereType<Order>().toList();
  }

  @override
  Future<Order?> getOrderById(String id) async {
    final orders = await getOrders();
    for (final order in orders) {
      if (order.id == id) return order;
    }
    return null;
  }

  @override
  Future<void> saveOrder(Order order) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_storageKey) ?? [];
    existing.insert(0, jsonEncode(_encodeOrder(order)));
    await prefs.setStringList(_storageKey, existing);
  }

  @override
  Future<void> updateOrder(Order order) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_storageKey) ?? [];
    final updated = existing.map((entry) {
      final map = jsonDecode(entry) as Map<String, dynamic>;
      if (map['id'] == order.id) {
        return jsonEncode(_encodeOrder(order));
      }
      return entry;
    }).toList();
    await prefs.setStringList(_storageKey, updated);
  }

  static Map<String, dynamic> _encodeOrder(Order order) => {
        'id': order.id,
        'displayNumber': order.displayNumber,
        'createdAt': order.createdAt.toIso8601String(),
        'subtotal': order.subtotal,
        'tax': order.tax,
        'serviceFee': order.serviceFee,
        'total': order.total,
        'paymentMethod': order.paymentMethod.name,
        'fulfillmentType': order.fulfillmentType.name,
        'customerName': order.customerName,
        'customerEmail': order.customerEmail,
        'statusStep': order.statusStep.name,
        'items': order.items.map(_encodeCartItem).toList(),
      };

  static Map<String, dynamic> _encodeCartItem(CartItem item) => {
        'id': item.id,
        'quantity': item.quantity,
        'customization': {
          'coffeeId': item.customization.coffee.id,
          'coffeeName': item.customization.coffee.name,
          'basePrice': item.customization.coffee.basePrice,
          'category': item.customization.coffee.category.name,
          'description': item.customization.coffee.description,
          'gradientStart': item.customization.coffee.imageGradientStart,
          'gradientEnd': item.customization.coffee.imageGradientEnd,
          'size': item.customization.size.name,
          'milk': item.customization.milk.name,
          'sugar': item.customization.sugarPortions,
          'temperature': item.customization.temperature.name,
          'extraShot': item.customization.extraShot.name,
          'flavor': item.customization.flavor.name,
          'topping': item.customization.topping.name,
          'unitPrice': item.customization.unitPrice,
        },
      };

  static Order? _decodeOrder(String raw) {
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final items = (map['items'] as List<dynamic>)
          .map((e) => _decodeCartItem(e as Map<String, dynamic>))
          .toList();
      return Order(
        id: map['id'] as String,
        displayNumber: map['displayNumber'] as String,
        createdAt: DateTime.parse(map['createdAt'] as String),
        items: items,
        subtotal: map['subtotal'] as int,
        tax: map['tax'] as int,
        serviceFee: map['serviceFee'] as int,
        total: map['total'] as int,
        paymentMethod: PaymentMethod.values.byName(map['paymentMethod'] as String),
        fulfillmentType:
            FulfillmentType.values.byName(map['fulfillmentType'] as String),
        customerName: map['customerName'] as String,
        customerEmail: map['customerEmail'] as String,
        statusStep: OrderStatusStep.values.byName(map['statusStep'] as String),
      );
    } catch (_) {
      return null;
    }
  }

  static CartItem _decodeCartItem(Map<String, dynamic> map) {
    final c = map['customization'] as Map<String, dynamic>;
    final coffee = Coffee(
      id: c['coffeeId'] as String,
      name: c['coffeeName'] as String,
      description: c['description'] as String,
      category: CoffeeCategoryId.values.byName(c['category'] as String),
      basePrice: c['basePrice'] as int,
      imageGradientStart: c['gradientStart'] as int,
      imageGradientEnd: c['gradientEnd'] as int,
    );
    final customization = CoffeeCustomization(
      coffee: coffee,
      size: CoffeeSize.values.byName(c['size'] as String),
      milk: MilkType.values.byName(c['milk'] as String),
      sugarPortions: c['sugar'] as int,
      temperature: Temperature.values.byName(c['temperature'] as String),
      extraShot: ExtraShot.values.byName(c['extraShot'] as String),
      flavor: Flavor.values.byName(c['flavor'] as String),
      topping: Topping.values.byName(c['topping'] as String),
      unitPrice: c['unitPrice'] as int,
    );
    return CartItem(
      id: map['id'] as String,
      quantity: map['quantity'] as int,
      customization: customization,
    );
  }
}
