import 'dart:io';

import 'package:app/l10n/app_localizations.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class Utils {
  static final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static final phoneRegex = RegExp(r'^(0|\+84)[0-9]{9}$');
  static final safeRegex = RegExp(r'^[a-zA-Z0-9@._+-]+$');
  static bool isValidEmail(String email) {
    return emailRegex.hasMatch(email);
  }

  static bool isValidPhoneNumber(String phone) {
    return phoneRegex.hasMatch(phone);
  }

  static bool get deviceType {
    if (Platform.isAndroid) return false;
    if (Platform.isIOS) return true;
    return false;
  }

  static bool startsWithNumber(String text) {
    if (text.isEmpty) return false;
    return RegExp(r'^\d').hasMatch(text);
  }

  static String? validatorEmail(String? value) {
    final appLocal = AppLocalizations.of(Get.context!)!;
    if (value == null || value.trim().isEmpty) {
      return appLocal.validatorUserName;
    }
    final input = value.trim();
    if (!safeRegex.hasMatch(input)) return appLocal.validatorSpecialCharacters;
    if (!emailRegex.hasMatch(input) && !phoneRegex.hasMatch(input)) {
      return appLocal.emailIsNotCorrect;
    }
    return null;
  }

  static String? validatorPassword(String? value) {
    final appLocal = AppLocalizations.of(Get.context!)!;
    if (value == null || value.trim().isEmpty) {
      return appLocal.validatorPassword;
    }
    final input = value.trim();
    if (!safeRegex.hasMatch(input)) return appLocal.validatorSpecialCharacters;
    if (input.length < 6) return appLocal.validatorPasswordLength;
    return null;
  }
}
