import 'package:brew_coffee/core/theme/receipt_theme.dart';
import 'package:brew_coffee/core/widgets/receipt/receipt_divider.dart';
import 'package:brew_coffee/core/widgets/receipt/receipt_header.dart';
import 'package:brew_coffee/core/widgets/receipt/receipt_line_widgets.dart';
import 'package:brew_coffee/core/widgets/receipt/receipt_paper.dart';
import 'package:brew_coffee/core/widgets/receipt/receipt_scaffold.dart';
import 'package:brew_coffee/core/widgets/receipt/receipt_zigzag_bottom.dart';
import 'package:brew_coffee/features/cart/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartCubit>().state;
    final totals = cart.totals;

    return ReceiptScaffold(
      appBarTitle: 'Your cart',
      onBack: () => context.pop(),
      child: Column(
        children: [
          ReceiptPaper(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ReceiptHeader(showMeta: false),
                if (cart.items.isEmpty)
                  Text(
                    'No items yet — brew something wonderful.',
                    style: ReceiptTheme.lineDetail(context),
                  )
                else
                  ...cart.items.map((item) {
                    return ReceiptExpandableItem(
                      title: item.customization.coffee.name,
                      price: item.lineTotal,
                      details: item.customization.summaryLines(),
                      actions: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: _CartLineActions(itemId: item.id, coffeeId: item.customization.coffee.id),
                      ),
                    );
                  }),
                const ReceiptDivider(),
                ReceiptRowTotal(
                  label: '${totals.itemCount} ITEMS',
                  amount: totals.subtotal,
                ),
              ],
            ),
          ),
          const ReceiptZigzagBottom(),
          const SizedBox(height: 20),
          if (cart.items.isNotEmpty)
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 340),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                onPressed: () => context.go('/checkout'),
                  child: const Text('CHECKOUT'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CartLineActions extends StatelessWidget {
  const _CartLineActions({required this.itemId, required this.coffeeId});

  final String itemId;
  final String coffeeId;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartCubit>().state;
    final item = cart.items.firstWhere((i) => i.id == itemId);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () => context.read<CartCubit>().decrement(itemId),
              icon: const Icon(Icons.remove_circle_outline, size: 22),
            ),
            Text(
              '${item.quantity}',
              style: ReceiptTheme.lineTitle(context),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () => context.read<CartCubit>().increment(itemId),
              icon: const Icon(Icons.add_circle_outline, size: 22),
            ),
          ],
        ),
        Wrap(
          spacing: 4,
          children: [
            TextButton(
              onPressed: () => context.read<CartCubit>().remove(itemId),
              child: const Text('Remove'),
            ),
            TextButton(
              onPressed: () => context.go('/coffee/$coffeeId'),
              child: const Text('Edit'),
            ),
          ],
        ),
      ],
    );
  }
}
