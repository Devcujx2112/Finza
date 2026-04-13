import 'package:app/gen/fonts.gen.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/src/core/color/app_colors.dart';
import 'package:app/src/core/widget/adaptive_page.dart';
import 'package:app/src/feature/auth/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  appLocal.wellCome,
                  style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
          Expanded(flex: 3, child: _buildFormLogin(context)),
        ],
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
        spacing: 25.h,
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
        ],
      ),
    );
  }

  Widget _buildSavePassword(BuildContext context) {
    final appLocal = AppLocalizations.of(context)!;
    return Row(
      spacing: 5.w,
      mainAxisAlignment: MainAxisAlignment.end,
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
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isChecked ? AppColors.buttonLogin : Colors.transparent,
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
            fontSize: 14.sp,
            fontFamily: FontFamily.roboto,
            fontWeight: FontWeight(500),
          ),
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
          TextFormField(
            validator: (value) {
              return _controller.validatorUserName(value);
            },
            cursorColor: AppColors.textColor,
            style: TextStyle(color: AppColors.textColor, fontSize: 16.sp),
            controller: controller,
            decoration: _inputDecoration(hintText),
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
