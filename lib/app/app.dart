import 'package:brew_coffee/app/di.dart';
import 'package:brew_coffee/core/constants/app_branding.dart';
import 'package:brew_coffee/core/routing/app_router.dart';
import 'package:brew_coffee/core/theme/app_theme.dart';
import 'package:brew_coffee/features/cart/cart_cubit.dart';
import 'package:brew_coffee/features/catalog/catalog_cubit.dart';
import 'package:brew_coffee/features/checkout/checkout_cubit.dart';
import 'package:brew_coffee/features/coffee_customization/customization_cubit.dart';
import 'package:brew_coffee/features/coffee_machine/coffee_machine_cubit.dart';
import 'package:brew_coffee/features/orders/order_fulfillment_cubit.dart';
import 'package:brew_coffee/features/orders/orders_history_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BrewCoffeeApp extends StatefulWidget {
  BrewCoffeeApp({super.key, AppDependencies? dependencies})
      : dependencies = dependencies ?? AppDependencies();

  final AppDependencies dependencies;

  @override
  State<BrewCoffeeApp> createState() => _BrewCoffeeAppState();
}

class _BrewCoffeeAppState extends State<BrewCoffeeApp> {
  late final _router = createAppRouter(widget.dependencies);

  @override
  Widget build(BuildContext context) {
    final deps = widget.dependencies;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CatalogCubit(deps.coffeeRepository)..load(),
        ),
        BlocProvider(
          create: (_) => CustomizationCubit(deps.coffeeRepository, deps.pricingService),
        ),
        BlocProvider(create: (_) => CoffeeMachineCubit()),
        BlocProvider(create: (_) => CartCubit()),
        BlocProvider(create: (_) => CheckoutCubit(deps.orderRepository)),
        BlocProvider(create: (_) => OrdersHistoryCubit(deps.orderRepository)),
        BlocProvider(
          create: (_) => OrderFulfillmentCubit(deps.orderRepository),
        ),
      ],
      child: MaterialApp.router(
        title: AppBranding.appName,
        theme: AppTheme.light(),
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
