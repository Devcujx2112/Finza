import 'package:app/gen/fonts.gen.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/router/router_name.dart';
import 'package:app/src/core/color/app_colors.dart';
import 'package:app/src/core/widget/adaptive_page.dart';
import 'package:app/src/feature/auth/new_password/new_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class NewPasswordView extends StatefulWidget {
  const NewPasswordView({super.key});

  @override
  State<NewPasswordView> createState() => _NewPasswordViewState();
}

class _NewPasswordViewState extends State<NewPasswordView> with AdaptivePage {
  final NewPasswordController _controller = NewPasswordController();
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
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
                              appLocal.newPassword,
                              style: TextStyle(
                                fontSize: 30.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: FontFamily.roboto,
                                color: AppColors.darkPrimaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(flex: 7, child: _buildFormNewPassword(context)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFormNewPassword(BuildContext context) {
    final appLocal = AppLocalizations.of(context)!;
    return Container(
      height: double.infinity,
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
        spacing: 10.h,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            spacing: 5.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsGeometry.only(left: 5.w),
                child: Text(
                  appLocal.newPassword,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: FontFamily.roboto,
                    fontWeight: FontWeight(500),
                    color: AppColors.darkPrimaryColor,
                  ),
                ),
              ),
              _buildTextField(
                isPassword: true,
                controller: _controller.passwordController,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsGeometry.only(left: 5.w),
                child: Text(
                  appLocal.confirmPassword,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: FontFamily.roboto,
                    fontWeight: FontWeight(500),
                    color: AppColors.darkPrimaryColor,
                  ),
                ),
              ),
              _buildTextField(
                isPassword: false,
                controller: _controller.confirmPasswordController,
              ),
            ],
          ),
          Spacer(),
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
                minimumSize: Size(double.infinity, 40.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              child: Text(
                appLocal.login,
                style: TextStyle(
                  fontFamily: FontFamily.roboto,
                  color: AppColors.backgroundMenu,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required bool isPassword,
    required TextEditingController controller,
  }) {
    return TapRegion(
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Obx(() {
        return TextFormField(
          controller: controller,
          obscureText: isPassword
              ? _controller.hidePassword.value
              : _controller.hideConfirmPassword.value,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(
                isPassword
                    ? _controller.hidePassword.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined
                    : _controller.hideConfirmPassword.value
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.textColor,
              ),
              onPressed: () {
                isPassword
                    ? _controller.togglePasswordVisibility()
                    : _controller.toggleConfirmPasswordVisibility();
              },
            ),
            hintText: '******',
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

            contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
          ),
          cursorColor: AppColors.textColor,
          style: TextStyle(color: AppColors.textColor, fontSize: 14.sp),
        );
      }),
    );
  }

  Widget tabletScreen() {
    return Container();
  }
}
