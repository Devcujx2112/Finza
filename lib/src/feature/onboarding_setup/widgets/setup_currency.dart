import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class SetupCurrency {
  const SetupCurrency._();

  static const String symbol = 'đ';

  static const double maxAmount = 999999999999;

  static final NumberFormat _grouped = NumberFormat.decimalPattern('vi_VN');

  static String format(double amount) =>
      '${_grouped.format(amount.round())}$symbol';

  static String formatPlain(double amount) => _grouped.format(amount.round());

  static double parse(String text) {
    final digits = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return 0;
    return double.tryParse(digits)?.clamp(0, maxAmount).toDouble() ?? 0;
  }
}

class ThousandsSeparatorFormatter extends TextInputFormatter {
  ThousandsSeparatorFormatter({this.maxValue = SetupCurrency.maxAmount});

  final double maxValue;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      return const TextEditingValue(text: '');
    }
    final parsed = double.tryParse(digits);
    if (parsed == null) return oldValue;
    if (parsed > maxValue) return oldValue;
    final formatted = SetupCurrency.formatPlain(parsed);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
