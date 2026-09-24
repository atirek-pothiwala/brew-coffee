import 'package:brew_coffee/core/theme/receipt_theme.dart';
import 'package:flutter/material.dart';

class ReceiptPaper extends StatelessWidget {
  const ReceiptPaper({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: ReceiptTheme.paperConstraints(),
      decoration: BoxDecoration(
        color: ReceiptTheme.paper,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.fromLTRB(20, 24, 20, 8),
        child: child,
      ),
    );
  }
}
