import 'package:app/l10n/app_localizations.dart';
import 'package:app/router/router_name.dart';
import 'package:app/src/core/color/app_colors.dart';
import 'package:app/src/core/widget/adaptive_page.dart';
import 'package:app/src/feature/auth/verify_code/verify_code_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class VerifyCodeView extends StatefulWidget {
  const VerifyCodeView({super.key});

  @override
  State<VerifyCodeView> createState() => _VerifyCodeViewState();
}

class _VerifyCodeViewState extends State<VerifyCodeView> with AdaptivePage {
  final VerifyCodeController _controller = VerifyCodeController();

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
    return tabletScreen(context);
  }

  @override
  Widget tabletPortraitBody(BuildContext context, Size size) {
    return tabletScreen(context);
  }

  Widget mobileScreen(BuildContext context) {
    final appLocal = AppLocalizations.of(context)!;
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
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
            colors: [AppColors.primarySecondaryColor, AppColors.buttonLogin],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: isKeyboardOpen ? 140.h : 230.h,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 30.w,
                      right: 30.w,
                      top: isKeyboardOpen ? 60.h : 90.h,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appLocal.securityPin,
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
                            appLocal.enterTheCodeSentTo,
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
              _buildFormVerifyCode(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormVerifyCode(BuildContext context) {
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
            color: Colors.black12,
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
              Text(
                appLocal.enterTheCode,
                style: TextStyle(
                  fontSize: 22.sp,
                  color: AppColors.darkPrimaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 32.h),
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(_controller.focusNode);
                },
                child: _buildFormInputPIN(),
              ),
              SizedBox(
                height: 1,
                width: 1,
                child: Opacity(
                  opacity: 0,
                  child: TextField(
                    focusNode: _controller.focusNode,
                    controller: _controller.pinController,
                    keyboardType: TextInputType.number,
                    maxLength: _controller.pinLength,
                    autofocus: true,
                    onChanged: (value) {
                      setState(() {});
                    },
                    onTapOutside: (event) {
                      _controller.focusNode.unfocus();
                    },
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              SizedBox(
                height: 48.h,
                child: ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Get.toNamed(RouterName.newPassword);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonLogin,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    elevation: 4,
                    shadowColor: AppColors.buttonLogin.withOpacity(0.4),
                  ),
                  child: Text(
                    appLocal.nextStep,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormInputPIN() {
    final appLocal = AppLocalizations.of(context)!;
    final currentLength = _controller.pinController.text.length;

    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_controller.pinLength, (index) {
              String text = '';
              bool isFocused = index == currentLength;
              bool hasValue = index < currentLength;

              if (hasValue) {
                text = _controller.pinController.text[index];
              }

              return AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                width: 44.w,
                height: 44.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.backgroundMenu,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isFocused
                        ? Colors.green
                        : hasValue
                        ? Colors.green.withOpacity(0.6)
                        : Colors.grey.shade300,
                    width: isFocused ? 2.2 : 1.5,
                  ),
                  boxShadow: isFocused
                      ? [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
              );
            }),
          ),
        ),
        SizedBox(height: 24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              appLocal.didNotReceivePin,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(width: 6.w),
            GestureDetector(
              onTap: () {},
              child: Text(
                appLocal.resendPin,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.buttonLogin,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.buttonLogin,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget tabletScreen(BuildContext context) {
    return const Scaffold();
  }
}
