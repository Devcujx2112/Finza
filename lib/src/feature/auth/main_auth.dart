import 'package:app/gen/assets.gen.dart';
import 'package:app/gen/fonts.gen.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/router/router_name.dart';
import 'package:app/src/core/color/app_colors.dart';
import 'package:app/src/core/widget/adaptive_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class MainAuth extends StatefulWidget {
  const MainAuth({super.key});

  @override
  State<MainAuth> createState() => _MainAuthState();
}

class _MainAuthState extends State<MainAuth> with AdaptivePage {
  @override
  Widget build(BuildContext context) {
    return adaptiveBody(context);
  }

  @override
  Widget mobileLandscapeBody(BuildContext context, Size size) {
    return mobileScreen(context);
  }

  @override
  Widget mobilePortraitBody(BuildContext context, Size size) {
    return mobileScreen(context);
  }

  @override
  Widget tabletLandscapeBody(BuildContext context, Size size) {
    return tabletScreen();
  }

  @override
  Widget tabletPortraitBody(BuildContext context, Size size) {
    return tabletScreen();
  }

  Widget mobileScreen(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.w),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // --- Logo with glowing gradient circle ---
              Container(
                padding: EdgeInsets.all(28.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.softGreenBg, AppColors.primaryColor],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentGreen.withOpacity(0.25),
                      blurRadius: 40,
                      spreadRadius: 12,
                      offset: const Offset(0, 16),
                    ),
                    BoxShadow(
                      color: AppColors.accentGreen.withOpacity(0.10),
                      blurRadius: 80,
                      spreadRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Assets.images.logoApp.svg(height: 110.h, width: 110.w),
              ),

              SizedBox(height: 32.h),

              // --- App name with floating shadow effect ---
              Text(
                appLocalizations.appName,
                style: TextStyle(
                  fontFamily: FontFamily.roboto,
                  color: AppColors.accentGreen,
                  fontSize: 52.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                  shadows: [
                    Shadow(
                      color: AppColors.accentGreen.withOpacity(0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                    Shadow(
                      color: AppColors.accentGreenDark.withOpacity(0.15),
                      blurRadius: 40,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10.h),

              // --- Tagline ---
              Text(
                appLocalizations.textSignature,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: FontFamily.roboto,
                  color: AppColors.subtitleGrey,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.3,
                  height: 1.5,
                ),
              ),

              const Spacer(flex: 3),

              // --- Login button with gradient ---
              Container(
                height: 58.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  gradient: const LinearGradient(
                    colors: [AppColors.accentGreen, AppColors.buttonLogin],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentGreen.withOpacity(0.4),
                      blurRadius: 16,
                      spreadRadius: 0,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.toNamed(RouterName.login);
                  },
                  icon: Icon(
                    Icons.login_rounded,
                    color: AppColors.whiteColor,
                    size: 22.sp,
                  ),
                  label: Text(
                    appLocalizations.login,
                    style: TextStyle(
                      fontFamily: FontFamily.roboto,
                      color: AppColors.whiteColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColors.transparentColor,
                    shadowColor: AppColors.transparentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // --- Sign Up button (outlined) ---
              SizedBox(
                height: 58.h,
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Get.toNamed(RouterName.signUp);
                  },
                  icon: Icon(
                    Icons.person_add_alt_1_rounded,
                    color: AppColors.accentGreen,
                    size: 22.sp,
                  ),
                  label: Text(
                    appLocalizations.signUp,
                    style: TextStyle(
                      fontFamily: FontFamily.roboto,
                      color: AppColors.accentGreen,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.accentGreen, width: 2.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    backgroundColor: AppColors.softGreenBg,
                  ),
                ),
              ),

              SizedBox(height: 28.h),

              GestureDetector(
                onTap: () {
                  
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.explore_outlined,
                      color: AppColors.subtitleGrey,
                      size: 18.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      appLocalizations.tryAccount,
                      style: TextStyle(
                        fontFamily: FontFamily.roboto,
                        color: AppColors.subtitleGrey,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.subtitleGrey,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget tabletScreen() {
    return Container();
  }
}
