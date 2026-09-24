import 'package:brew_coffee/core/theme/app_colors.dart';
import 'package:brew_coffee/core/theme/receipt_theme.dart';
import 'package:brew_coffee/domain/entities/enums.dart';
import 'package:flutter/material.dart';

class ReceiptStatusList extends StatelessWidget {
  const ReceiptStatusList({
    super.key,
    required this.current,
  });

  final OrderStatusStep current;

  @override
  Widget build(BuildContext context) {
    final steps = OrderStatusStep.values;
    final currentIndex = steps.indexOf(current);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ORDER STATUS', style: ReceiptTheme.lineTitle(context)),
        const SizedBox(height: 8),
        for (var i = 0; i < steps.length; i++)
          _StatusRow(
            label: steps[i].label,
            state: i < currentIndex
                ? _RowState.done
                : i == currentIndex
                    ? _RowState.active
                    : _RowState.pending,
          ),
      ],
    );
  }
}

enum _RowState { done, active, pending }

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.label, required this.state});

  final String label;
  final _RowState state;

  @override
  Widget build(BuildContext context) {
    final symbol = switch (state) {
      _RowState.done => '✓',
      _RowState.active => '●',
      _RowState.pending => '○',
    };
    final color = switch (state) {
      _RowState.done => ReceiptTheme.inkMuted,
      _RowState.active => AppColors.primaryCoffee,
      _RowState.pending => ReceiptTheme.dash,
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        '$symbol $label',
        style: ReceiptTheme.lineDetail(context).copyWith(
          color: color,
          fontWeight: state == _RowState.active ? FontWeight.w700 : null,
        ),
      ),
    );
  }
}
