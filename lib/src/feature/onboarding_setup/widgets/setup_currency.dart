import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Vietnamese dong formatting for the setup flow. Grouping follows the
/// vi_VN pattern the rest of the app already uses for money.
class SetupCurrency {
  const SetupCurrency._();

  static const String symbol = 'đ';

  /// Largest amount that can be typed, which keeps the field from
  /// overflowing and rejects obvious mistypes.
  static const double maxAmount = 999999999999;

  static final NumberFormat _grouped = NumberFormat.decimalPattern('vi_VN');

  /// `20000000` becomes `20.000.000đ`.
  static String format(double amount) =>
      '${_grouped.format(amount.round())}$symbol';

  /// The same figure without the suffix, for use next to a separate unit.
  static String formatPlain(double amount) => _grouped.format(amount.round());

  static double parse(String text) {
    final digits = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return 0;
    return double.tryParse(digits)?.clamp(0, maxAmount).toDouble() ?? 0;
  }
}

/// Reformats the field as the user types so the amount is always readable,
/// and silently drops anything that is not a digit.
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
