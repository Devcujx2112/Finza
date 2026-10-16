import 'package:app/src/core/color/app_colors.dart';
import 'package:app/src/feature/main_controller/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// Colours and text styles for the spending plan screens, resolved once per
/// theme from the palette the Home and Settings screens already use.
///
/// Unlike the setup questionnaire, these screens are reached from Settings
/// after the user may have switched to dark mode, so every token has both
/// variants.
@immutable
class SpendingPatternTokens {
  const SpendingPatternTokens(this.isDark);

  factory SpendingPatternTokens.of(BuildContext context) {
    final themeIsDark = Theme.of(context).brightness == Brightness.dark;
    final appIsDark =
        Get.isRegistered<MainController>() &&
        Get.find<MainController>().isDarkMode;
    return SpendingPatternTokens(themeIsDark || appIsDark);
  }

  final bool isDark;

  Color get page =>
      isDark ? AppColors.homeDarkBackground : AppColors.homeLightBackground;

  Color get surface =>
      isDark ? AppColors.homeDarkSurface : AppColors.homeSurface;

  /// Fill for inputs and icon tiles, one step away from [surface].
  Color get softSurface =>
      isDark ? AppColors.homeDarkSoftSurface : AppColors.homeSoftSurface;

  Color get primaryText =>
      isDark ? AppColors.primaryColor : AppColors.lightTextColor;

  Color get secondaryText =>
      isDark ? AppColors.homeDarkMutedText : AppColors.homeMutedText;

  /// Hairline around cards, matching the Settings cards.
  Color get border => isDark
      ? AppColors.whiteColor.withValues(alpha: 0.08)
      : AppColors.blackColor.withValues(alpha: 0.06);

  /// Input outline at rest. Stronger than [border] so a field never sinks
  /// into the card in dark mode.
  Color get fieldBorder => isDark
      ? AppColors.whiteColor.withValues(alpha: 0.14)
      : AppColors.homeTimelineTrack;

  /// Icons, focus rings and share bars.
  Color get accent =>
      isDark ? AppColors.profileDarkIconGreen : AppColors.accentGreenDark;

  /// Green text for text buttons. The brand green is too light to read as
  /// text on the light page, so light mode uses the action green.
  Color get link =>
      isDark ? AppColors.profileDarkIconGreen : AppColors.setupAction;

  Color get accentSoft => isDark
      ? AppColors.primarySecondaryColor.withValues(alpha: 0.14)
      : AppColors.softGreenBg;

  /// Fill behind white text. The brand green only reaches 2.3:1 with white.
  Color get action => AppColors.setupAction;

  Color get actionDisabled => isDark
      ? AppColors.whiteColor.withValues(alpha: 0.08)
      : AppColors.setupActionDisabled;

  Color get actionDisabledLabel => isDark
      ? AppColors.homeDarkMutedText.withValues(alpha: 0.7)
      : AppColors.setupActionDisabledLabel;

  Color get danger =>
      isDark ? AppColors.profileDestructiveDark : AppColors.setupErrorText;

  Color get dangerSoft => isDark
      ? AppColors.profileDestructiveDarkBg
      : AppColors.profileDestructiveLightBg;

  /// Budget still waiting to be split is guidance, not an error.
  Color get guidance =>
      isDark ? AppColors.notificationWarning : AppColors.planGuidanceText;

  /// The "applies from next month" block. It has to stay the most visible
  /// thing on the edit screen in both themes, so dark mode gets an outline.
  Color get noticeSurface => isDark
      ? AppColors.primarySecondaryColor.withValues(alpha: 0.12)
      : AppColors.softGreenBg;

  Color get noticeBorder => isDark
      ? AppColors.primarySecondaryColor.withValues(alpha: 0.35)
      : AppColors.primarySecondaryColor.withValues(alpha: 0.25);

  List<BoxShadow> get cardShadow => <BoxShadow>[
    BoxShadow(
      color: AppColors.blackColor.withValues(alpha: isDark ? 0.18 : 0.03),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  BoxDecoration card() => BoxDecoration(
    color: surface,
    borderRadius: BorderRadius.circular(24.r),
    border: Border.all(color: border, width: 1.w),
    boxShadow: cardShadow,
  );

  TextStyle text(
    double size, {
    FontWeight weight = FontWeight.w500,
    Color? color,
    double? height,
  }) {
    return GoogleFonts.poppins(
      color: color ?? primaryText,
      fontSize: size.sp,
      fontWeight: weight,
      height: height,
    );
  }

  /// Small uppercase label above a group, as on the Settings screen.
  TextStyle sectionLabel() => GoogleFonts.poppins(
    fontSize: 10.5.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.1,
    color: secondaryText,
  );
}
