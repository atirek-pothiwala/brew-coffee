import 'package:brew_coffee/domain/entities/cart_item.dart';
import 'package:brew_coffee/domain/entities/enums.dart';
import 'package:brew_coffee/domain/entities/order.dart';
import 'package:brew_coffee/domain/repositories/order_repository.dart';
import 'package:brew_coffee/features/cart/cart_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class CheckoutState extends Equatable {
  const CheckoutState({
    this.customerName = '',
    this.customerEmail = '',
    this.fulfillmentType = FulfillmentType.pickup,
    this.paymentMethod = PaymentMethod.demoCard,
    this.placing = false,
    this.placedOrder,
    this.error,
  });

  final String customerName;
  final String customerEmail;
  final FulfillmentType fulfillmentType;
  final PaymentMethod paymentMethod;
  final bool placing;
  final Order? placedOrder;
  final String? error;

  CheckoutState copyWith({
    String? customerName,
    String? customerEmail,
    FulfillmentType? fulfillmentType,
    PaymentMethod? paymentMethod,
    bool? placing,
    Order? placedOrder,
    String? error,
  }) {
    return CheckoutState(
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      fulfillmentType: fulfillmentType ?? this.fulfillmentType,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      placing: placing ?? this.placing,
      placedOrder: placedOrder ?? this.placedOrder,
      error: error,
    );
  }

  @override
  List<Object?> get props =>
      [customerName, customerEmail, fulfillmentType, paymentMethod, placing, placedOrder];
}

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit(this._orderRepository) : super(const CheckoutState());

  final OrderRepository _orderRepository;
  static int _orderSeq = 1024;

  void setName(String v) => emit(state.copyWith(customerName: v));
  void setEmail(String v) => emit(state.copyWith(customerEmail: v));
  void setFulfillment(FulfillmentType v) =>
      emit(state.copyWith(fulfillmentType: v));
  void setPayment(PaymentMethod v) => emit(state.copyWith(paymentMethod: v));

  Future<Order?> placeOrder(CartState cart) async {
    if (cart.items.isEmpty) {
      emit(state.copyWith(error: 'Cart is empty'));
      return null;
    }
    if (state.customerName.trim().isEmpty) {
      emit(state.copyWith(error: 'Please enter your name'));
      return null;
    }
    emit(state.copyWith(placing: true, error: null));
    final totals = cart.totals;
    final displayNumber = 'BRW-${_orderSeq++}';
    final order = Order(
      id: const Uuid().v4(),
      displayNumber: displayNumber,
      createdAt: DateTime.now(),
      items: List<CartItem>.from(cart.items),
      subtotal: totals.subtotal,
      tax: totals.tax,
      serviceFee: totals.serviceFee,
      total: totals.total,
      paymentMethod: state.paymentMethod,
      fulfillmentType: state.fulfillmentType,
      customerName: state.customerName.trim(),
      customerEmail: state.customerEmail.trim(),
      statusStep: OrderStatusStep.orderReceived,
    );
    await _orderRepository.saveOrder(order);
    emit(state.copyWith(placing: false, placedOrder: order));
    return order;
  }

  void reset() => emit(const CheckoutState());
}
