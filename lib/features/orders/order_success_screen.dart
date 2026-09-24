import 'package:brew_coffee/core/theme/app_colors.dart';
import 'package:brew_coffee/core/theme/receipt_theme.dart';
import 'package:brew_coffee/core/widgets/receipt/receipt_divider.dart';
import 'package:brew_coffee/core/widgets/receipt/receipt_header.dart';
import 'package:brew_coffee/core/widgets/receipt/receipt_line_widgets.dart';
import 'package:brew_coffee/core/widgets/receipt/receipt_paper.dart';
import 'package:brew_coffee/core/widgets/receipt/receipt_print_animation.dart';
import 'package:brew_coffee/core/widgets/receipt/receipt_scaffold.dart';
import 'package:brew_coffee/core/widgets/receipt/receipt_zigzag_bottom.dart';
import 'package:brew_coffee/domain/entities/order.dart';
import 'package:brew_coffee/domain/repositories/order_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderSuccessScreen extends StatefulWidget {
  const OrderSuccessScreen({
    super.key,
    required this.orderId,
    required this.orderRepository,
  });

  final String orderId;
  final OrderRepository orderRepository;

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
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
      child: Column(
        children: [
          if (order == null)
            const CircularProgressIndicator()
          else ...[
            Text('☕', style: const TextStyle(fontSize: 36)),
            Text(
              'YOUR ORDER IS READY',
              style: ReceiptTheme.lineTitle(context),
              textAlign: TextAlign.center,
            ),
            Text(
              '#${order.displayNumber}',
              style: ReceiptTheme.meta(context),
            ),
            const SizedBox(height: 16),
            ReceiptPrintAnimation(
              receipt: ReceiptPaper(
                child: Column(
                  children: [
                    ReceiptHeader(
                      orderNumber: order.displayNumber,
                      dateTime: order.createdAt,
                    ),
                    for (final item in order.items)
                      ReceiptLineItem(
                        title: item.customization.coffee.name,
                        price: item.lineTotal,
                        subtitle: item.customization.summaryLines().join('\n'),
                      ),
                    const ReceiptDivider(),
                    ReceiptRowTotal(label: 'TOTAL', amount: order.total, emphasize: true),
                    const SizedBox(height: 8),
                    Text('PAID ✓', style: ReceiptTheme.totalLabel(context)),
                    const ReceiptDivider(),
                    Text(
                      'Thank you!\nBrew something wonderful.',
                      textAlign: TextAlign.center,
                      style: ReceiptTheme.lineDetail(context),
                    ),
                  ],
                ),
              ),
            ),
            const ReceiptZigzagBottom(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/orders/${order.id}/track'),
              child: const Text('VIEW ORDER'),
            ),
            TextButton(
              onPressed: () => context.go('/'),
              child: const Text('Back home', style: TextStyle(color: AppColors.primaryCoffee)),
            ),
          ],
        ],
      ),
    );
  }
}
