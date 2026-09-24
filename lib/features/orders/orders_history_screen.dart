import 'package:brew_coffee/core/theme/receipt_theme.dart';
import 'package:brew_coffee/core/utils/currency_format.dart';
import 'package:brew_coffee/core/widgets/app_shell.dart';
import 'package:brew_coffee/core/widgets/receipt/receipt_paper.dart';
import 'package:brew_coffee/domain/entities/order.dart';
import 'package:brew_coffee/features/orders/orders_history_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class OrdersHistoryScreen extends StatelessWidget {
  const OrdersHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OrdersHistoryCubit>().state;

    return Scaffold(
      appBar: const BrewAppBar(showCart: true),
      body: state.loading
          ? const Center(child: CircularProgressIndicator())
          : state.orders.isEmpty
              ? const Center(child: Text('No orders yet — your receipt stack is empty.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: state.orders.length,
                  itemBuilder: (context, index) {
                    final order = state.orders[index];
                    return _StackedReceiptPreview(
                      order: order,
                      index: index,
                      onTap: () => context.go('/orders/${order.id}'),
                    );
                  },
                ),
    );
  }
}

class _StackedReceiptPreview extends StatelessWidget {
  const _StackedReceiptPreview({
    required this.order,
    required this.index,
    required this.onTap,
  });

  final Order order;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd MMM yyyy').format(order.createdAt);
    return Transform.translate(
      offset: Offset(index.isEven ? 2.0 * index : -2.0 * index, 0),
      child: Transform.rotate(
        angle: index.isEven ? 0.01 : -0.01,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: InkWell(
            onTap: onTap,
            child: ReceiptPaper(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ORDER #${order.displayNumber}', style: ReceiptTheme.meta(context)),
                  Text(date, style: ReceiptTheme.meta(context)),
                  const SizedBox(height: 8),
                  Text(
                    order.items.map((i) => i.customization.coffee.name).join(', '),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: ReceiptTheme.lineDetail(context),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatCurrency(order.total),
                    style: ReceiptTheme.totalLabel(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
