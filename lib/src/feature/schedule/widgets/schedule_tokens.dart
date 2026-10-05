import 'package:app/src/core/color/app_colors.dart';
import 'package:app/src/feature/schedule/models/day_event_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Colors and text styles for the schedule screen, resolved once per theme
/// so the calendar, the day sections and the sheets cannot drift apart.
/// Surfaces and text come from the Home palette on purpose.
class ScheduleTokens {
  final bool isDark;

  const ScheduleTokens(this.isDark);

  Color get page =>
      isDark ? AppColors.homeDarkBackground : AppColors.homeLightBackground;

  Color get surface =>
      isDark ? AppColors.homeDarkSurface : AppColors.homeSurface;

  Color get softSurface =>
      isDark ? AppColors.homeDarkSoftSurface : AppColors.homeSoftSurface;

  Color get primaryText =>
      isDark ? AppColors.primaryColor : AppColors.colorMenuBar;

  Color get secondaryText =>
      isDark ? AppColors.homeDarkMutedText : AppColors.homeMutedText;

  Color get border => isDark ? AppColors.white10 : AppColors.homeTimelineTrack;

  /// Brand green for marks, icons and the today ring.
  Color get accent => AppColors.primarySecondaryColor;

  /// Darker green for anything that carries white text.
  Color get action => AppColors.scheduleAction;

  Color get holiday =>
      isDark ? AppColors.scheduleHolidayDark : AppColors.scheduleHoliday;

  Color get holidaySoft => isDark
      ? AppColors.scheduleHolidayDarkSoft
      : AppColors.scheduleHolidaySoft;

  Color get danger =>
      isDark ? AppColors.profileDestructiveDark : AppColors.errorColor;

  /// Foreground tone of a day event: the holiday red for system events, the
  /// user's own color otherwise.
  Color eventTone(DayEventModel event) =>
      event.isSystem ? holiday : DayEventPalette.tone(event.color, isDark);

  Color eventSoft(DayEventModel event) => event.isSystem
      ? holidaySoft
      : event.color.withValues(alpha: isDark ? 0.22 : 0.13);

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
}
