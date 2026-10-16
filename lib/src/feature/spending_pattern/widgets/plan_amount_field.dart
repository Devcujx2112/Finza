import 'package:app/src/feature/onboarding_setup/widgets/setup_currency.dart';
import 'package:app/src/feature/spending_pattern/widgets/spending_pattern_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Money input for the spending plan. Digits only, grouped as the user types
/// with the setup flow's formatter, dong suffix pinned beside the figure.
///
/// The field owns its text controller and follows [value] whenever it is not
/// being typed in, so "Split for me" can rewrite every amount at once.
class PlanAmountField extends StatefulWidget {
  const PlanAmountField({
    super.key,
    required this.tokens,
    required this.value,
    required this.onChanged,
    this.compact = false,
    this.hasError = false,
    this.semanticLabel,
    this.textInputAction = TextInputAction.next,
  });

  final SpendingPatternTokens tokens;
  final double value;
  final ValueChanged<double> onChanged;

  /// Right aligned and narrower, for an amount beside a category name.
  final bool compact;
  final bool hasError;
  final String? semanticLabel;
  final TextInputAction textInputAction;

  @override
  State<PlanAmountField> createState() => _PlanAmountFieldState();
}

class _PlanAmountFieldState extends State<PlanAmountField> {
  late final TextEditingController _controller = TextEditingController(
    text: _format(widget.value),
  );
  late final FocusNode _focusNode = FocusNode()..addListener(_onFocusChanged);

  static String _format(double value) =>
      value > 0 ? SetupCurrency.formatPlain(value) : '';

  void _onFocusChanged() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void didUpdateWidget(PlanAmountField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final typed = SetupCurrency.parse(_controller.text);
    if (!_focusNode.hasFocus && typed != widget.value) {
      _controller.text = _format(widget.value);
    }
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_onFocusChanged)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.tokens;
    final focused = _focusNode.hasFocus;
    final style = t.text(widget.compact ? 14.5 : 16, weight: FontWeight.w700);
    final Color borderColor;
    if (widget.hasError) {
      borderColor = t.danger;
    } else if (focused) {
      borderColor = t.accent;
    } else {
      borderColor = t.fieldBorder;
    }

    return Semantics(
      label: widget.semanticLabel,
      textField: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: EdgeInsets.symmetric(horizontal: widget.compact ? 12.w : 14.w),
        decoration: BoxDecoration(
          color: t.softSurface,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: borderColor,
            width: focused || widget.hasError ? 1.5.w : 1.w,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                keyboardType: const TextInputType.numberWithOptions(),
                textInputAction: widget.textInputAction,
                inputFormatters: <TextInputFormatter>[
                  ThousandsSeparatorFormatter(),
                ],
                textAlign: widget.compact ? TextAlign.end : TextAlign.start,
                style: style,
                cursorColor: t.accent,
                // Keeps the field clear of the review bar and the keyboard.
                scrollPadding: EdgeInsets.only(bottom: 140.h),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: widget.compact ? 11.h : 13.h,
                  ),
                  hintText: '0',
                  hintStyle: style.copyWith(color: t.secondaryText),
                ),
                onChanged: (text) =>
                    widget.onChanged(SetupCurrency.parse(text)),
                onTapOutside: (_) => _focusNode.unfocus(),
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              SetupCurrency.symbol,
              style: style.copyWith(color: t.secondaryText),
            ),
          ],
        ),
      ),
    );
  }
}
