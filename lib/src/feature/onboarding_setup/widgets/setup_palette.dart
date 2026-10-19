import 'package:app/src/core/color/app_colors.dart';
import 'package:flutter/material.dart';

@immutable
class SetupPalette {
  const SetupPalette._();

  factory SetupPalette.of(BuildContext context) => const SetupPalette._();

  Color get pageBackground => AppColors.whiteColor;

  Color get fieldSurface => AppColors.setupFieldSurface;

  Color get primaryText => AppColors.setupPrimaryText;
  Color get secondaryText => AppColors.setupSecondaryText;

  Color get border => AppColors.setupBorder;

  Color get controlOutline => AppColors.setupControlOutline;

  Color get accent => AppColors.accentGreenDark;

  Color get accentSoft => AppColors.softGreenBg;

  Color get accentStrong => AppColors.setupAction;

  Color get onAccent => AppColors.whiteColor;

  Color get actionFill => AppColors.setupAction;
  Color get actionLabel => AppColors.whiteColor;
  Color get actionDisabledFill => AppColors.setupActionDisabled;
  Color get actionDisabledLabel => AppColors.setupActionDisabledLabel;

  Color get errorText => AppColors.setupErrorText;
  Color get errorSurface => AppColors.profileDestructiveLightBg;

  Color get progressTrack => AppColors.setupBorder;
}
