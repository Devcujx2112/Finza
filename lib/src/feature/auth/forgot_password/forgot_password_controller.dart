import 'package:app/domain/usecases/signup_usecase.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/router/router_name.dart';
import 'package:app/src/core/error/app_exception.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  ForgotPasswordController(this.signupUsecase);

  final SignupUsecase signupUsecase;

  final TextEditingController emailController = TextEditingController();
  final isSubmitted = false.obs;

  final RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  Future<void> forgotPassword({
    required Function(String) showError,
    required AppLocalizations appLocal,
  }) async {
    try {
      _isLoading.value = true;
      final result = await signupUsecase.forgotPassword(emailController.text);
      if (result == true) {
        Get.toNamed(RouterName.verifyCode);
      } else {
        showError(appLocal.sendOtpFailed);
      }
    } on AppException catch (e) {
      showError(e.message);
    } finally {
      _isLoading.value = false;
    }
  }
}
