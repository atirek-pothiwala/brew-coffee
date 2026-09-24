import 'dart:async';

import 'package:brew_coffee/domain/entities/enums.dart';
import 'package:brew_coffee/domain/entities/order.dart';
import 'package:brew_coffee/domain/repositories/order_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderFulfillmentState extends Equatable {
  const OrderFulfillmentState({
    this.order,
    this.loading = false,
  });

  final Order? order;
  final bool loading;

  OrderFulfillmentState copyWith({Order? order, bool? loading}) {
    return OrderFulfillmentState(
      order: order ?? this.order,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object?> get props => [order, loading];
}

class OrderFulfillmentCubit extends Cubit<OrderFulfillmentState> {
  OrderFulfillmentCubit(this._repository) : super(const OrderFulfillmentState());

  final OrderRepository _repository;
  Timer? _timer;

  static const _steps = OrderStatusStep.values;

  Future<void> load(String orderId) async {
    emit(state.copyWith(loading: true));
    final order = await _repository.getOrderById(orderId);
    emit(state.copyWith(order: order, loading: false));
    if (order != null && order.statusStep != OrderStatusStep.readyForPickup) {
      _scheduleAdvance(order);
    }
  }

  void _scheduleAdvance(Order order) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) async {
      final current = state.order;
      if (current == null) return;
      final idx = _steps.indexOf(current.statusStep);
      if (idx < 0 || idx >= _steps.length - 1) {
        _timer?.cancel();
        return;
      }
      final next = current.copyWith(statusStep: _steps[idx + 1]);
      await _repository.updateOrder(next);
      emit(state.copyWith(order: next));
      if (next.statusStep == OrderStatusStep.readyForPickup) {
        _timer?.cancel();
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
