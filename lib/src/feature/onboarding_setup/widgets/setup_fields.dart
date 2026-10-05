import 'package:app/src/feature/onboarding_setup/widgets/setup_controls.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_currency.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_palette.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Money input. Digits only, grouped as the user types, with the dong
/// suffix pinned next to the figure.
class SetupAmountField extends StatefulWidget {
  const SetupAmountField({
    super.key,
    required this.controller,
    required this.palette,
    required this.onChanged,
    this.label,
    this.hintText = '0',
    this.isLarge = false,
    this.autofocus = false,
    this.alignEnd = false,
    this.textInputAction = TextInputAction.done,
  });

  final TextEditingController controller;
  final SetupPalette palette;
  final ValueChanged<double> onChanged;
  final String? label;
  final String hintText;
  final bool isLarge;
  final bool autofocus;

  /// Right aligns the figure so amounts in a column line up.
  final bool alignEnd;
  final TextInputAction textInputAction;

  @override
  State<SetupAmountField> createState() => _SetupAmountFieldState();
}

class _SetupAmountFieldState extends State<SetupAmountField> {
  late final FocusNode _focusNode = FocusNode()..addListener(_onFocusChanged);
  bool _hasFocus = false;

  void _onFocusChanged() {
    if (!mounted) return;
    setState(() => _hasFocus = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_onFocusChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = widget.palette;
    final valueStyle = widget.isLarge
        ? SetupText.amount(palette)
        : GoogleFonts.poppins(
            color: palette.primaryText,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.label != null) ...<Widget>[
          Text(widget.label!, style: SetupText.fieldLabel(palette)),
          SizedBox(height: 8.h),
        ],
        AnimatedContainer(
          duration: SetupMotion.resolve(context, SetupMotion.selection),
          curve: SetupMotion.curve,
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: widget.isLarge ? 14.h : 4.h,
          ),
          decoration: BoxDecoration(
            color: palette.fieldSurface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: _hasFocus ? palette.accent : palette.border,
              width: _hasFocus ? 1.6.w : 1.w,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  autofocus: widget.autofocus,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: false,
                    signed: false,
                  ),
                  textInputAction: widget.textInputAction,
                  inputFormatters: <TextInputFormatter>[
                    ThousandsSeparatorFormatter(),
                  ],
                  style: valueStyle,
                  textAlign: widget.alignEnd
                      ? TextAlign.end
                      : TextAlign.start,
                  cursorColor: palette.accentStrong,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                    hintText: widget.hintText,
                    hintStyle: valueStyle.copyWith(
                      color: palette.secondaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onChanged: (value) =>
                      widget.onChanged(SetupCurrency.parse(value)),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                SetupCurrency.symbol,
                style: valueStyle.copyWith(color: palette.secondaryText),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Plain single line text input, used for the name of a fixed expense.
class SetupTextField extends StatefulWidget {
  const SetupTextField({
    super.key,
    required this.controller,
    required this.palette,
    required this.label,
    required this.hintText,
    this.autofocus = false,
    this.onChanged,
    this.textInputAction = TextInputAction.next,
  });

  final TextEditingController controller;
  final SetupPalette palette;
  final String label;
  final String hintText;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final TextInputAction textInputAction;

  @override
  State<SetupTextField> createState() => _SetupTextFieldState();
}

class _SetupTextFieldState extends State<SetupTextField> {
  late final FocusNode _focusNode = FocusNode()..addListener(_onFocusChanged);
  bool _hasFocus = false;

  void _onFocusChanged() {
    if (!mounted) return;
    setState(() => _hasFocus = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_onFocusChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = widget.palette;
    final valueStyle = GoogleFonts.poppins(
      color: palette.primaryText,
      fontSize: 14.5.sp,
      fontWeight: FontWeight.w600,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(widget.label, style: SetupText.fieldLabel(palette)),
        SizedBox(height: 8.h),
        AnimatedContainer(
          duration: SetupMotion.resolve(context, SetupMotion.selection),
          curve: SetupMotion.curve,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: palette.fieldSurface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: _hasFocus ? palette.accent : palette.border,
              width: _hasFocus ? 1.6.w : 1.w,
            ),
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            autofocus: widget.autofocus,
            textInputAction: widget.textInputAction,
            textCapitalization: TextCapitalization.sentences,
            maxLength: 40,
            style: valueStyle,
            cursorColor: palette.accentStrong,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              isDense: true,
              counterText: '',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 14.h),
              hintText: widget.hintText,
              hintStyle: valueStyle.copyWith(
                color: palette.secondaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
