import 'package:app/src/feature/onboarding_setup/widgets/setup_palette.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shared motion timings. Short and eased, so moving through the flow feels
/// continuous without pulling attention away from the question.
class SetupMotion {
  const SetupMotion._();

  static const Duration selection = Duration(milliseconds: 180);
  static const Duration reveal = Duration(milliseconds: 240);
  static const Duration stepChange = Duration(milliseconds: 280);
  static const Curve curve = Curves.easeOutCubic;

  /// Collapses every duration to zero when the platform asks for reduced
  /// motion, so the flow still works without any movement.
  static Duration resolve(BuildContext context, Duration duration) =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false
      ? Duration.zero
      : duration;
}

/// Wraps a tappable surface with a small push-down response.
class SetupPressable extends StatefulWidget {
  const SetupPressable({
    super.key,
    required this.onTap,
    required this.child,
    this.scale = 0.985,
  });

  final VoidCallback? onTap;
  final Widget child;
  final double scale;

  @override
  State<SetupPressable> createState() => _SetupPressableState();
}

class _SetupPressableState extends State<SetupPressable> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (widget.onTap == null || _isPressed == value) return;
    setState(() => _isPressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _isPressed ? widget.scale : 1,
        duration: SetupMotion.resolve(context, SetupMotion.selection),
        curve: SetupMotion.curve,
        child: widget.child,
      ),
    );
  }
}

/// Back control, step counter and progress line. A plain icon rather than a
/// filled circle, so the header stays quiet under the question.
class SetupHeader extends StatelessWidget {
  const SetupHeader({
    super.key,
    required this.palette,
    required this.stepNumber,
    required this.stepCount,
    required this.canGoBack,
    required this.onBack,
    required this.backLabel,
  });

  final SetupPalette palette;
  final int stepNumber;
  final int stepCount;
  final bool canGoBack;
  final VoidCallback onBack;
  final String backLabel;

  @override
  Widget build(BuildContext context) {
    final progress = stepCount <= 0 ? 0.0 : stepNumber / stepCount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 44.h,
          child: Row(
            children: <Widget>[
              if (canGoBack)
                Semantics(
                  button: true,
                  label: backLabel,
                  child: SetupPressable(
                    onTap: onBack,
                    scale: 0.9,
                    child: Padding(
                      padding: EdgeInsets.only(right: 12.w),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        size: 22.sp,
                        color: palette.primaryText,
                      ),
                    ),
                  ),
                ),
              const Spacer(),
              Text(
                '$stepNumber / $stepCount',
                style: SetupText.stepCounter(palette),
              ),
            ],
          ),
        ),
        SizedBox(height: 4.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(999.r),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: progress.clamp(0.0, 1.0)),
            duration: SetupMotion.resolve(context, SetupMotion.stepChange),
            curve: SetupMotion.curve,
            builder: (context, value, child) => LinearProgressIndicator(
              value: value,
              minHeight: 3.h,
              backgroundColor: palette.progressTrack,
              valueColor: AlwaysStoppedAnimation<Color>(palette.accentStrong),
            ),
          ),
        ),
      ],
    );
  }
}

/// The question and its supporting line, the top of every step.
class SetupStepHeader extends StatelessWidget {
  const SetupStepHeader({
    super.key,
    required this.title,
    this.description,
    required this.palette,
  });

  final String title;
  final String? description;
  final SetupPalette palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: SetupText.question(palette)),
        if (description != null) ...<Widget>[
          SizedBox(height: 10.h),
          Text(description!, style: SetupText.description(palette)),
        ],
      ],
    );
  }
}

/// A selectable row. Reads as a selection control rather than a button: a
/// quiet tinted field at rest, and an unmistakable tinted, outlined and
/// ticked state once chosen.
class SetupSelectionTile extends StatelessWidget {
  const SetupSelectionTile({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.palette,
    this.description,
    this.icon,
  });

  final String title;
  final String? description;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;
  final SetupPalette palette;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      child: SetupPressable(
        onTap: onTap,
        child: AnimatedContainer(
          duration: SetupMotion.resolve(context, SetupMotion.selection),
          curve: SetupMotion.curve,
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: isSelected ? palette.accentSoft : palette.fieldSurface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isSelected ? palette.accent : palette.border,
              width: isSelected ? 1.5.w : 1.w,
            ),
          ),
          child: Row(
            children: <Widget>[
              if (icon != null) ...<Widget>[
                Icon(
                  icon,
                  size: 22.sp,
                  color: isSelected ? palette.accent : palette.secondaryText,
                ),
                SizedBox(width: 14.w),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, style: SetupText.optionTitle(palette)),
                    if (description != null) ...<Widget>[
                      SizedBox(height: 4.h),
                      Text(description!, style: SetupText.optionBody(palette)),
                    ],
                  ],
                ),
              ),
              SizedBox(width: 14.w),
              SetupSelectionMark(isSelected: isSelected, palette: palette),
            ],
          ),
        ),
      ),
    );
  }
}

class SetupSelectionMark extends StatelessWidget {
  const SetupSelectionMark({
    super.key,
    required this.isSelected,
    required this.palette,
    this.size,
  });

  final bool isSelected;
  final SetupPalette palette;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final diameter = size ?? 22.r;
    return AnimatedContainer(
      duration: SetupMotion.resolve(context, SetupMotion.selection),
      curve: SetupMotion.curve,
      height: diameter,
      width: diameter,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? palette.accent : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? palette.accent : palette.controlOutline,
          width: 1.5.w,
        ),
      ),
      child: isSelected
          ? Icon(
              Icons.check_rounded,
              size: diameter * 0.6,
              color: palette.onAccent,
            )
          : const SizedBox.shrink(),
    );
  }
}

/// Compact selectable pill, for days of the month and preset amounts.
class SetupChoiceChip extends StatelessWidget {
  const SetupChoiceChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.palette,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final SetupPalette palette;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      child: SetupPressable(
        onTap: onTap,
        scale: 0.96,
        child: AnimatedContainer(
          duration: SetupMotion.resolve(context, SetupMotion.selection),
          curve: SetupMotion.curve,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? palette.accentSoft : palette.fieldSurface,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isSelected ? palette.accent : palette.border,
              width: isSelected ? 1.5.w : 1.w,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (isSelected) ...<Widget>[
                Icon(Icons.check_rounded, size: 15.sp, color: palette.accent),
                SizedBox(width: 6.w),
              ],
              Text(
                label,
                style: SetupText.optionTitle(palette).copyWith(
                  fontSize: 13.5.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Primary action at the bottom of every step. One flat fill, one soft
/// shadow tinted to its own hue, no gradient.
class SetupPrimaryButton extends StatelessWidget {
  const SetupPrimaryButton({
    super.key,
    required this.label,
    required this.isEnabled,
    required this.onTap,
    required this.palette,
    this.isBusy = false,
  });

  final String label;
  final bool isEnabled;
  final VoidCallback onTap;
  final SetupPalette palette;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    final isActive = isEnabled && !isBusy;
    return Semantics(
      button: true,
      enabled: isActive,
      label: label,
      child: SetupPressable(
        onTap: isActive ? onTap : null,
        child: AnimatedContainer(
          duration: SetupMotion.resolve(context, SetupMotion.selection),
          curve: SetupMotion.curve,
          height: 54.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? palette.actionFill : palette.actionDisabledFill,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: isActive
                ? <BoxShadow>[
                    BoxShadow(
                      color: palette.actionFill.withValues(alpha: 0.18),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: isBusy
              ? SizedBox(
                  height: 20.r,
                  width: 20.r,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      palette.actionDisabledLabel,
                    ),
                  ),
                )
              : Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: SetupText.button(
                    isActive
                        ? palette.actionLabel
                        : palette.actionDisabledLabel,
                  ),
                ),
        ),
      ),
    );
  }
}

/// How firmly an inline message is pitched. Something the user still has to
/// do reads as guidance; something they got wrong reads as an error.
enum SetupMessageTone { guidance, error }

/// Inline message explaining why the step cannot be completed yet.
class SetupValidationMessage extends StatelessWidget {
  const SetupValidationMessage({
    super.key,
    required this.message,
    required this.palette,
    this.tone = SetupMessageTone.error,
  });

  final String? message;
  final SetupPalette palette;
  final SetupMessageTone tone;

  @override
  Widget build(BuildContext context) {
    final text = message;
    final isError = tone == SetupMessageTone.error;
    return AnimatedSize(
      duration: SetupMotion.resolve(context, SetupMotion.reveal),
      curve: SetupMotion.curve,
      alignment: Alignment.topCenter,
      child: text == null
          ? const SizedBox(width: double.infinity)
          : Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
              decoration: BoxDecoration(
                color: isError ? palette.errorSurface : palette.fieldSurface,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    isError
                        ? Icons.error_outline_rounded
                        : Icons.info_outline_rounded,
                    size: 17.sp,
                    color: isError ? palette.errorText : palette.accentStrong,
                  ),
                  SizedBox(width: 9.w),
                  Expanded(
                    child: Text(
                      text,
                      style: SetupText.validation(palette).copyWith(
                        color: isError
                            ? palette.errorText
                            : palette.primaryText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

/// A quiet grouping surface. Flat fill, hairline border, no elevation, used
/// only where content genuinely needs to be set apart from the page.
class SetupPanel extends StatelessWidget {
  const SetupPanel({
    super.key,
    required this.child,
    required this.palette,
    this.padding,
  });

  final Widget child;
  final SetupPalette palette;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.symmetric(horizontal: 18.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: palette.fieldSurface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: child,
    );
  }
}

/// One line of the income breakdown shown before allocation.
class SetupLedgerRow extends StatelessWidget {
  const SetupLedgerRow({
    super.key,
    required this.label,
    required this.value,
    required this.palette,
    this.isTotal = false,
  });

  final String label;
  final String value;
  final SetupPalette palette;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.h),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: isTotal
                  ? SetupText.ledgerValue(
                      palette,
                    ).copyWith(fontWeight: FontWeight.w600)
                  : SetupText.ledgerLabel(palette),
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            value,
            style: isTotal
                ? SetupText.ledgerValue(palette).copyWith(
                    color: palette.accentStrong,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  )
                : SetupText.ledgerValue(palette),
          ),
        ],
      ),
    );
  }
}

/// Hairline divider, used sparingly to separate a total from its inputs.
class SetupHairline extends StatelessWidget {
  const SetupHairline({super.key, required this.palette});

  final SetupPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      color: palette.border,
    );
  }
}
