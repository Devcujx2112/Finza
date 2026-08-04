import 'package:app/domain/usecases/signup_usecase.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/router/router_name.dart';
import 'package:app/src/core/error/app_exception.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewPasswordController extends GetxController {
  NewPasswordController(this.signupUsecase);

  final SignupUsecase signupUsecase;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();
  RxBool hidePassword = true.obs;
  RxBool hideConfirmPassword = true.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final isSubmitted = false.obs;

  final RxString _email = ''.obs;
  String get email => _email.value;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    _email.value = args['email'] ?? '';
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    hidePassword.value = !hidePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    hideConfirmPassword.value = !hideConfirmPassword.value;
  }

  bool get isConfirmPasswordMatched =>
      passwordController.text == confirmPasswordController.text;

  String? validateInput(String? value, bool isPassword, BuildContext context) {
    final appLocal = AppLocalizations.of(context);
    if (value == null || value.isEmpty) {
      return appLocal?.validatorPassword ?? '';
    }
    if (value.length < 6) {
      return appLocal?.validatorPasswordLength ?? '';
    }
    return null;
  }

  Future<void> changePassword({
    required Function(String) onError,
    required Function(String) onSuccess,
    required AppLocalizations appLocal,
  }) async {
    _isLoading.value = true;
    try {
      final result = await signupUsecase.changePassword(
        _email.value,
        passwordController.text,
      );
      if (result == true) {
        _isLoading.value = false;
        await onSuccess(appLocal.changePasswordSuccess);
        Get.toNamed(RouterName.login);
      } else {
        _isLoading.value = false;
        onError(appLocal.changePasswordFail);
      }
    } on AppException catch (e) {
      _isLoading.value = false;
      onError(e.message);
    }
  }
}
