import 'package:brew_coffee/core/theme/receipt_theme.dart';
import 'package:flutter/material.dart';

class ReceiptScaffold extends StatelessWidget {
  const ReceiptScaffold({
    super.key,
    required this.child,
    this.appBarTitle,
    this.onBack,
  });

  final Widget child;
  final String? appBarTitle;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ReceiptTheme.pageBackground,
      appBar: appBarTitle == null
          ? null
          : AppBar(
              backgroundColor: ReceiptTheme.pageBackground,
              foregroundColor: ReceiptTheme.ink,
              elevation: 0,
              title: Text(
                appBarTitle!,
                style: ReceiptTheme.lineTitle(context),
              ),
              leading: onBack == null
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: onBack,
                    ),
            ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: child,
          ),
        ),
      ),
    );
  }
}
