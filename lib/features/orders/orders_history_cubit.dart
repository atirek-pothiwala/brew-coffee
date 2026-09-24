import 'package:brew_coffee/domain/entities/order.dart';
import 'package:brew_coffee/domain/repositories/order_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersHistoryState extends Equatable {
  const OrdersHistoryState({this.loading = false, this.orders = const []});

  final bool loading;
  final List<Order> orders;

  OrdersHistoryState copyWith({bool? loading, List<Order>? orders}) {
    return OrdersHistoryState(
      loading: loading ?? this.loading,
      orders: orders ?? this.orders,
    );
  }

  @override
  List<Object?> get props => [loading, orders];
}

class OrdersHistoryCubit extends Cubit<OrdersHistoryState> {
  OrdersHistoryCubit(this._repository) : super(const OrdersHistoryState());

  final OrderRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(loading: true));
    final orders = await _repository.getOrders();
    emit(state.copyWith(loading: false, orders: orders));
  }
}
