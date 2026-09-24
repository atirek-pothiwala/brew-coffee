import 'package:brew_coffee/core/widgets/receipt/receipt_divider.dart';
import 'package:brew_coffee/core/widgets/receipt/receipt_header.dart';
import 'package:brew_coffee/core/widgets/receipt/receipt_line_widgets.dart';
import 'package:brew_coffee/core/widgets/receipt/receipt_paper.dart';
import 'package:brew_coffee/core/widgets/receipt/receipt_scaffold.dart';
import 'package:brew_coffee/core/widgets/receipt/receipt_status_list.dart';
import 'package:brew_coffee/core/widgets/receipt/receipt_zigzag_bottom.dart';
import 'package:brew_coffee/features/orders/order_fulfillment_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderFulfillmentCubit, OrderFulfillmentState>(
      builder: (context, state) {
        final order = state.order;
        return ReceiptScaffold(
          appBarTitle: 'Track order',
          onBack: () => context.pop(),
          child: order == null
              ? const CircularProgressIndicator()
              : Column(
                  children: [
                    ReceiptPaper(
                      child: Column(
                        children: [
                          ReceiptHeader(
                            orderNumber: order.displayNumber,
                            dateTime: order.createdAt,
                          ),
                          ReceiptStatusList(current: order.statusStep),
                          const ReceiptDivider(),
                          for (final item in order.items)
                            ReceiptLineItem(
                              title: item.customization.coffee.name,
                              price: item.lineTotal,
                            ),
                          ReceiptRowTotal(
                            label: 'TOTAL',
                            amount: order.total,
                            emphasize: true,
                          ),
                        ],
                      ),
                    ),
                    const ReceiptZigzagBottom(),
                  ],
                ),
        );
      },
    );
  }
}
