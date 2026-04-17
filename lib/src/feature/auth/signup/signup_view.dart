import 'package:app/gen/fonts.gen.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/router/router_name.dart';
import 'package:app/src/core/color/app_colors.dart';
import 'package:app/src/core/widget/adaptive_page.dart';
import 'package:app/src/feature/auth/signup/signup_controller.dart';
import 'package:app/src/feature/widget/country_code_picker.dart';
import 'package:app/src/feature/widget/custom_calender.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> with AdaptivePage {
  final SignupController _controller = SignupController();
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
                      padding: EdgeInsetsGeometry.only(top: 40.h),
                      child: Text(
                        appLocal.createAccount,
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
              Expanded(flex: 4, child: _buildFormSignUp(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormSignUp(BuildContext context) {
    final appLocal = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(45),
          topRight: Radius.circular(45),
        ),
      ),
      child: Form(
        key: _controller.formKey,
        child: Column(
          spacing: 10.h,
          children: [
            _buildFormItem(
              hintText: appLocal.exampleFullName,
              label: appLocal.fullName,
              isPassword: false,
              controller: _controller.fullNameController,
              isConfirmPassword: false,
              isDateOfBirth: false,
            ),
            _buildFormItem(
              hintText: appLocal.exampleEmail,
              label: appLocal.emailName,
              isPassword: false,
              controller: _controller.emailController,
              isConfirmPassword: false,
              isDateOfBirth: false,
            ),
            _buildTextFieldPhoneNumber(context),
            _buildFormItem(
              hintText: appLocal.exampleDateOfBirth,
              label: appLocal.dateOfBirth,
              isPassword: false,
              controller: _controller.dateOfBirthController,
              isConfirmPassword: false,
              isDateOfBirth: true,
            ),
            _buildFormItem(
              hintText: '********',
              label: appLocal.password,
              isPassword: true,
              controller: _controller.passwordController,
              isConfirmPassword: false,
              isDateOfBirth: false,
            ),
            _buildFormItem(
              hintText: '********',
              label: appLocal.confirmPassword,
              isPassword: false,
              controller: _controller.confirmPasswordController,
              isConfirmPassword: true,
              isDateOfBirth: false,
            ),
            Row(
              spacing: 5.w,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  appLocal.alreadyHaveAccount,
                  style: TextStyle(
                    fontFamily: FontFamily.roboto,
                    color: AppColors.textColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight(500),
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(RouterName.login),
                  child: Text(
                    appLocal.login,
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
            Spacer(),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(fontSize: 8.sp, color: Colors.black),
                children: [
                  TextSpan(text: "${appLocal.confirmAccount}\n"),
                  TextSpan(
                    text: appLocal.termsOfUse,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: " ${appLocal.and} "),
                  TextSpan(
                    text: appLocal.privacyPolicy,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: "."),
                ],
              ),
            ),
            SizedBox(
              height: 40.h,
              width: 180.w,
              child: ElevatedButton(
                onPressed: () {
                  if (_controller.formKey.currentState!.validate()) {
                    Get.toNamed(RouterName.login);
                  }
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppColors.buttonLogin,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  appLocal.signUp,
                  style: TextStyle(
                    fontFamily: FontFamily.roboto,
                    color: AppColors.buttonRegister,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldPhoneNumber(BuildContext context) {
    final appLocal = AppLocalizations.of(context);
    return Column(
      spacing: 5.h,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.only(left: 10.w),
          child: Text(
            appLocal?.phoneNumber ?? '',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.darkPrimaryColor,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: AppColors.buttonLogin,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            children: [
              Container(
                width: 55.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.buttonLogin,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Container(
                  width: 55.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.buttonLogin,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Obx(
                    () => CountryCodePicker(
                      countries: _controller.countries,
                      selectedCode: _controller.selectedDialCode.value,
                      onSelected: (value) {
                        _controller.selectedDialCode.value = value;
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: TapRegion(
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          cursorColor: AppColors.iconColor,
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: 14.sp,
                          ),
                          controller: _controller.phoneNumberController,
                          decoration: InputDecoration(
                            hintText: appLocal?.phoneNumber,
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
                              horizontal: 12.w,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormItem({
    String? hintText,
    required String label,
    required bool isPassword,
    required TextEditingController controller,
    required bool isConfirmPassword,
    required bool isDateOfBirth,
  }) {
    return Column(
      spacing: 5.h,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.darkPrimaryColor,
            ),
          ),
        ),
        if (isPassword || isConfirmPassword || isDateOfBirth) ...[
          if (isPassword)
            TapRegion(
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Obx(() {
                return TextFormField(
                  controller: controller,
                  obscureText: _controller.hidePassword.value,
                  decoration: _inputDecoration(
                    hintText,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _controller.hidePassword.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textColor,
                      ),
                      onPressed: _controller.unHidePassword,
                    ),
                  ),
                  cursorColor: AppColors.textColor,
                  style: TextStyle(color: AppColors.textColor, fontSize: 14.sp),
                );
              }),
            ),
          if (isConfirmPassword)
            _buildTextField(
              isCalendar: false,
              hintText: hintText ?? '',
              isConfirmPassword: isConfirmPassword,
              controller: controller,
              suffixIcon: IconButton(
                icon: Icon(
                  _controller.hideConfirmPassword.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.textColor,
                ),
                onPressed: _controller.unHideConfirmPassword,
              ),
            ),
          if (isDateOfBirth)
            _buildTextField(
              isCalendar: true,
              hintText: hintText ?? '',
              isConfirmPassword: isConfirmPassword,
              controller: controller,
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_month),
                color: AppColors.textColor,
                onPressed: () async {
                  showCalendarDialog(context);
                },
              ),
            ),
        ] else
          _buildTextField(
            isCalendar: false,
            hintText: hintText ?? '',
            isConfirmPassword: isConfirmPassword,
            controller: controller,
          ),
      ],
    );
  }

  void showCalendarDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Calendar",
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 250),

      pageBuilder: (context, anim1, anim2) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Center(
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Material(
                color: Colors.transparent,
                child: Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CustomCalendar(
                    initialDate: DateTime.now(),
                    onChanged: (date) {
                      Get.back();
                      _controller.dateOfBirthController.text = DateFormat(
                        'dd/MM/yyyy',
                      ).format(date);
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },

      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0, 0.08),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic),
                ),
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required String hintText,
    required bool isConfirmPassword,
    required TextEditingController controller,
    required bool isCalendar,
    Widget? suffixIcon,
    Widget? prefix,
  }) {
    return TapRegion(
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: isConfirmPassword
          ? Obx(() {
              return TextFormField(
                controller: controller,
                obscureText: _controller.hideConfirmPassword.value,
                decoration: _inputDecoration(
                  hintText,
                  suffixIcon: suffixIcon,
                  prefix: prefix,
                ),
                cursorColor: AppColors.textColor,
                style: TextStyle(color: AppColors.textColor, fontSize: 14.sp),
              );
            })
          : TextFormField(
              readOnly: isCalendar ? true : false,
              onTap: () {},
              controller: controller,
              decoration: _inputDecoration(
                hintText,
                suffixIcon: suffixIcon,
                prefix: prefix,
              ),
              cursorColor: AppColors.textColor,
              style: TextStyle(color: AppColors.textColor, fontSize: 14.sp),
            ),
    );
  }

  InputDecoration _inputDecoration(
    String? hintText, {
    Widget? suffixIcon,
    Widget? prefix,
  }) {
    return InputDecoration(
      prefix: prefix,
      hintText: hintText,
      errorStyle: TextStyle(
        fontSize: 12.sp,
        fontFamily: FontFamily.roboto,
        fontWeight: FontWeight(500),
        color: AppColors.errorColor,
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

      contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
    );
  }

  Widget tabletScreen() {
    return Scaffold();
  }
}
