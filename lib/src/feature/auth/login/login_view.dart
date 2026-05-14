import 'package:app/gen/assets.gen.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/router/router_name.dart';
import 'package:app/src/core/color/app_colors.dart';
import 'package:app/src/core/widget/adaptive_page.dart';
import 'package:app/src/feature/auth/login/login_controller.dart';
import 'package:app/src/feature/widget/form_notification_message.dart';
import 'package:app/src/feature/widget/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with AdaptivePage {
  final LoginController _controller = Get.find<LoginController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return adaptiveBody(context);
  }

  @override
  Widget mobileLandscapeBody(BuildContext context, Size size) =>
      mobileScreen(context);

  @override
  Widget mobilePortraitBody(BuildContext context, Size size) =>
      mobileScreen(context);

  @override
  Widget tabletLandscapeBody(BuildContext context, Size size) => tabletScreen();

  @override
  Widget tabletPortraitBody(BuildContext context, Size size) => tabletScreen();

  Widget mobileScreen(BuildContext context) {
    final appLocal = AppLocalizations.of(context)!;
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return LoadingOverlay(
      isLoading: _controller.isLoading.value,
      child: Scaffold(
        backgroundColor: AppColors.primarySecondaryColor,
        body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primarySecondaryColor, AppColors.buttonLogin],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: isKeyboardOpen ? 140.h : 250.h,
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 30.w,
                        right: 30.w,
                        top: isKeyboardOpen ? 50.h : 80.h,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appLocal.wellCome,
                            style: TextStyle(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          if (!isKeyboardOpen)
                            Text(
                              appLocal.introductionSecond,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                _buildFormLogin(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormLogin(BuildContext context) {
    final appLocal = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height - 250.h,
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
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: TapRegion(
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildFormItem(
                label: appLocal.emailName,
                hintText: appLocal.exampleEmail,
                icon: Icons.person_outline_rounded,
                controllerText: _controller.userName,
                isPassword: false,
                validator: (value) => _controller.validatorUserName(value),
                focusNode: _controller.userNameFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: () {
                  FocusScope.of(
                    context,
                  ).requestFocus(_controller.passwordFocus);
                },
              ),
              SizedBox(height: 16.h),
              _buildFormItem(
                label: appLocal.password,
                hintText: '••••••••',
                icon: Icons.lock_outline_rounded,
                controllerText: _controller.password,
                isPassword: true,
                validator: (value) => _controller.validatorPassword(value),
                focusNode: _controller.passwordFocus,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: () {
                  FocusScope.of(context).unfocus();
                },
              ),
              SizedBox(height: 20.h),
              _buildSavePassword(context),
              SizedBox(height: 24.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48.h,
                      child: _buildLoginButton(appLocal),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(28.r),
                      splashColor: AppColors.buttonLogin.withOpacity(0.2),
                      highlightColor: AppColors.buttonLogin.withOpacity(0.1),
                      child: Assets.images.icFaceId.image(
                        width: 56.h,
                        height: 56.h,
                        color: AppColors.buttonLogin,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40.h),
              _buildSocialLogin(appLocal),
              SizedBox(height: 30.h),
              _buildSignUpRedirect(appLocal),
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
            bool hide = _controller.hintPassword.value;
            return _buildTextField(
              hintText: hintText,
              icon: icon,
              controllerText: controllerText,
              isPassword: isPassword,
              validator: validator,
              hide: hide,
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
    required FocusNode focusNode,
    TextInputAction? textInputAction,
    VoidCallback? onFieldSubmitted,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
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
          // ← thêm
          if (_controller.isSubmitted.value) {
            formKey.currentState?.validate();
          }
        },
        cursorColor: AppColors.buttonLogin,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.darkPrimaryColor,
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
                  onPressed: _controller.setHintPassword,
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
          errorStyle: TextStyle(fontSize: 12.sp, color: AppColors.errorColor),
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14.sp),
        ),
      ),
    );
  }

  Widget _buildSavePassword(BuildContext context) {
    final appLocal = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Obx(() {
              final isChecked = _controller.rememberPassword.value;
              return Padding(
                padding: EdgeInsets.only(left: 5.w),
                child: GestureDetector(
                  onTap: () {
                    _controller.rememberPassword.value = !isChecked;
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    width: 22.w,
                    height: 22.h,
                    margin: EdgeInsets.only(right: 8.w),
                    decoration: BoxDecoration(
                      color: isChecked
                          ? AppColors.buttonLogin
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(
                        color: AppColors.buttonLogin,
                        width: 2,
                      ),
                    ),
                    child: isChecked
                        ? Icon(Icons.check, size: 16.sp, color: Colors.white)
                        : null,
                  ),
                ),
              );
            }),
            Text(
              appLocal.rememberPassword,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => Get.toNamed(RouterName.forgotPassword),
          child: Text(
            appLocal.forgotPassword,
            style: TextStyle(
              color: AppColors.buttonLogin,
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(AppLocalizations appLocal) {
    return Obx(() {
      final isLoading = _controller.isLoading.value;
      return ElevatedButton(
        onPressed: isLoading
            ? null
            : () {
                FocusScope.of(context).unfocus();
                _controller.isSubmitted.value = true; // ← thêm
                if (formKey.currentState!.validate()) {
                  _controller.login(
                    showError: (message) => showFormMessageDialog(
                      context,
                      type: FormMessageType.error,
                      title: message,
                    ),
                    formKey: formKey,
                  );
                } else {
                  showFormMessageDialog(
                    context,
                    type: FormMessageType.warning,
                    title: appLocal.validatorFormSignUp,
                  );
                }
              },
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: AppColors.buttonLogin.withOpacity(0.7),
          disabledForegroundColor: Colors.white,
          backgroundColor: AppColors.buttonLogin,
          foregroundColor: Colors.white,
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
                height: 24.h,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                appLocal.login,
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
      );
    });
  }

  Widget _buildSocialLogin(AppLocalizations appLocal) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey.shade300)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                appLocal.orContinueWith,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey.shade300)),
          ],
        ),
        SizedBox(height: 20.h),
        Row(
          spacing: 20.w,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(
              icon: Assets.images.icGoogleLogin.svg(width: 24.w, height: 24.h),
              onTap: () {},
            ),
            _buildSocialButton(
              icon: Assets.images.icFacebookLogin.svg(
                width: 24.w,
                height: 24.h,
              ),
              onTap: () {},
            ),
            _buildSocialButton(
              icon: Assets.images.icAppleLogin.svg(width: 24.w, height: 24.h),
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: icon,
      ),
    );
  }

  Widget _buildSignUpRedirect(AppLocalizations appLocal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          appLocal.dontHaveAccount,
          style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
        ),
        TextButton(
          onPressed: () => Get.toNamed(RouterName.signUp),
          child: Text(
            appLocal.signUp,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.buttonLogin,
            ),
          ),
        ),
      ],
    );
  }

  Widget tabletScreen() {
    return const Scaffold();
  }
}
