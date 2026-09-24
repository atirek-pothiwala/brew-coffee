import 'package:brew_coffee/core/constants/app_constants.dart';
import 'package:brew_coffee/domain/entities/cart_item.dart';
import 'package:brew_coffee/domain/entities/coffee_customization.dart';
import 'package:brew_coffee/domain/services/pricing_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartTotals extends Equatable {
  const CartTotals({
    required this.itemCount,
    required this.subtotal,
    required this.tax,
    required this.serviceFee,
    required this.total,
  });

  final int itemCount;
  final int subtotal;
  final int tax;
  final int serviceFee;
  final int total;

  @override
  List<Object?> get props => [itemCount, subtotal, tax, serviceFee, total];
}

class CartState extends Equatable {
  const CartState({this.items = const []});

  final List<CartItem> items;

  CartTotals get totals {
    final pricing = PricingService();
    final subtotal =
        pricing.cartSubtotal(items.map((i) => i.lineTotal).toList());
    final tax = pricing.taxFromSubtotal(subtotal, AppConstants.taxRate);
    final serviceFee =
        pricing.serviceFeeFromSubtotal(subtotal, AppConstants.serviceFeeRate);
    final count = items.fold<int>(0, (a, i) => a + i.quantity);
    return CartTotals(
      itemCount: count,
      subtotal: subtotal,
      tax: tax,
      serviceFee: serviceFee,
      total: subtotal + tax + serviceFee,
    );
  }

  CartState copyWith({List<CartItem>? items}) => CartState(items: items ?? this.items);

  @override
  List<Object?> get props => [items];
}

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addFromCustomization(CoffeeCustomization customization) {
    final items = List<CartItem>.from(state.items);
    final existing = items.indexWhere(
      (i) => i.customization == customization,
    );
    if (existing >= 0) {
      items[existing] = items[existing].copyWith(
        quantity: items[existing].quantity + 1,
      );
    } else {
      items.add(CartItem(customization: customization));
    }
    emit(state.copyWith(items: items));
  }

  void increment(String id) {
    final items = state.items.map((i) {
      if (i.id == id) return i.copyWith(quantity: i.quantity + 1);
      return i;
    }).toList();
    emit(state.copyWith(items: items));
  }

  void decrement(String id) {
    final items = <CartItem>[];
    for (final i in state.items) {
      if (i.id == id) {
        if (i.quantity > 1) {
          items.add(i.copyWith(quantity: i.quantity - 1));
        }
      } else {
        items.add(i);
      }
    }
    emit(state.copyWith(items: items));
  }

  void remove(String id) {
    emit(state.copyWith(
      items: state.items.where((i) => i.id != id).toList(),
    ));
  }

  void updateItem(String id, CoffeeCustomization customization) {
    final items = state.items.map((i) {
      if (i.id == id) return i.copyWith(customization: customization);
      return i;
    }).toList();
    emit(state.copyWith(items: items));
  }

  void clear() => emit(const CartState());
}
