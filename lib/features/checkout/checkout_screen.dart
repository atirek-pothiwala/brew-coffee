import 'package:brew_coffee/core/theme/receipt_theme.dart';
import 'package:brew_coffee/domain/entities/enums.dart';
import 'package:brew_coffee/features/cart/cart_cubit.dart';
import 'package:brew_coffee/features/checkout/checkout_cubit.dart';
import 'package:brew_coffee/core/widgets/receipt/receipt_divider.dart';
import 'package:brew_coffee/core/widgets/receipt/receipt_header.dart';
import 'package:brew_coffee/core/widgets/receipt/receipt_line_widgets.dart';
import 'package:brew_coffee/core/widgets/receipt/receipt_paper.dart';
import 'package:brew_coffee/core/widgets/receipt/receipt_scaffold.dart';
import 'package:brew_coffee/core/widgets/receipt/receipt_zigzag_bottom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartCubit>().state;
    final checkout = context.watch<CheckoutCubit>().state;
    final totals = cart.totals;

    return ReceiptScaffold(
      appBarTitle: 'Checkout',
      onBack: () => context.pop(),
      child: Column(
        children: [
          ReceiptPaper(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ReceiptHeader(showMeta: false),
                Text('ORDER SUMMARY', style: ReceiptTheme.lineTitle(context)),
                const ReceiptDivider(),
                for (final item in cart.items)
                  ReceiptLineItem(
                    title: '${item.quantity} × ${item.customization.coffee.name}',
                    price: item.lineTotal,
                  ),
                const ReceiptDivider(),
                ReceiptRowTotal(label: 'SUBTOTAL', amount: totals.subtotal),
                ReceiptRowTotal(label: 'TAX', amount: totals.tax),
                ReceiptRowTotal(label: 'SERVICE FEE', amount: totals.serviceFee),
                const ReceiptDivider(),
                ReceiptRowTotal(label: 'TOTAL', amount: totals.total, emphasize: true),
                const SizedBox(height: 16),
                Text('CUSTOMER', style: ReceiptTheme.lineTitle(context)),
                TextField(
                  decoration: const InputDecoration(hintText: 'Name'),
                  onChanged: context.read<CheckoutCubit>().setName,
                ),
                TextField(
                  decoration: const InputDecoration(hintText: 'Email'),
                  onChanged: context.read<CheckoutCubit>().setEmail,
                ),
                const SizedBox(height: 12),
                Text('FULFILLMENT', style: ReceiptTheme.lineTitle(context)),
                ReceiptRadioRow(
                  label: 'Pickup',
                  selected: checkout.fulfillmentType == FulfillmentType.pickup,
                  onTap: () => context
                      .read<CheckoutCubit>()
                      .setFulfillment(FulfillmentType.pickup),
                ),
                ReceiptRadioRow(
                  label: 'Delivery',
                  selected: checkout.fulfillmentType == FulfillmentType.delivery,
                  onTap: () => context
                      .read<CheckoutCubit>()
                      .setFulfillment(FulfillmentType.delivery),
                ),
                const SizedBox(height: 12),
                Text('PAYMENT', style: ReceiptTheme.lineTitle(context)),
                ReceiptRadioRow(
                  label: 'Demo Card',
                  selected: checkout.paymentMethod == PaymentMethod.demoCard,
                  onTap: () => context
                      .read<CheckoutCubit>()
                      .setPayment(PaymentMethod.demoCard),
                ),
                ReceiptRadioRow(
                  label: 'Cash',
                  selected: checkout.paymentMethod == PaymentMethod.cash,
                  onTap: () =>
                      context.read<CheckoutCubit>().setPayment(PaymentMethod.cash),
                ),
                if (checkout.error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      checkout.error!,
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ),
              ],
            ),
          ),
          const ReceiptZigzagBottom(),
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 340),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: checkout.placing
                    ? null
                    : () async {
                        final order = await context
                            .read<CheckoutCubit>()
                            .placeOrder(cart);
                        if (order != null && context.mounted) {
                          context.read<CartCubit>().clear();
                          context.go('/orders/${order.id}/success');
                        }
                      },
                child: Text(checkout.placing ? 'PLACING…' : 'PLACE ORDER'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
