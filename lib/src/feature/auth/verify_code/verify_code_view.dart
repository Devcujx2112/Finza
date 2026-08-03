import 'dart:async';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/src/core/color/app_colors.dart';
import 'package:app/src/core/widget/adaptive_page.dart';
import 'package:app/src/feature/auth/verify_code/verify_code_controller.dart';
import 'package:app/src/feature/widget/form_notification_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class VerifyCodeView extends StatefulWidget {
  const VerifyCodeView({super.key});

  @override
  State<VerifyCodeView> createState() => _VerifyCodeViewState();
}

class _VerifyCodeViewState extends State<VerifyCodeView> with AdaptivePage {
  final VerifyCodeController _controller = Get.find<VerifyCodeController>();

  Timer? _countdownTimer;
  int _remainingSeconds = 180;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    final shouldNotify = mounted && _countdownTimer != null;
    if (shouldNotify) {
      setState(() {
        _remainingSeconds = 180;
      });
    } else {
      _remainingSeconds = 180;
    }
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        if (_remainingSeconds > 0) {
          setState(() {
            _remainingSeconds--;
          });
        } else {
          _controller.verifyNumberSendOtp();
          timer.cancel();
        }
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    int minutes = _remainingSeconds ~/ 60;
    int seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

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
        automaticallyImplyLeading: false,
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
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: _remainingSeconds > 0
                        ? AppColors.buttonLogin.withOpacity(0.08)
                        : AppColors.errorColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: _remainingSeconds > 0
                          ? AppColors.buttonLogin.withOpacity(0.2)
                          : AppColors.errorColor.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        color: _remainingSeconds > 0
                            ? AppColors.buttonLogin
                            : AppColors.errorColor,
                        size: 18.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        _formattedTime,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: _remainingSeconds > 0
                              ? AppColors.buttonLogin
                              : AppColors.errorColor,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
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
                child: Obx(() {
                  final isLoading = _controller.isLoading;
                  final isExpired = _remainingSeconds == 0;
                  final isDisabled = isExpired || isLoading;

                  return ElevatedButton(
                    onPressed: isDisabled
                        ? null
                        : () {
                            FocusScope.of(context).unfocus();
                            _controller.verifyOtp(
                              showError: (message) => showFormMessageDialog(
                                context,
                                type: FormMessageType.error,
                                title: message,
                              ),
                              showSuccess: (message) {
                                showFormMessageDialog(
                                  context,
                                  type: FormMessageType.success,
                                  title: message,
                                );
                              },
                              appLocal: appLocal,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonLogin,
                      disabledBackgroundColor: Colors.grey.shade400,
                      foregroundColor: AppColors.whiteColor,
                      disabledForegroundColor: AppColors.whiteColor,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      elevation: isExpired ? 0 : 4,
                      shadowColor: isExpired
                          ? Colors.transparent
                          : AppColors.buttonLogin.withOpacity(0.4),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: AppColors.whiteColor,
                          )
                        : Text(
                            appLocal.nextStep,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
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
                    color: AppColors.darkPrimaryColor,
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
            Obx(() {
              final isResendEnabled = _controller.isResendEnabled;
              final isLoading = _controller.isLoading;
              final canResend = isResendEnabled && !isLoading;

              return GestureDetector(
                onTap: canResend
                    ? () {
                        _controller.resendOtp(
                          showError: (message) => showFormMessageDialog(
                            context,
                            type: FormMessageType.error,
                            title: message,
                          ),
                          showSuccess: (message) {
                            showFormMessageDialog(
                              context,
                              type: FormMessageType.success,
                              title: message,
                            );
                            _startCountdown();
                          },
                          appLocal: appLocal,
                        );
                      }
                    : () {
                        showFormMessageDialog(
                          context,
                          type: FormMessageType.error,
                          title: appLocal.resendOtpLimit,
                        );
                      },
                child: Text(
                  appLocal.resendPin,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: canResend ? AppColors.buttonLogin : Colors.grey,
                    decoration: TextDecoration.underline,
                    decorationColor: canResend
                        ? AppColors.buttonLogin
                        : Colors.transparent,
                  ),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget tabletScreen(BuildContext context) {
    return const Scaffold();
  }
}
