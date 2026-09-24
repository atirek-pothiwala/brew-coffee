import 'package:brew_coffee/core/constants/app_branding.dart';
import 'package:brew_coffee/core/theme/app_colors.dart';
import 'package:brew_coffee/core/widgets/app_shell.dart';
import 'package:brew_coffee/core/widgets/coffee_product_card.dart';
import 'package:brew_coffee/domain/entities/enums.dart';
import 'package:brew_coffee/features/catalog/catalog_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogCubit>().state;

    return Scaffold(
      appBar: const BrewAppBar(),
      body: catalog.loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeroSection(onStart: () => context.go('/catalog')),
                  const SizedBox(height: 32),
                  _SectionTitle('Featured'),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 340,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: catalog.featured.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, i) {
                        final coffee = catalog.featured[i];
                        return SizedBox(
                          width: 260,
                          child: CoffeeProductCard(
                            coffee: coffee,
                            isFavorite: catalog.favoriteIds.contains(coffee.id),
                            onFavorite: () =>
                                context.read<CatalogCubit>().toggleFavorite(coffee.id),
                            onCustomize: () => context.go('/coffee/${coffee.id}'),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 28),
                  _SectionTitle('Categories'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: CoffeeCategoryId.values.map((cat) {
                      return ActionChip(
                        label: Text(cat.label),
                        onPressed: () => context.go('/catalog/${cat.name}'),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),
                  _SectionTitle('Popular'),
                  const SizedBox(height: 12),
                  ...catalog.popular.take(3).map(
                        (coffee) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: CoffeeProductCard(
                            coffee: coffee,
                            isFavorite: catalog.favoriteIds.contains(coffee.id),
                            onFavorite: () =>
                                context.read<CatalogCubit>().toggleFavorite(coffee.id),
                            onCustomize: () => context.go('/coffee/${coffee.id}'),
                          ),
                        ),
                      ),
                  if (catalog.seasonal != null) ...[
                    const SizedBox(height: 28),
                    _SectionTitle('Seasonal pick'),
                    const SizedBox(height: 12),
                    Card(
                      child: ListTile(
                        title: Text(catalog.seasonal!.name),
                        subtitle: Text(catalog.seasonal!.description),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () => context.go('/coffee/${catalog.seasonal!.id}'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.darkCoffee,
          ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [AppColors.darkCoffee, AppColors.primaryCoffee],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppBranding.appName,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Watch your drink come to life on our simulated espresso bar.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.85),
                ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.coffee_maker, color: AppColors.caramelAccent, size: 40),
              const SizedBox(width: 12),
              const Icon(Icons.arrow_downward, color: Colors.white54),
              const SizedBox(width: 12),
              Icon(Icons.local_cafe, color: Colors.white, size: 36),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onStart,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.caramelAccent,
              foregroundColor: AppColors.darkCoffee,
            ),
            child: const Text('START ORDERING'),
          ),
        ],
      ),
    );
  }
}
