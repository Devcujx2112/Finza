import 'package:app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();

  Rx<bool> hintPassword = true.obs;
  Rx<bool> rememberPassword = false.obs;

  RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  RegExp phoneRegex = RegExp(r'^(0|\+84)[0-9]{9}$');
  RegExp safeRegex = RegExp(r'^[a-zA-Z0-9@._+-]+$');

  @override
  void onInit() {
    super.onInit();
    init();
  }

  void init() {
    userName.text = "";
    password.text = "";
  }

  void setHintPassword() {
    hintPassword.value = !hintPassword.value;
  }

  String? validatorUserName(String? value) {
    final appLocal = AppLocalizations.of(Get.context!)!;

    if (value == null || value.trim().isEmpty) {
      return appLocal.validatorUserName;
    }

    final input = value.trim();

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final phoneRegex = RegExp(r'^(0|\+84)[0-9]{9}$');
    final safeRegex = RegExp(r'^[a-zA-Z0-9@._+-]+$');

    if (!safeRegex.hasMatch(input)) {
      return appLocal.validatorSpecialCharacters;
    }

    if (!emailRegex.hasMatch(input) && !phoneRegex.hasMatch(input)) {
      return appLocal.validatorEmailOrPhone;
    }

    return null;
  }

  String? validatorPassword(String? value) {
    final appLocal = AppLocalizations.of(Get.context!)!;

    if (value == null || value.trim().isEmpty) {
      return appLocal.validatorPassword;
    }

    final input = value.trim();

    final safeRegex = RegExp(r'^[a-zA-Z0-9@._+-]+$');

    if (!safeRegex.hasMatch(input)) {
      return appLocal.validatorSpecialCharacters;
    }

    if (input.length < 6) {
      return appLocal.validatorPasswordLength;
    }

    return null;
  }
}
