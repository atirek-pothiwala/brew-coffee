import 'package:brew_coffee/core/theme/app_colors.dart';
import 'package:brew_coffee/core/utils/breakpoints.dart';
import 'package:brew_coffee/core/widgets/app_shell.dart';
import 'package:brew_coffee/core/widgets/coffee_product_card.dart';
import 'package:brew_coffee/domain/entities/enums.dart';
import 'package:brew_coffee/features/catalog/catalog_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key, this.categoryId});

  final String? categoryId;

  CoffeeCategoryId? _parseCategory() {
    if (categoryId == null) return null;
    for (final c in CoffeeCategoryId.values) {
      if (c.name == categoryId) return c;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogCubit>().state;
    final filter = _parseCategory();
    final coffees = filter == null
        ? catalog.coffees
        : catalog.coffees.where((c) => c.category == filter).toList();
    final crossAxis = isDesktop(context) ? 3 : 1;

    return Scaffold(
      appBar: BrewAppBar(pageTitle: filter?.label ?? 'Menu'),
      body: catalog.loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Row(
                    children: [
                      _CategoryChip(
                        label: 'All',
                        selected: filter == null,
                        onTap: () => context.go('/catalog'),
                      ),
                      for (final cat in CoffeeCategoryId.values)
                        _CategoryChip(
                          label: cat.label,
                          selected: filter == cat,
                          onTap: () => context.go('/catalog/${cat.name}'),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: coffees.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              'No drinks in this category yet.',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.secondaryText,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(20),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxis,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: isDesktop(context) ? 0.72 : 0.72,
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
                ),
              ],
            ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        showCheckmark: false,
        selectedColor: AppColors.caramelAccent.withOpacity(0.4),
      ),
    );
  }
}
