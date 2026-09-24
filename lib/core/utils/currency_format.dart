import 'package:brew_coffee/core/constants/app_constants.dart';
import 'package:intl/intl.dart';

final NumberFormat _inrFormat = NumberFormat.currency(
  locale: 'en_IN',
  symbol: AppConstants.currencySymbol,
  decimalDigits: 0,
);

String formatCurrency(num amount) => _inrFormat.format(amount);
