import 'package:brew_coffee/core/widgets/receipt/receipt_divider.dart';
import 'package:brew_coffee/core/widgets/receipt/receipt_header.dart';
import 'package:brew_coffee/core/widgets/receipt/receipt_line_widgets.dart';
import 'package:brew_coffee/core/widgets/receipt/receipt_paper.dart';
import 'package:brew_coffee/core/widgets/receipt/receipt_scaffold.dart';
import 'package:brew_coffee/core/widgets/receipt/receipt_zigzag_bottom.dart';
import 'package:brew_coffee/domain/entities/order.dart';
import 'package:brew_coffee/domain/repositories/order_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({
    super.key,
    required this.orderId,
    required this.orderRepository,
  });

  final String orderId;
  final OrderRepository orderRepository;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  Order? _order;

  @override
  void initState() {
    super.initState();
    widget.orderRepository.getOrderById(widget.orderId).then((o) {
      if (mounted) setState(() => _order = o);
    });
  }

  @override
  Widget build(BuildContext context) {
    final order = _order;
    return ReceiptScaffold(
      appBarTitle: 'Order detail',
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
                      for (final item in order.items)
                        ReceiptLineItem(
                          title: '${item.quantity} × ${item.customization.coffee.name}',
                          price: item.lineTotal,
                          subtitle: item.customization.summaryLines().join('\n'),
                        ),
                      const ReceiptDivider(),
                      ReceiptRowTotal(label: 'SUBTOTAL', amount: order.subtotal),
                      ReceiptRowTotal(label: 'TAX', amount: order.tax),
                      ReceiptRowTotal(label: 'SERVICE FEE', amount: order.serviceFee),
                      const ReceiptDivider(),
                      ReceiptRowTotal(label: 'TOTAL', amount: order.total, emphasize: true),
                    ],
                  ),
                ),
                const ReceiptZigzagBottom(),
              ],
            ),
    );
  }
}
