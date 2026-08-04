import 'package:app/domain/usecases/signup_usecase.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/router/router_name.dart';
import 'package:app/src/core/error/app_exception.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyCodeController extends GetxController {
  VerifyCodeController(this.signupUsecase);

  final SignupUsecase signupUsecase;

  final TextEditingController pinController = TextEditingController();
  final int pinLength = 6;
  final FocusNode focusNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final RxString _email = ''.obs;
  String get email => _email.value;

  final RxInt numberSendOtp = 0.obs;

  final RxBool _isResendEnabled = true.obs;
  bool get isResendEnabled => _isResendEnabled.value;
  bool get isResendEnabledValue => _isResendEnabled.value;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    _email.value = args['email'];
  }

  @override
  void onClose() {
    pinController.dispose();
    focusNode.dispose();
    _email.close();
    numberSendOtp.close();
    _isResendEnabled.close();
    _isLoading.close();
    super.onClose();
  }

  void verifyNumberSendOtp() {
    _isResendEnabled.value = numberSendOtp.value <= 3;
  }

  Future<void> resendOtp({
    required Function(String) showError,
    required Function(String) showSuccess,
    required AppLocalizations appLocal,
  }) async {
    verifyNumberSendOtp();
    try {
      _isLoading.value = true;
      final result = await signupUsecase.forgotPassword(_email.value);
      numberSendOtp.value++;
      if (result == true) {
        showSuccess(appLocal.resendOtpSuccess);
      } else {
        showError(appLocal.sendOtpFailed);
      }
    } on AppException catch (e) {
      showError(e.message);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> verifyOtp({
    required Function(String) showError,
    required Future<void> Function(String) showSuccess,
    required AppLocalizations appLocal,
  }) async {
    try {
      _isLoading.value = true;
      final result = await signupUsecase.verifyOtp(
        _email.value,
        pinController.text,
      );
      if (result == true) {
        _isLoading.value = false;
        await showSuccess(appLocal.verifyOtpSuccess);
        Get.toNamed(RouterName.newPassword, arguments: {'email': _email.value});
        return true;
      } else {
        _isLoading.value = false;
        showError(appLocal.invalidOtp);
        return false;
      }
    } on AppException catch (e) {
      showError(e.message);
      return false;
    } finally {
      _isLoading.value = false;
    }
  }
}
