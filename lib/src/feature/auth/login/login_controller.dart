import 'package:app/domain/usecases/login_usecase.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/router/router_name.dart';
import 'package:app/src/core/error/app_exception.dart';
import 'package:app/src/data/local/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  LoginController(this.loginUsecase);

  final LoginUsecase loginUsecase;
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();

  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final phoneRegex = RegExp(r'^(0|\+84)[0-9]{9}$');
  final safeRegex = RegExp(r'^[a-zA-Z0-9@._+-]+$');
  final isSubmitted = false.obs;

  Rx<bool> hintPassword = true.obs;
  Rx<bool> rememberPassword = false.obs;
  Rx<bool> isLoading = false.obs;

  final userNameFocus = FocusNode();
  final passwordFocus = FocusNode();

  @override
  void onInit() {
    super.onInit();
    init();
  }

  @override
  void onClose() {
    userNameFocus.dispose();
    passwordFocus.dispose();
    userName.dispose();
    password.dispose();
    super.onClose();
  }

  void init() {
    userName.text = Get.parameters['email'] ?? "";
    password.text = Get.parameters['password'] ?? "";
  }

  void setHintPassword() {
    hintPassword.value = !hintPassword.value;
  }

  String? validatorUserName(String? value) {
    if (!isSubmitted.value) return null;
    final appLocal = AppLocalizations.of(Get.context!)!;
    if (value == null || value.trim().isEmpty) {
      return appLocal.validatorUserName;
    }
    final input = value.trim();
    if (!safeRegex.hasMatch(input)) return appLocal.validatorSpecialCharacters;
    if (!emailRegex.hasMatch(input) && !phoneRegex.hasMatch(input)) {
      return appLocal.validatorEmailOrPhone;
    }
    return null;
  }

  String? validatorPassword(String? value) {
    if (!isSubmitted.value) return null;
    final appLocal = AppLocalizations.of(Get.context!)!;
    if (value == null || value.trim().isEmpty) {
      return appLocal.validatorPassword;
    }
    final input = value.trim();
    if (!safeRegex.hasMatch(input)) return appLocal.validatorSpecialCharacters;
    if (input.length < 6) return appLocal.validatorPasswordLength;
    return null;
  }

  Future<void> login({
    required Function(String) showError,
    required GlobalKey<FormState> formKey,
  }) async {
    try {
      if (!formKey.currentState!.validate()) return;

      isLoading.value = true;
      final user = await loginUsecase.login(
        userName.text.trim(),
        password.text.trim(),
      );
      if (user != null) {
        await SecureTokenStorage.instance.saveAccessToken(user.token);
        await SecureTokenStorage.instance.saveRefreshToken(user.refreshToken);
        Get.offAllNamed(RouterName.home);
      }
    } on AppException catch (e) {
      showError(e.message);
    } finally {
      isLoading.value = false;
    }
  }
}
