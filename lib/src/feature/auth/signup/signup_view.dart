import 'package:app/l10n/app_localizations.dart';
import 'package:app/router/router_name.dart';
import 'package:app/src/core/color/app_colors.dart';
import 'package:app/src/core/constant/utils.dart';
import 'package:app/src/core/widget/adaptive_page.dart';
import 'package:app/src/feature/auth/signup/signup_controller.dart';
import 'package:app/src/feature/widget/country_code_picker.dart';
import 'package:app/src/feature/widget/custom_calender.dart';
import 'package:app/src/feature/widget/form_notification_message.dart';
import 'package:app/src/feature/widget/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> with AdaptivePage {
  final SignupController controller = Get.find<SignupController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
    final appLocal = AppLocalizations.of(context);
    return LoadingOverlay(
      isLoading: controller.isLoading.value,
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
                SizedBox(
                  height: 180.h,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 40.h),
                        Text(
                          appLocal?.createAccount ?? "",
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          appLocal?.createAccountIntroduction ?? "",
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
                _buildFormSignUp(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormSignUp(BuildContext context) {
    final appLocal = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height - 180.h,
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
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildFormItem(
                fieldName: 'fullName',
                focusNode: controller.fullNameFocus,
                hintText: appLocal.exampleFullName,
                label: appLocal.fullName,
                icon: Icons.person_outline_rounded,
                controllerText: controller.fullNameController,
                validator: (value) => (value?.isEmpty ?? true)
                    ? appLocal.validatorFullName
                    : null,
              ),
              SizedBox(height: 16.h),
              _buildFormItem(
                fieldName: 'email',
                focusNode: controller.emailFocus,
                hintText: appLocal.exampleEmail,
                label: appLocal.emailName,
                icon: Icons.email_outlined,
                controllerText: controller.emailController,
                validator: (value) {
                  if (value?.isEmpty ?? true) return appLocal.validatorUserName;
                  if (!Utils.isValidEmail(value!)) {
                    return appLocal.validatorEmailOrPhone;
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              _buildPhoneField(context),
              SizedBox(height: 16.h),
              _buildFormItem(
                fieldName: 'dateOfBirth',
                focusNode: controller.dateOfBirthFocus,
                hintText: appLocal.exampleDateOfBirth,
                label: appLocal.dateOfBirth,
                icon: Icons.cake_outlined,
                readOnly: true,
                onTap: () {
                  controller.isPickingDate.value = true;
                  showCalendarDialog(context);
                },
                controllerText: controller.dateOfBirthController,
                validator: (value) => (value?.isEmpty ?? true)
                    ? appLocal.validatorDateOfBirth
                    : null,
              ),
              SizedBox(height: 16.h),
              _buildFormItem(
                fieldName: 'password',
                focusNode: controller.passwordFocus,
                hintText: '••••••••',
                label: appLocal.password,
                icon: Icons.lock_outline_rounded,
                isPassword: true,
                controllerText: controller.passwordController,
                validator: (value) {
                  if (value?.isEmpty ?? true) return appLocal.validatorPassword;
                  if (value!.length < 6) {
                    return appLocal.validatorPasswordLength;
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              _buildFormItem(
                fieldName: 'confirmPassword',
                focusNode: controller.confirmPasswordFocus,
                hintText: '••••••••',
                label: appLocal.confirmPassword,
                icon: Icons.lock_reset_rounded,
                isConfirmPassword: true,
                controllerText: controller.confirmPasswordController,
                validator: (value) {
                  if (value?.isEmpty ?? true) return appLocal.validatorPassword;
                  if (value != controller.passwordController.text) {
                    return appLocal.validatorPasswordConfirm;
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.h),
              _buildSubmitButton(appLocal),
              SizedBox(height: 20.h),
              _buildLoginRedirect(appLocal),
              SizedBox(height: 30.h),
              _buildTermsAndPrivacy(appLocal),
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
    required String fieldName,
    required FocusNode focusNode,
    bool isPassword = false,
    bool isConfirmPassword = false,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
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
        if (isPassword || isConfirmPassword)
          Obx(() {
            bool hide = isPassword
                ? controller.hidePassword.value
                : controller.hideConfirmPassword.value;
            return _buildTextField(
              controllerText: controllerText,
              hide: hide,
              readOnly: readOnly,
              onTap: onTap,
              validator: validator,
              hintText: hintText,
              icon: icon,
              isPassword: isPassword,
              isConfirmPassword: isConfirmPassword,
              fieldName: fieldName,
              focusNode: focusNode,
            );
          })
        else
          _buildTextField(
            controllerText: controllerText,
            hide: false,
            readOnly: readOnly,
            onTap: onTap,
            validator: validator,
            hintText: hintText,
            icon: icon,
            isPassword: isPassword,
            isConfirmPassword: isConfirmPassword,
            fieldName: fieldName,
            focusNode: focusNode,
          ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controllerText,
    required bool hide,
    required bool readOnly,
    required VoidCallback? onTap,
    required String? Function(String?)? validator,
    required String hintText,
    required IconData icon,
    required bool isPassword,
    required bool isConfirmPassword,
    required String fieldName,
    required FocusNode focusNode,
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
        onFieldSubmitted: (_) {
          FocusScope.of(Get.context!).unfocus();
        },
        obscureText: hide,
        readOnly: readOnly,
        onTap: () {
          controller.onFieldTouched(fieldName);
          onTap?.call();
        },
        validator: (value) {
          if (!controller.isSubmitted.value) return null;
          return validator?.call(value);
        },
        onChanged: (value) {
          if (controller.isSubmitted.value) {
            _formKey.currentState?.validate();
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
          suffixIcon: (isPassword || isConfirmPassword)
              ? IconButton(
                  icon: Icon(
                    hide
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.iconColor,
                    size: 20.sp,
                  ),
                  onPressed: isPassword
                      ? controller.unHidePassword
                      : controller.unHideConfirmPassword,
                )
              : (readOnly
                    ? Icon(
                        Icons.calendar_month_outlined,
                        color: AppColors.buttonLogin,
                        size: 20.sp,
                      )
                    : null),
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

  Widget _buildPhoneField(BuildContext context) {
    final appLocal = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            appLocal.phoneNumber,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.darkPrimaryColor.withOpacity(0.8),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IntrinsicHeight(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.buttonLogin,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14.r),
                        bottomLeft: Radius.circular(14.r),
                      ),
                    ),
                    child: Obx(
                      () => CountryCodePicker(
                        countries: controller.countries,
                        selectedCode: controller.selectedDialCode.value,
                        onSelected: (value) =>
                            controller.selectedDialCode.value = value,
                      ),
                    ),
                  ),
                  Container(width: 1, color: Colors.grey.shade200),
                  Expanded(
                    child: TextFormField(
                      controller: controller.phoneNumberController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (!controller.isSubmitted.value) return null;
                        if (value?.isEmpty ?? true) {
                          return appLocal.validatorUserName;
                        }
                        if (!Utils.isValidPhoneNumber(value!)) {
                          return appLocal.validatorEmailOrPhone;
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (controller.isSubmitted.value) {
                          _formKey.currentState?.validate();
                        }
                      },
                      cursorColor: AppColors.buttonLogin,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.errorColor,
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide(
                            color: AppColors.transparentColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide(
                            color: AppColors.transparentColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: const BorderSide(
                            color: AppColors.buttonLogin,
                            width: 1.5,
                          ),
                        ),
                        filled: true,
                        fillColor: AppColors.backgroundMenu,
                        hintText: "888 888 888",
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14.sp,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(AppLocalizations appLocal) {
    return ElevatedButton(
      onPressed: () async {
        FocusScope.of(context).unfocus();
        await Future.delayed(const Duration(milliseconds: 50));

        controller.isSubmitted.value = true;
        if (_formKey.currentState?.validate() ?? false) {
          controller.register(
            formKey: _formKey,
            showSuccess: () {
              showFormMessageDialog(
                context,
                type: FormMessageType.success,
                title: appLocal.signupSuccess,
              );
            },
            showError: (errors) {
              showFormMessageDialog(
                context,
                type: FormMessageType.error,
                title: errors,
              );
            },
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
        backgroundColor: AppColors.buttonLogin,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        elevation: 4,
        shadowColor: AppColors.buttonLogin.withOpacity(0.4),
      ),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const CircularProgressIndicator(color: Colors.white);
        }
        return Text(
          appLocal.signUp,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        );
      }),
    );
  }

  Widget _buildLoginRedirect(AppLocalizations appLocal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          appLocal.alreadyHaveAccount,
          style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
        ),
        TextButton(
          onPressed: () => Get.toNamed(RouterName.login),
          child: Text(
            appLocal.login,
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

  Widget _buildTermsAndPrivacy(AppLocalizations appLocal) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          fontSize: 11.sp,
          color: Colors.grey.shade600,
          height: 1.5,
        ),
        children: [
          TextSpan(text: "${appLocal.confirmAccount} "),
          TextSpan(
            text: appLocal.termsOfUse,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.darkPrimaryColor,
            ),
          ),
          TextSpan(text: " ${appLocal.and} "),
          TextSpan(
            text: appLocal.privacyPolicy,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.darkPrimaryColor,
            ),
          ),
          TextSpan(text: "."),
        ],
      ),
    );
  }

  void showCalendarDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Calendar",
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: ScaleTransition(
              scale: anim1,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                child: CustomCalendar(
                  initialDate: DateTime.now(),
                  onChanged: (date) {
                    Get.back();
                    controller.isPickingDate.value = false;
                    controller.dateOfBirthController.text = DateFormat(
                      'dd/MM/yyyy',
                    ).format(date);
                    if (controller.isSubmitted.value) {
                      _formKey.currentState?.validate();
                    }
                  },
                ),
              ),
            ),
          ),
        );
      },
    ).then((_) {
      controller.isPickingDate.value = false;
    });
  }

  Widget tabletScreen() => const Scaffold();
}
