import 'package:brew_coffee/core/constants/app_branding.dart';
import 'package:brew_coffee/core/theme/app_colors.dart';
import 'package:brew_coffee/features/cart/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartCubit>().state.totals.itemCount;
    final location = GoRouterState.of(context).uri.path;
    final isReceiptRoute = location.contains('/cart') ||
        location.contains('/checkout') ||
        location.contains('/orders');

    if (isReceiptRoute) {
      return child;
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indexFor(location),
        onDestinationSelected: (i) {
          switch (i) {
            case 0:
              context.go('/');
            case 1:
              context.go('/catalog');
            case 2:
              context.go('/orders');
            case 3:
              context.go('/cart');
          }
        },
        destinations: [
          const NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          const NavigationDestination(icon: Icon(Icons.coffee_outlined), label: 'Menu'),
          const NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'Orders'),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
            label: 'Cart',
          ),
        ],
      ),
    );
  }

  int _indexFor(String path) {
    if (path.startsWith('/catalog')) return 1;
    if (path.startsWith('/orders')) return 2;
    if (path.startsWith('/cart')) return 3;
    return 0;
  }
}

class BrewAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BrewAppBar({super.key, this.showCart = true});

  final bool showCart;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartCubit>().state.totals.itemCount;
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppBranding.logoMark,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 4,
                ),
          ),
          Text(
            AppBranding.tagline,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.secondaryText,
                ),
          ),
        ],
      ),
      actions: [
        if (showCart)
          IconButton(
            onPressed: () => context.go('/cart'),
            icon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
      ],
    );
  }
}
