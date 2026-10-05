import 'package:app/src/core/color/app_colors.dart';
import 'package:flutter/material.dart';

/// Colour tokens for the setup flow, resolved from the app's [AppColors].
///
/// The flow is light only on purpose: it runs before the user reaches the
/// theme switch in Settings, so the app is always in its default light theme
/// while these screens are on the display.
///
/// The palette is deliberately flatter than the home screen. The page is
/// white, surfaces are barely tinted, borders are hairlines, and the single
/// green accent is spent only where it carries meaning: the selected state,
/// money figures and the primary action.
@immutable
class SetupPalette {
  const SetupPalette._();

  factory SetupPalette.of(BuildContext context) => const SetupPalette._();

  /// The page itself, matching the auth screens the flow follows on from.
  Color get pageBackground => AppColors.whiteColor;

  /// Fill for controls and inputs at rest, a step away from the page rather
  /// than a card floating above it.
  Color get fieldSurface => AppColors.setupFieldSurface;

  Color get primaryText => AppColors.setupPrimaryText;
  Color get secondaryText => AppColors.setupSecondaryText;

  /// Hairline around inputs and unselected controls.
  Color get border => AppColors.setupBorder;

  /// Slightly stronger than [border], for the empty selection indicator that
  /// has to read as a control rather than as decoration.
  Color get controlOutline => AppColors.setupControlOutline;

  /// Outline and tick of a selected option.
  Color get accent => AppColors.accentGreenDark;

  /// Fill behind a selected option.
  Color get accentSoft => AppColors.softGreenBg;

  /// Emphasis colour for money figures and the progress fill.
  Color get accentStrong => AppColors.setupAction;

  Color get onAccent => AppColors.whiteColor;

  /// Primary action. A flat fill, not a gradient: the brief asks for a CTA
  /// that stands out without shouting.
  Color get actionFill => AppColors.setupAction;
  Color get actionLabel => AppColors.whiteColor;
  Color get actionDisabledFill => AppColors.setupActionDisabled;
  Color get actionDisabledLabel => AppColors.setupActionDisabledLabel;

  Color get errorText => AppColors.setupErrorText;
  Color get errorSurface => AppColors.profileDestructiveLightBg;

  /// Unfilled part of the progress line.
  Color get progressTrack => AppColors.setupBorder;
}
