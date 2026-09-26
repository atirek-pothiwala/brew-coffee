import 'package:brew_coffee/core/theme/app_colors.dart';
import 'package:brew_coffee/core/utils/breakpoints.dart';
import 'package:brew_coffee/core/utils/currency_format.dart';
import 'package:brew_coffee/core/widgets/coffee_cup_view.dart';
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
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CoffeeCupView(
            visual: CupVisualState(espressoLevel: 0.4, milkLevel: 0.2),
            size: 180,
          ),
          const SizedBox(height: 16),
          Text(
            customization.coffee.name,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          ...customization.summaryLines().map(
                (l) => Text(
                  l,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
          const SizedBox(height: 12),
          Text(
            formatCurrency(customization.unitPrice),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.primaryCoffee,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
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
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: Topping.values.map((t) {
              return ChoiceChip(
                label: Text(t.label),
                selected: customization.topping == t,
                onSelected: (_) => cubit.updateTopping(t),
              );
            }).toList(),
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
