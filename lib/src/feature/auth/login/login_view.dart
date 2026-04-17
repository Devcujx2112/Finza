import 'package:app/gen/assets.gen.dart';
import 'package:app/gen/fonts.gen.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/router/router_name.dart';
import 'package:app/src/core/color/app_colors.dart';
import 'package:app/src/core/widget/adaptive_page.dart';
import 'package:app/src/feature/auth/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with AdaptivePage {
  final LoginController _controller = LoginController();
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
                      padding: EdgeInsetsGeometry.only(top: 30.h),
                      child: Text(
                        appLocal.wellCome,
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
              Expanded(flex: 3, child: _buildFormLogin(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormLogin(BuildContext context) {
    final appLocal = AppLocalizations.of(context)!;
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
        spacing: 30.h,
        children: [
          Form(
            key: _controller.formKey,
            child: Column(
              spacing: 10.h,
              children: [
                _buildTextField(
                  context: context,
                  hintText: appLocal.exampleEmail,
                  label: appLocal.phoneNumberOrEmail,
                  isPassword: false,
                  controller: _controller.userName,
                ),
                _buildTextField(
                  context: context,
                  label: appLocal.password,
                  isPassword: true,
                  controller: _controller.password,
                ),
              ],
            ),
          ),
          _buildSavePassword(context),
          SizedBox(height: 20.h),
          Row(
            spacing: 10.w,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_controller.formKey.currentState!.validate()) {
                      Get.toNamed(RouterName.home);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColors.buttonLogin,
                    minimumSize: Size(double.infinity, 40.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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
              Assets.images.icFaceId.image(
                width: 50.w,
                height: 50.h,
                color: AppColors.buttonLogin,
              ),
            ],
          ),
          Spacer(),
          Column(
            spacing: 10.h,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                appLocal.orContinueWith,
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 10.sp,
                  fontFamily: FontFamily.roboto,
                  fontWeight: FontWeight(500),
                ),
              ),
              Row(
                spacing: 5.w,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.images.icFabLogin.svg(),
                  Assets.images.icGoogleLogin.svg(),
                ],
              ),
              Row(
                spacing: 5.w,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    appLocal.dontHaveAccount,
                    style: TextStyle(
                      fontFamily: FontFamily.roboto,
                      color: AppColors.textColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight(500),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(RouterName.signUp),
                    child: Text(
                      appLocal.signUp,
                      style: TextStyle(
                        fontFamily: FontFamily.roboto,
                        color: AppColors.buttonLogin,
                        fontSize: 12.sp,
                        fontWeight: FontWeight(500),
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.buttonLogin,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSavePassword(BuildContext context) {
    final appLocal = AppLocalizations.of(context)!;
    return Row(
      spacing: 5.w,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5.w),
          child: GestureDetector(
            onTap: () => Get.toNamed(RouterName.forgotPassword),
            child: Text(
              appLocal.forgotPassword,
              style: TextStyle(
                color: AppColors.buttonLogin,
                fontSize: 12.sp,
                fontFamily: FontFamily.roboto,
                fontWeight: FontWeight(700),
                decoration: TextDecoration.underline,
                decorationColor: AppColors.buttonLogin,
              ),
            ),
          ),
        ),
        Row(
          spacing: 5.w,
          children: [
            Obx(() {
              final isChecked = _controller.rememberPassword.value;

              return GestureDetector(
                onTap: () {
                  _controller.rememberPassword.value = !isChecked;
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  width: 20.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: isChecked
                        ? AppColors.buttonLogin
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.buttonLogin, width: 2),
                  ),
                  child: isChecked
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              );
            }),
            Text(
              appLocal.rememberPassword,
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 12.sp,
                fontFamily: FontFamily.roboto,
                fontWeight: FontWeight(500),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    String? hintText,
    required String label,
    required bool isPassword,
    required TextEditingController controller,
  }) {
    if (!isPassword) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5.h,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 14.sp,
                fontFamily: FontFamily.roboto,
                fontWeight: FontWeight(500),
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
              style: TextStyle(color: AppColors.textColor, fontSize: 16.sp),
              controller: controller,
              decoration: _inputDecoration(hintText),
            ),
          ),
        ],
      );
    }

    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5.h,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 14.sp,
                fontFamily: FontFamily.roboto,
                fontWeight: FontWeight(500),
              ),
            ),
          ),
          TextFormField(
            validator: (value) {
              return _controller.validatorPassword(value);
            },
            cursorColor: AppColors.textColor,
            style: TextStyle(color: AppColors.textColor, fontSize: 16.sp),
            controller: controller,
            obscureText: _controller.hintPassword.value,
            decoration: _inputDecoration(
              '********',
              suffixIcon: IconButton(
                icon: Icon(
                  _controller.hintPassword.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.textColor,
                ),
                onPressed: _controller.setHintPassword,
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String? hintText, {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hintText,
      errorStyle: TextStyle(
        color: AppColors.errorColor,
        fontSize: 12.sp,
        fontFamily: FontFamily.roboto,
        fontWeight: FontWeight(500),
        fontStyle: FontStyle.italic,
      ),
      hintStyle: TextStyle(
        color: Colors.grey,
        fontSize: 14.sp,
        fontFamily: FontFamily.roboto,
        fontWeight: FontWeight(500),
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.backgroundMenu,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40),
        borderSide: BorderSide(color: AppColors.transparentColor, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40),
        borderSide: BorderSide(color: AppColors.transparentColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40),
        borderSide: BorderSide(color: AppColors.transparentColor, width: 1),
      ),

      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
    );
  }

  Widget tabletScreen() {
    return Container();
  }
}
