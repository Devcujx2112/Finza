import 'package:app/src/core/color/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.lightBackgroundColor,
    textTheme: TextTheme(
      bodyMedium: TextStyle(
          color: AppColors.lightTextColor,
          fontSize: 18.sp,
          fontWeight: FontWeight.w400,
          fontFamily: 'Roboto'),
      bodyLarge: TextStyle(
          color: AppColors.lightTextColor,
          fontSize: 22.sp,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto'),
      bodySmall: TextStyle(
          color: AppColors.lightTextColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          fontFamily: 'Roboto'),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.darkPrimaryColor,
    scaffoldBackgroundColor: AppColors.darkBackgroundColor,
    textTheme: TextTheme(
      bodyMedium: TextStyle(
          color: AppColors.darkTextColor,
          fontSize: 18.sp,
          fontWeight: FontWeight.w400,
          fontFamily: 'Roboto'),
      bodyLarge: TextStyle(
          color: AppColors.darkTextColor,
          fontSize: 22.sp,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto'),
      bodySmall: TextStyle(
          color: AppColors.darkTextColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          fontFamily: 'Roboto'),
    ),
  );
}
