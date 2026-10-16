import 'package:brew_coffee/core/theme/receipt_theme.dart';
import 'package:flutter/material.dart';

class ReceiptTextField extends StatelessWidget {
  const ReceiptTextField({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.keyboardType,
  });

  final String hintText;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final border = UnderlineInputBorder(
      borderSide: BorderSide(color: ReceiptTheme.dash),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        onChanged: onChanged,
        keyboardType: keyboardType,
        style: ReceiptTheme.lineDetail(context).copyWith(
          color: ReceiptTheme.ink,
          fontSize: 12,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: ReceiptTheme.meta(context),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          border: border,
          enabledBorder: border,
          focusedBorder: border.copyWith(
            borderSide: const BorderSide(color: ReceiptTheme.ink, width: 1.5),
          ),
        ),
      ),
    );
  }
}
