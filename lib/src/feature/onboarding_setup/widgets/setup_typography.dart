import 'package:app/src/feature/onboarding_setup/widgets/setup_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// The type scale for the setup flow, in the app's Poppins.
///
/// The question carries the screen, so it sits well above everything else;
/// the description steps down in both size and weight so the two never
/// compete for attention.
class SetupText {
  const SetupText._();

  static TextStyle question(SetupPalette palette) => GoogleFonts.poppins(
    color: palette.primaryText,
    fontSize: 25.sp,
    fontWeight: FontWeight.w700,
    height: 1.32,
    letterSpacing: -0.3,
  );

  static TextStyle description(SetupPalette palette) => GoogleFonts.poppins(
    color: palette.secondaryText,
    fontSize: 13.5.sp,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static TextStyle optionTitle(SetupPalette palette) => GoogleFonts.poppins(
    color: palette.primaryText,
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static TextStyle optionBody(SetupPalette palette) => GoogleFonts.poppins(
    color: palette.secondaryText,
    fontSize: 12.5.sp,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle sectionTitle(SetupPalette palette) => GoogleFonts.poppins(
    color: palette.primaryText,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    height: 1.35,
  );

  static TextStyle amount(SetupPalette palette) => GoogleFonts.poppins(
    color: palette.accentStrong,
    fontSize: 28.sp,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static TextStyle fieldLabel(SetupPalette palette) => GoogleFonts.poppins(
    color: palette.secondaryText,
    fontSize: 12.5.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle ledgerLabel(SetupPalette palette) => GoogleFonts.poppins(
    color: palette.secondaryText,
    fontSize: 13.5.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle ledgerValue(SetupPalette palette) => GoogleFonts.poppins(
    color: palette.primaryText,
    fontSize: 13.5.sp,
    fontWeight: FontWeight.w500,
  );

  /// The step counter in the header, kept quiet next to the question.
  static TextStyle stepCounter(SetupPalette palette) => GoogleFonts.poppins(
    color: palette.secondaryText,
    fontSize: 13.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle button(Color color) => GoogleFonts.poppins(
    color: color,
    fontSize: 15.5.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  static TextStyle validation(SetupPalette palette) => GoogleFonts.poppins(
    color: palette.errorText,
    fontSize: 12.5.sp,
    fontWeight: FontWeight.w500,
    height: 1.45,
  );
}
