import 'package:brew_coffee/core/constants/app_branding.dart';
import 'package:brew_coffee/core/theme/receipt_theme.dart';
import 'package:brew_coffee/core/widgets/receipt/receipt_divider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReceiptHeader extends StatelessWidget {
  const ReceiptHeader({
    super.key,
    this.orderNumber,
    this.dateTime,
    this.showMeta = true,
  });

  final String? orderNumber;
  final DateTime? dateTime;
  final bool showMeta;

  @override
  Widget build(BuildContext context) {
    final dt = dateTime ?? DateTime.now();
    final date = DateFormat('dd MMM yyyy').format(dt).toUpperCase();
    final time = DateFormat('h:mm a').format(dt).toUpperCase();

    return Column(
      children: [
        Text(AppBranding.logoMark, style: ReceiptTheme.brand(context)),
        const SizedBox(height: 4),
        Text(AppBranding.receiptShopLine, style: ReceiptTheme.shopLine(context)),
        const ReceiptDivider(),
        if (showMeta) ...[
          if (orderNumber != null)
            Text('ORDER #$orderNumber', style: ReceiptTheme.meta(context)),
          Text(date, style: ReceiptTheme.meta(context)),
          Text(time, style: ReceiptTheme.meta(context)),
          const ReceiptDivider(),
        ],
      ],
    );
  }
}
