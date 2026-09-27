import 'package:brew_coffee/core/theme/app_colors.dart';
import 'package:brew_coffee/core/theme/receipt_theme.dart';
import 'package:brew_coffee/core/utils/breakpoints.dart';
import 'package:brew_coffee/core/widgets/coffee_cup_view.dart';
import 'package:brew_coffee/core/widgets/receipt/receipt_divider.dart';
import 'package:brew_coffee/core/widgets/receipt/receipt_line_widgets.dart';
import 'package:brew_coffee/core/widgets/receipt/receipt_paper.dart';
import 'package:brew_coffee/core/widgets/receipt/receipt_zigzag_bottom.dart';
import 'package:brew_coffee/domain/entities/coffee_customization.dart';
import 'package:brew_coffee/domain/entities/cup_visual_state.dart';
import 'package:brew_coffee/domain/entities/enums.dart';
import 'package:brew_coffee/features/coffee_customization/customization_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CustomizationScreen extends StatelessWidget {
  const CustomizationScreen({super.key, required this.coffeeId});

  final String coffeeId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomizationCubit, CustomizationState>(
      builder: (context, state) {
        if (state.loading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (state.error != null || state.customization == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(state.error ?? 'Unavailable')),
          );
        }
        final c = state.customization!;
        final desktop = isDesktop(context);

        return Scaffold(
          appBar: AppBar(title: Text(c.coffee.name)),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: desktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _Preview(c)),
                      const SizedBox(width: 32),
                      Expanded(child: _Controls(customization: c)),
                    ],
                  )
                : Column(
                    children: [
                      _Preview(c),
                      const SizedBox(height: 24),
                      _Controls(customization: c),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview(this.customization);
  final CoffeeCustomization customization;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: ReceiptTheme.paperConstraints(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ReceiptPaper(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: CoffeeCupView(
                      visual: CupVisualState.customizationPreview(
                        milk: customization.milk,
                        temperature: customization.temperature,
                        topping: customization.topping,
                      ),
                      size: 180,
                    ),
                  ),
                  const ReceiptDivider(),
                  Text(
                    customization.coffee.name.toUpperCase(),
                    style: ReceiptTheme.lineTitle(context),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  ...customization.summaryLines().map(
                        (l) => Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            l,
                            style: ReceiptTheme.lineDetail(context),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  const ReceiptDivider(),
                  ReceiptRowTotal(
                    label: 'TOTAL',
                    amount: customization.unitPrice,
                    emphasize: true,
                  ),
                ],
              ),
            ),
            const ReceiptZigzagBottom(),
          ],
        ),
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({required this.customization});

  final CoffeeCustomization customization;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CustomizationCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _OptionSection(
          title: 'Size',
          child: Wrap(
            spacing: 8,
            children: CoffeeSize.values.map((s) {
              return ChoiceChip(
                label: Text(s.label),
                selected: customization.size == s,
                onSelected: (_) => cubit.updateSize(s),
              );
            }).toList(),
          ),
        ),
        _OptionSection(
          title: 'Milk',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: MilkType.values.map((m) {
              return ChoiceChip(
                label: Text(m.label),
                selected: customization.milk == m,
                onSelected: (_) => cubit.updateMilk(m),
              );
            }).toList(),
          ),
        ),
        _OptionSection(
          title: 'Sugar portions',
          child: Row(
            children: List.generate(5, (i) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text('$i'),
                  selected: customization.sugarPortions == i,
                  onSelected: (_) => cubit.updateSugar(i),
                ),
              );
            }),
          ),
        ),
        _OptionSection(
          title: 'Temperature',
          child: Wrap(
            spacing: 8,
            children: Temperature.values.map((t) {
              return ChoiceChip(
                label: Text(t.label),
                selected: customization.temperature == t,
                onSelected: (_) => cubit.updateTemperature(t),
              );
            }).toList(),
          ),
        ),
        _OptionSection(
          title: 'Extra shot',
          child: Wrap(
            spacing: 8,
            children: ExtraShot.values.map((e) {
              return ChoiceChip(
                label: Text(e.label),
                selected: customization.extraShot == e,
                onSelected: (_) => cubit.updateExtraShot(e),
              );
            }).toList(),
          ),
        ),
        _OptionSection(
          title: 'Flavour',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: Flavor.values.map((f) {
              return ChoiceChip(
                label: Text(f.label),
                selected: customization.flavor == f,
                onSelected: (_) => cubit.updateFlavor(f),
              );
            }).toList(),
          ),
        ),
        _OptionSection(
          title: 'Topping',
          child: _ToppingPicker(
            selected: customization.topping,
            onSelected: cubit.updateTopping,
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => context.go('/coffee/${customization.coffee.id}/brew'),
          child: const Text('MAKE MY COFFEE'),
        ),
      ],
    );
  }
}

class _ToppingPicker extends StatelessWidget {
  const _ToppingPicker({
    required this.selected,
    required this.onSelected,
  });

  final Topping selected;
  final ValueChanged<Topping> onSelected;

  static const _prices = <Topping, String>{
    Topping.none: 'Included',
    Topping.whippedCream: '+30',
    Topping.cinnamon: 'Free',
    Topping.cocoa: '+15',
    Topping.caramelDrizzle: '+20',
  };

  static IconData _iconFor(Topping topping) {
    return switch (topping) {
      Topping.none => Icons.block_outlined,
      Topping.whippedCream => Icons.cloud_outlined,
      Topping.cinnamon => Icons.grain,
      Topping.cocoa => Icons.circle,
      Topping.caramelDrizzle => Icons.water_drop_outlined,
    };
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth = (constraints.maxWidth - 8) / 2;
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: Topping.values.map((topping) {
            final isSelected = selected == topping;
            return SizedBox(
              width: tileWidth,
              child: Material(
                color: isSelected
                    ? AppColors.primaryCoffee.withOpacity(0.08)
                    : AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () => onSelected(topping),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryCoffee
                            : AppColors.borderDivider,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _iconFor(topping),
                          size: 22,
                          color: isSelected
                              ? AppColors.primaryCoffee
                              : AppColors.secondaryText,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                topping.label,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? AppColors.primaryCoffee
                                          : AppColors.primaryText,
                                    ),
                              ),
                              Text(
                                _prices[topping]!,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: AppColors.secondaryText,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            size: 18,
                            color: AppColors.primaryCoffee,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _OptionSection extends StatelessWidget {
  const _OptionSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
