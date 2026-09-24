import 'package:brew_coffee/core/theme/receipt_theme.dart';
import 'package:brew_coffee/core/utils/currency_format.dart';
import 'package:flutter/material.dart';

class ReceiptLineItem extends StatelessWidget {
  const ReceiptLineItem({
    super.key,
    required this.title,
    this.price,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final int? price;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: ReceiptTheme.lineTitle(context),
                ),
              ),
              if (price != null)
                Text(formatCurrency(price!), style: ReceiptTheme.price(context)),
              if (trailing != null) trailing!,
            ],
          ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 2, left: 4),
              child: Text(subtitle!, style: ReceiptTheme.lineDetail(context)),
            ),
        ],
      ),
    );
  }
}

class ReceiptRowTotal extends StatelessWidget {
  const ReceiptRowTotal({
    super.key,
    required this.label,
    required this.amount,
    this.emphasize = false,
  });

  final String label;
  final int amount;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: emphasize
                  ? ReceiptTheme.totalLabel(context)
                  : ReceiptTheme.lineDetail(context),
            ),
          ),
          Text(
            formatCurrency(amount),
            style: emphasize
                ? ReceiptTheme.totalAmount(context)
                : ReceiptTheme.price(context),
          ),
        ],
      ),
    );
  }
}

class ReceiptExpandableItem extends StatefulWidget {
  const ReceiptExpandableItem({
    super.key,
    required this.title,
    required this.price,
    required this.details,
    this.actions,
  });

  final String title;
  final int price;
  final List<String> details;
  final Widget? actions;

  @override
  State<ReceiptExpandableItem> createState() => _ReceiptExpandableItemState();
}

class _ReceiptExpandableItemState extends State<ReceiptExpandableItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReceiptLineItem(title: widget.title, price: widget.price),
            if (_expanded) ...[
              for (final line in widget.details)
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 2),
                  child: Text(line, style: ReceiptTheme.lineDetail(context)),
                ),
              if (widget.actions != null) widget.actions!,
            ],
          ],
        ),
      ),
    );
  }
}

class ReceiptRadioRow extends StatelessWidget {
  const ReceiptRadioRow({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(
          '${selected ? '●' : '○'} $label',
          style: ReceiptTheme.lineTitle(context),
        ),
      ),
    );
  }
}
