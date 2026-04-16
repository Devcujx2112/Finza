import 'package:app/gen/fonts.gen.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/router/router_name.dart';
import 'package:app/src/core/color/app_colors.dart';
import 'package:app/src/core/widget/adaptive_page.dart';
import 'package:app/src/feature/auth/forgot_password/forgot_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView>
    with AdaptivePage {
  final ForgotPasswordController _controller = ForgotPasswordController();
  @override
  Widget build(BuildContext context) {
    return adaptiveBody(context);
  }

  @override
  Widget mobileLandscapeBody(BuildContext context, Size size) {
    return mobileScreen();
  }

  @override
  Widget mobilePortraitBody(BuildContext context, Size size) {
    return mobileScreen();
  }

  @override
  Widget tabletLandscapeBody(BuildContext context, Size size) {
    return tabletScreen();
  }

  @override
  Widget tabletPortraitBody(BuildContext context, Size size) {
    return tabletScreen();
  }

  Widget mobileScreen() {
    final appLocal = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primarySecondaryColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.buttonRegister,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      backgroundColor: AppColors.primarySecondaryColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsetsGeometry.only(bottom: 40.h),
                      child: Text(
                        appLocal.forgotPassword,
                        style: TextStyle(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkPrimaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(flex: 7, child: _buildFormForgotPassword(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormForgotPassword(BuildContext context) {
    final appLocal = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 50.h),
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(45),
          topRight: Radius.circular(45),
        ),
      ),
      child: Column(
        spacing: 5.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${appLocal?.resetPassword}?',
                  style: TextStyle(
                    fontSize: 22.sp,
                    color: AppColors.darkPrimaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  appLocal?.enterYourEmailOrPhoneToReset ?? '',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Form(
              child: Column(
                spacing: 5.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsGeometry.only(left: 5.w),
                    child: Text(
                      appLocal?.phoneNumberOrEmail ?? '',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TapRegion(
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: TextFormField(
                      validator: (value) {
                        return _controller.validatorUserName(value);
                      },
                      cursorColor: AppColors.textColor,
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 16.sp,
                      ),
                      controller: _controller.userNameController,
                      decoration: InputDecoration(
                        hintText: appLocal?.exampleEmail,
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.sp,
                          fontFamily: FontFamily.roboto,
                          fontWeight: FontWeight(500),
                        ),
                        filled: true,
                        fillColor: AppColors.backgroundMenu,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide(
                            color: AppColors.transparentColor,
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide(
                            color: AppColors.transparentColor,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide(
                            color: AppColors.transparentColor,
                            width: 1,
                          ),
                        ),

                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: SizedBox(
                height: 45.h,
                width: 180.w,
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(RouterName.verifyCode);
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColors.buttonLogin,
                    minimumSize: Size(double.infinity, 40.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  child: Text(
                    appLocal?.nextStep ?? '',
                    style: TextStyle(
                      fontFamily: FontFamily.roboto,
                      color: AppColors.buttonRegister,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget tabletScreen() {
    return Container();
  }
}
