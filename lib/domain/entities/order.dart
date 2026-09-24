import 'package:brew_coffee/domain/entities/cart_item.dart';
import 'package:brew_coffee/domain/entities/enums.dart';
import 'package:equatable/equatable.dart';

class Order extends Equatable {
  const Order({
    required this.id,
    required this.displayNumber,
    required this.createdAt,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.serviceFee,
    required this.total,
    required this.paymentMethod,
    required this.fulfillmentType,
    required this.customerName,
    required this.customerEmail,
    required this.statusStep,
  });

  final String id;
  final String displayNumber;
  final DateTime createdAt;
  final List<CartItem> items;
  final int subtotal;
  final int tax;
  final int serviceFee;
  final int total;
  final PaymentMethod paymentMethod;
  final FulfillmentType fulfillmentType;
  final String customerName;
  final String customerEmail;
  final OrderStatusStep statusStep;

  Order copyWith({OrderStatusStep? statusStep}) {
    return Order(
      id: id,
      displayNumber: displayNumber,
      createdAt: createdAt,
      items: items,
      subtotal: subtotal,
      tax: tax,
      serviceFee: serviceFee,
      total: total,
      paymentMethod: paymentMethod,
      fulfillmentType: fulfillmentType,
      customerName: customerName,
      customerEmail: customerEmail,
      statusStep: statusStep ?? this.statusStep,
    );
  }

  @override
  List<Object?> get props => [id];
}
