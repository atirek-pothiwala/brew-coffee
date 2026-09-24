import 'package:brew_coffee/core/utils/breakpoints.dart';
import 'package:brew_coffee/core/widgets/coffee_product_card.dart';
import 'package:brew_coffee/domain/entities/enums.dart';
import 'package:brew_coffee/features/catalog/catalog_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key, this.categoryId});

  final String? categoryId;

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogCubit>().state;
    CoffeeCategoryId? filter;
    if (categoryId != null) {
      for (final c in CoffeeCategoryId.values) {
        if (c.name == categoryId) {
          filter = c;
          break;
        }
      }
    }
    final coffees = filter == null
        ? catalog.coffees
        : catalog.coffees.where((c) => c.category == filter).toList();
    final crossAxis = isDesktop(context) ? 3 : 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(filter?.label ?? 'Coffee catalogue'),
      ),
      body: catalog.loading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxis,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: isDesktop(context) ? 0.72 : 0.68,
              ),
              itemCount: coffees.length,
              itemBuilder: (context, i) {
                final coffee = coffees[i];
                return CoffeeProductCard(
                  coffee: coffee,
                  isFavorite: catalog.favoriteIds.contains(coffee.id),
                  onFavorite: () =>
                      context.read<CatalogCubit>().toggleFavorite(coffee.id),
                  onCustomize: () => context.go('/coffee/${coffee.id}'),
                );
              },
            ),
    );
  }
}
