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
      backgroundColor: AppColors.primaryColor,
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          spacing: 5.h,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Assets.images.logoApp.svg(),
            Text(
              appLocalizations.appName,
              style: TextStyle(
                fontFamily: FontFamily.roboto,
                color: AppColors.buttonLogin,
                fontSize: 48.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              appLocalizations.textSignature,
              style: TextStyle(
                fontFamily: FontFamily.roboto,
                color: AppColors.textColor,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            SizedBox(
              height: 40.h,
              width: 180.w,
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(RouterName.login);
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppColors.buttonLogin,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  appLocalizations.login,
                  style: TextStyle(
                    fontFamily: FontFamily.roboto,
                    color: AppColors.buttonRegister,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 5.h),
            SizedBox(
              height: 40.h,
              width: 180.w,
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(RouterName.signUp);
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppColors.backgroundMenu,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  appLocalizations.signUp,
                  style: TextStyle(
                    fontFamily: FontFamily.roboto,
                    color: AppColors.textColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 3.h),
            GestureDetector(
              onTap: () {},
              child: Text(
                appLocalizations.tryAccount,
                style: TextStyle(
                  fontFamily: FontFamily.roboto,
                  color: AppColors.textColor,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w900,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.iconColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tabletScreen() {
    return Container();
  }
}
