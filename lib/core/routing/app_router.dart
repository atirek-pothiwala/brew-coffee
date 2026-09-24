import 'package:brew_coffee/app/di.dart';
import 'package:brew_coffee/core/widgets/app_shell.dart';
import 'package:brew_coffee/features/cart/cart_screen.dart';
import 'package:brew_coffee/features/catalog/catalog_screen.dart';
import 'package:brew_coffee/features/checkout/checkout_screen.dart';
import 'package:brew_coffee/features/coffee_customization/customization_cubit.dart';
import 'package:brew_coffee/features/coffee_customization/customization_screen.dart';
import 'package:brew_coffee/features/coffee_machine/coffee_machine_screen.dart';
import 'package:brew_coffee/features/home/home_screen.dart';
import 'package:brew_coffee/features/orders/order_detail_screen.dart';
import 'package:brew_coffee/features/orders/order_fulfillment_cubit.dart';
import 'package:brew_coffee/features/orders/order_success_screen.dart';
import 'package:brew_coffee/features/orders/order_tracking_screen.dart';
import 'package:brew_coffee/features/orders/orders_history_cubit.dart';
import 'package:brew_coffee/features/orders/orders_history_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

GoRouter createAppRouter(AppDependencies deps) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/catalog',
            builder: (context, state) => const CatalogScreen(),
            routes: [
              GoRoute(
                path: ':categoryId',
                builder: (context, state) => CatalogScreen(
                  categoryId: state.pathParameters['categoryId'],
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/orders',
            builder: (context, state) {
              context.read<OrdersHistoryCubit>().load();
              return const OrdersHistoryScreen();
            },
          ),
        ],
      ),
      GoRoute(
        path: '/coffee/:coffeeId',
        builder: (context, state) {
          final id = state.pathParameters['coffeeId']!;
          context.read<CustomizationCubit>().load(id);
          return CustomizationScreen(coffeeId: id);
        },
        routes: [
          GoRoute(
            path: 'brew',
            builder: (context, state) {
              final id = state.pathParameters['coffeeId']!;
              return CoffeeMachineScreen(coffeeId: id);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/orders/:orderId/success',
        builder: (context, state) => OrderSuccessScreen(
          orderId: state.pathParameters['orderId']!,
          orderRepository: deps.orderRepository,
        ),
      ),
      GoRoute(
        path: '/orders/:orderId/track',
        builder: (context, state) {
          final orderId = state.pathParameters['orderId']!;
          context.read<OrderFulfillmentCubit>().load(orderId);
          return OrderTrackingScreen(orderId: orderId);
        },
      ),
      GoRoute(
        path: '/orders/:orderId',
        builder: (context, state) => OrderDetailScreen(
          orderId: state.pathParameters['orderId']!,
          orderRepository: deps.orderRepository,
        ),
      ),
    ],
  );
}
