import 'package:brew_coffee/core/theme/app_colors.dart';
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
                    style: ReceiptThemeFallback.detail(context),
                  )
                else
                  ...cart.items.map((item) {
                    return ReceiptExpandableItem(
                      title: item.customization.coffee.name,
                      price: item.lineTotal,
                      details: item.customization.summaryLines(),
                      actions: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () =>
                                  context.read<CartCubit>().decrement(item.id),
                              icon: const Icon(Icons.remove, size: 18),
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              onPressed: () =>
                                  context.read<CartCubit>().increment(item.id),
                              icon: const Icon(Icons.add, size: 18),
                            ),
                            TextButton(
                              onPressed: () =>
                                  context.read<CartCubit>().remove(item.id),
                              child: const Text('Remove'),
                            ),
                            TextButton(
                              onPressed: () => context.go(
                                '/coffee/${item.customization.coffee.id}',
                              ),
                              child: const Text('Edit'),
                            ),
                          ],
                        ),
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

/// Avoid importing receipt_theme in cart for meta only — thin helper.
class ReceiptThemeFallback {
  static TextStyle detail(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.secondaryText);
}
