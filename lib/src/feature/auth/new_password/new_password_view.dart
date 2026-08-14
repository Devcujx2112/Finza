import 'package:app/l10n/app_localizations.dart';
import 'package:app/src/core/color/app_colors.dart';
import 'package:app/src/core/widget/adaptive_page.dart';
import 'package:app/src/feature/auth/new_password/new_password_controller.dart';
import 'package:app/src/feature/widget/form_notification_message.dart';
import 'package:app/src/feature/widget/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NewPasswordView extends StatefulWidget {
  const NewPasswordView({super.key});

  @override
  State<NewPasswordView> createState() => _NewPasswordViewState();
}

class _NewPasswordViewState extends State<NewPasswordView> with AdaptivePage {
  final NewPasswordController _controller = Get.find<NewPasswordController>();

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
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Obx(
      () => LoadingOverlay(
        isLoading: _controller.isLoading,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: AppColors.transparentColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.whiteColor,
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ),
          backgroundColor: AppColors.primarySecondaryColor,
          body: Container(
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primarySecondaryColor,
                  AppColors.buttonLogin,
                ],
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: isKeyboardOpen ? 140.h : 230.h,
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 50.w,
                          top: isKeyboardOpen ? 60.h : 100.h,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appLocal.newPassword,
                              style: TextStyle(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.whiteColor,
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            if (!isKeyboardOpen)
                              Text(
                                appLocal.resetPassword,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.whiteColor.withOpacity(0.9),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _buildFormNewPassword(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormNewPassword(BuildContext context) {
    final appLocal = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height - 230.h,
      ),
      padding: EdgeInsets.fromLTRB(30.w, 40.h, 30.w, 40.h),
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black12,
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: TapRegion(
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        child: Form(
          key: _controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10.h),
              _buildFormItem(
                label: appLocal.newPassword,
                hintText: '••••••••',
                icon: Icons.lock_outline_rounded,
                controllerText: _controller.passwordController,
                isPassword: true,
                validator: (value) =>
                    _controller.validateInput(value, true, context),
                focusNode: _controller.passwordFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: () {
                  FocusScope.of(
                    context,
                  ).requestFocus(_controller.confirmPasswordFocus);
                },
              ),
              SizedBox(height: 16.h),
              _buildFormItem(
                label: appLocal.confirmPassword,
                hintText: '••••••••',
                icon: Icons.lock_outline_rounded,
                controllerText: _controller.confirmPasswordController,
                isPassword: true,
                isConfirmPassword: true,
                validator: (value) =>
                    _controller.validateInput(value, false, context),
                focusNode: _controller.confirmPasswordFocus,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: () {
                  FocusScope.of(context).unfocus();
                },
              ),
              SizedBox(height: 40.h),
              SizedBox(
                height: 48.h,
                child: Obx(() {
                  final isLoading = _controller.isLoading;
                  return ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            FocusScope.of(context).unfocus();
                            _controller.isSubmitted.value = true;
                            if (_controller.formKey.currentState!.validate()) {
                              if (!_controller.isConfirmPasswordMatched) {
                                showFormMessageDialog(
                                  context,
                                  type: FormMessageType.error,
                                  title: appLocal.validatorPasswordConfirm,
                                );
                                return;
                              }
                              _controller.changePassword(
                                onError: (message) => showFormMessageDialog(
                                  context,
                                  type: FormMessageType.error,
                                  title: message,
                                ),
                                onSuccess: (message) {
                                  showFormMessageDialog(
                                    context,
                                    type: FormMessageType.success,
                                    title: message,
                                  );
                                },
                                appLocal: appLocal,
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor: AppColors.buttonLogin
                          .withOpacity(0.7),
                      disabledForegroundColor: AppColors.whiteColor,
                      backgroundColor: AppColors.buttonLogin,
                      foregroundColor: AppColors.whiteColor,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      elevation: 4,
                      shadowColor: AppColors.buttonLogin.withOpacity(0.4),
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: CircularProgressIndicator(
                              color: AppColors.whiteColor,
                              strokeWidth: 2.5.w,
                            ),
                          )
                        : Text(
                            appLocal.changePassword,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormItem({
    required String label,
    required String hintText,
    required IconData icon,
    required TextEditingController controllerText,
    required bool isPassword,
    bool isConfirmPassword = false,
    required String? Function(String?)? validator,
    required FocusNode focusNode,
    TextInputAction? textInputAction,
    VoidCallback? onFieldSubmitted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.darkPrimaryColor.withOpacity(0.8),
            ),
          ),
        ),
        if (isPassword)
          Obx(() {
            bool hide = isConfirmPassword
                ? _controller.hideConfirmPassword.value
                : _controller.hidePassword.value;
            return _buildTextField(
              hintText: hintText,
              icon: icon,
              controllerText: controllerText,
              isPassword: isPassword,
              validator: validator,
              hide: hide,
              isConfirmPassword: isConfirmPassword,
              focusNode: focusNode,
              textInputAction: textInputAction,
              onFieldSubmitted: onFieldSubmitted,
            );
          })
        else
          _buildTextField(
            hintText: hintText,
            icon: icon,
            controllerText: controllerText,
            isPassword: isPassword,
            validator: validator,
            hide: false,
            isConfirmPassword: false,
            focusNode: focusNode,
            textInputAction: textInputAction,
            onFieldSubmitted: onFieldSubmitted,
          ),
      ],
    );
  }

  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    required TextEditingController controllerText,
    required bool isPassword,
    required String? Function(String?)? validator,
    required bool hide,
    required bool isConfirmPassword,
    required FocusNode focusNode,
    TextInputAction? textInputAction,
    VoidCallback? onFieldSubmitted,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controllerText,
        focusNode: focusNode,
        obscureText: hide,
        validator: validator,
        textInputAction: textInputAction,
        onFieldSubmitted: (_) => onFieldSubmitted?.call(),
        onChanged: (_) {
          if (_controller.isSubmitted.value) {
            _controller.formKey.currentState?.validate();
          }
        },
        cursorColor: AppColors.buttonLogin,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.textColor,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon, color: AppColors.buttonLogin, size: 22.sp),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    hide
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.iconColor,
                    size: 20.sp,
                  ),
                  onPressed: isConfirmPassword
                      ? _controller.toggleConfirmPasswordVisibility
                      : _controller.togglePasswordVisibility,
                )
              : null,
          filled: true,
          fillColor: AppColors.backgroundMenu,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: AppColors.transparentColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: AppColors.transparentColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: const BorderSide(
              color: AppColors.buttonLogin,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: const BorderSide(
              color: AppColors.errorColor,
              width: 2.0,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: const BorderSide(
              color: AppColors.errorColor,
              width: 2.0,
            ),
          ),
          errorStyle: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.errorColor,
            height: 1.2,
          ),
          hintStyle: TextStyle(color: AppColors.greyShade400, fontSize: 14.sp),
        ),
      ),
    );
  }

  Widget tabletScreen() {
    return const Scaffold();
  }
}
