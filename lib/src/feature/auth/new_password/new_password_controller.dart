import 'package:app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewPasswordController extends GetxController {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  RxBool hidePassword = true.obs;
  RxBool hideConfirmPassword = true.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void togglePasswordVisibility() {
    hidePassword.value = !hidePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    hideConfirmPassword.value = !hideConfirmPassword.value;
  }

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

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
