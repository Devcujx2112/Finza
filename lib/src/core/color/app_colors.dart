import 'package:flutter/material.dart';

class AppColors {
  //light theme colors
  static const Color primaryColor = Color(0xFFF1FFF3);
  static const Color primarySecondaryColor = Color(0xFF35C55F);
  static const Color lightTextColor = Color(0xFF0E3E3E);

  //dark theme colors
  static const Color darkPrimaryColor = Color(0xFF093030);
  static const Color transparentColor = Color(0x00000000);

  static const Color backgroundMenu = Color(0xFFDFF7E2);
  static const Color colorMenuBar = Color(0xFF052224);
  static const Color backgroundHomepage = Color(0xFF00D09E);

  static const Color buttonLogin = Color(0xFF4BD573);
  static const Color buttonRegister = Color(0xFFFFFFFF);
  static const Color textColor = Color(0xFF4B4544);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color white70 = Color(0xB3FFFFFF);
  static const Color white10 = Color(0x1AFFFFFF);
  static const Color iconColor = Color(0xFF9E9E9E);
  static const Color blackColor = Color(0xFF000000);
  static const Color black12 = Color(0x1F000000);
  static const Color black54 = Color(0x8A000000);
  static const Color black87 = Color(0xDD000000);
  static const Color greyColor = Color(0xFF9E9E9E);
  static const Color greyShade200 = Color(0xFFEEEEEE);
  static const Color greyShade300 = Color(0xFFE0E0E0);
  static const Color greyShade400 = Color(0xFFBDBDBD);
  static const Color greyShade500 = Color(0xFF9E9E9E);
  static const Color greyShade600 = Color(0xFF757575);
  static const Color greyShade700 = Color(0xFF616161);
  static const Color redColor = Color(0xFFF44336);
  static const Color greenColor = Color(0xFF4CAF50);

  static const Color errorColor = Color(0xFFE53935);
  static const Color notificationSuccess = Color(0xFF10B981);
  static const Color notificationWarning = Color(0xFFF59E0B);
  static const Color notificationError = Color(0xFFEF4444);

  // Auth screen premium colors
  static const Color accentGreen = Color(0xFF2ABF5E);
  static const Color accentGreenDark = Color(0xFF1A9E47);
  static const Color subtitleGrey = Color(0xFF8E8E93);
  static const Color softGreenBg = Color(0xFFE8F9ED);

  // Profile screen colors
  static const Color profileDarkBackground = Color(0xFF051C1C);
  static const Color profileLightBackground = Color(0xFFF6F9F7);
  static const Color profileDarkSurface = Color(0xFF0C2B2B);
  static const Color profileDestructiveDark = Color(0xFFFF6B6B);
  static const Color profileDestructiveDarkBg = Color(0xFF3A1E1E);
  static const Color profileDestructiveLightBg = Color(0xFFFFEBEE);
  static const Color profileDarkIconGreen = Color(0xFF5CD883);

  // Homepage colors
  static const Color homeLightBackground = Color(0xFFF4F7F2);
  static const Color homeDarkBackground = Color(0xFF061C1C);
  static const Color homeHeroStart = Color(0xFF063B3D);
  static const Color homeHeroEnd = Color(0xFF0E5F54);
  static const Color homeSurface = Color(0xFFFFFFFF);
  static const Color homeDarkSurface = Color(0xFF0B2B2B);
  static const Color homeSoftSurface = Color(0xFFEAF6EF);
  static const Color homeDarkSoftSurface = Color(0xFF123B38);
  static const Color homeMutedText = Color(0xFF6F7F78);
  static const Color homeDarkMutedText = Color(0xFFB8C8C1);
  static const Color homeAccentBlue = Color(0xFF276EF1);
  static const Color homeAccentOrange = Color(0xFFE97845);
  static const Color homeExpenseSoft = Color(0xFFEAF1FF);
  static const Color homeBalanceSoft = Color(0xFFE8F8EE);
  static const Color homeBudgetTrack = Color(0xFFDCE8E1);
  static const Color homeTimelineTrack = Color(0xFFD7E4DE);

  // Schedule colors. The holiday tone is reserved for system events, so it
  // is never offered in the user event palette.
  static const Color scheduleHoliday = Color(0xFFD64545); // 5.7:1 on white
  static const Color scheduleHolidayDark = Color(0xFFFF8A80); // 6.6:1 on dark surface
  static const Color scheduleHolidaySoft = Color(0xFFFDECEC);
  static const Color scheduleHolidayDarkSoft = Color(0xFF3A2424);
  // Fill behind white text (selected day, primary buttons): the brand green
  // only reaches 2.3:1 with white, this one reaches 5.1:1.
  static const Color scheduleAction = Color(0xFF0E8038);

  // Onboarding setup colors.
  // The questionnaire runs before the user can reach the theme switch in
  // Settings, so it is designed light only. These tones are lighter and
  // fresher than the home palette while still clearing WCAG AA: the
  // contrast ratio against the surface each one sits on is noted.
  static const Color setupPrimaryText = Color(0xFF0B2B26); // 15.2:1 on white
  static const Color setupSecondaryText = Color(0xFF63756E); // 4.9:1 on white
  static const Color setupFieldSurface = Color(0xFFF4F8F6);
  static const Color setupBorder = Color(0xFFE1EBE6);
  static const Color setupControlOutline = Color(0xFFCFDCD5);
  static const Color setupAction = Color(0xFF0E8038); // 5.1:1 with white text
  static const Color setupActionDisabled = Color(0xFFEDF3F0);
  static const Color setupActionDisabledLabel = Color(0xFF5F7168); // 4.6:1
  static const Color setupErrorText = Color(0xFFC62828); // 4.9:1 on its tint
}
