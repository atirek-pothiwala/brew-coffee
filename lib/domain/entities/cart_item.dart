import 'package:brew_coffee/domain/entities/coffee_customization.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class CartItem extends Equatable {
  CartItem({
    required this.customization,
    this.quantity = 1,
    String? id,
  }) : id = id ?? const Uuid().v4();

  final String id;
  final CoffeeCustomization customization;
  final int quantity;

  int get lineTotal => customization.unitPrice * quantity;

  CartItem copyWith({int? quantity, CoffeeCustomization? customization}) {
    return CartItem(
      id: id,
      customization: customization ?? this.customization,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [id, customization, quantity];
}
