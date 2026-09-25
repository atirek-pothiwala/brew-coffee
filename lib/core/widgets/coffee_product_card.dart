import 'package:brew_coffee/core/theme/app_colors.dart';
import 'package:brew_coffee/core/utils/currency_format.dart';
import 'package:brew_coffee/domain/entities/coffee.dart';
import 'package:flutter/material.dart';

class CoffeeProductCard extends StatelessWidget {
  const CoffeeProductCard({
    super.key,
    required this.coffee,
    required this.onCustomize,
    required this.onFavorite,
    required this.isFavorite,
  });

  final Coffee coffee;
  final VoidCallback onCustomize;
  final VoidCallback onFavorite;
  final bool isFavorite;

  static List<BoxShadow> get _cardShadows => [
        BoxShadow(
          color: AppColors.darkCoffee.withOpacity(0.07),
          blurRadius: 18,
          offset: const Offset(0, 8),
          spreadRadius: -2,
        ),
        BoxShadow(
          color: AppColors.darkCoffee.withOpacity(0.04),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: _cardShadows,
      ),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 2,
        shadowColor: AppColors.darkCoffee.withOpacity(0.12),
        clipBehavior: Clip.antiAlias,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(coffee.imageGradientStart),
                  Color(coffee.imageGradientEnd),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                const Positioned(
                  right: 12,
                  bottom: 12,
                  child: Icon(Icons.coffee, color: Colors.white54, size: 48),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    onPressed: onFavorite,
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? AppColors.caramelAccent : Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coffee.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  coffee.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.secondaryText,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  'From ${formatCurrency(coffee.basePrice)}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.primaryCoffee,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonal(
                    onPressed: onCustomize,
                    child: const Text('Customize'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}
