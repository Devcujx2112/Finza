import 'package:app/gen/fonts.gen.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/router/router_name.dart';
import 'package:app/src/core/color/app_colors.dart';
import 'package:app/src/core/widget/adaptive_page.dart';
import 'package:app/src/feature/auth/verify_code/verify_code_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

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
                              appLocal.securityPin,
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
                    Expanded(flex: 7, child: _buildFormVerifyCode(context)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFormVerifyCode(BuildContext context) {
    final appLocal = AppLocalizations.of(context);
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                appLocal?.enterTheCode ?? '',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontFamily: FontFamily.roboto,
                  fontWeight: FontWeight(700),
                  color: AppColors.darkPrimaryColor,
                ),
              ),
              Text(
                appLocal?.enterTheCodeSentTo ?? '',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: FontFamily.roboto,
                  fontWeight: FontWeight(400),
                  color: AppColors.darkPrimaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 30.h),
          Expanded(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(_controller.focusNode);
              },
              child: _buildFormInputPIN(),
            ),
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
          SizedBox(
            height: 45.h,
            width: 180.w,
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed(RouterName.newPassword);
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
        ],
      ),
    );
  }

  Widget _buildFormInputPIN() {
    final appLocal = AppLocalizations.of(context);
    return Column(
      spacing: 20.h,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_controller.pinLength, (index) {
            String text = '';

            if (index < _controller.pinController.text.length) {
              text = _controller.pinController.text[index];
            }

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 5.w,
          children: [
            Text(
              appLocal?.didNotReceivePin ?? '',
              style: TextStyle(
                fontSize: 12.sp,
                fontFamily: FontFamily.roboto,
                fontWeight: FontWeight(400),
                color: AppColors.darkPrimaryColor,
              ),
            ),
            Text(
              appLocal?.resendPin ?? '',
              style: TextStyle(
                fontSize: 12.sp,
                fontFamily: FontFamily.roboto,
                fontWeight: FontWeight(400),
                color: AppColors.buttonLogin,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.buttonLogin,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget tabletScreen(BuildContext context) {
    return Container();
  }
}
