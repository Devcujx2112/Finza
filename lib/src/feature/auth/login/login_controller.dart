import 'package:app/domain/usecases/login_usecase.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/router/router_name.dart';
import 'package:app/src/core/error/app_exception.dart';
import 'package:app/src/data/local/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
  }

  @override
  void onClose() {
    userNameFocus.dispose();
    passwordFocus.dispose();
    userName.dispose();
    password.dispose();
    super.onClose();
  }

  void init() async {
    rememberPassword.value =
        await SecureTokenStorage.instance.getRememberPassword() ?? false;
    if (rememberPassword.value) {
      userName.text = await SecureTokenStorage.instance.getEmail() ?? "";
      password.text = await SecureTokenStorage.instance.getPassword() ?? "";
    }
  }

  void setHintPassword() {
    hintPassword.value = !hintPassword.value;
  }

  void setRememberPassword() {
    rememberPassword.value = !rememberPassword.value;
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
        if (rememberPassword.value) {
          await SecureTokenStorage.instance.saveEmail(userName.text.trim());
          await SecureTokenStorage.instance.savePassword(password.text.trim());

          await SecureTokenStorage.instance.saveRememberPassword(true);
        }
        Get.offAllNamed(RouterName.home);
      }
    } on AppException catch (e) {
      showError(e.message);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithGoogle({required Function(String) showError}) async {
    try {
      isLoading.value = true;

      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize();

      final account = await googleSignIn.authenticate();

      final auth = account.authentication;

      final idToken = auth.idToken;

      if (idToken == null) {
        showError(AppLocalizations.of(Get.context!)!.errorLoginGoogle);
        return;
      }

      await loginUsecase.loginWithGoogle(
        provider: 'google'.toUpperCase(),
        idToken: idToken,
      );

      Get.offAllNamed(RouterName.home);
    } catch (e) {
      debugPrint("Bug loginWithGoogle:  $e");
      showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithFacebook({required Function(String) showError}) async {
    try {
      isLoading.value = true;

      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final accessToken = result.accessToken;

        if (accessToken == null) {
          showError(AppLocalizations.of(Get.context!)!.errrorLoginFacebook);
          return;
        }

        await loginUsecase.loginWithFacebook(
          provider: 'facebook'.toUpperCase(),
          accessToken: accessToken.tokenString,
        );

        Get.offAllNamed(RouterName.home);
      } else if (result.status == LoginStatus.cancelled) {
        return;
      } else {
        showError(
          result.message ??
              AppLocalizations.of(Get.context!)!.errrorLoginFacebook,
        );
      }
    } catch (e) {
      showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithApple({required Function(String) showError}) async {
    try {
      isLoading.value = true;

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final identityToken = credential.identityToken;

      if (identityToken == null || identityToken.isEmpty) {
        showError('Cannot get Apple identity token');
        return;
      }

      await loginUsecase.loginWithApple(
        provider: 'apple'.toUpperCase(),
        idToken: identityToken,
      );

      Get.offAllNamed(RouterName.home);
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        showError('User cancelled Apple Sign In');
      } else {
        showError(e.message);
        debugPrint("Bug loginWithApple:  ${e.message}");
      }
    } catch (e) {
      showError(e.toString());
      debugPrint("Bug loginWithApple:  $e");
    } finally {
      isLoading.value = false;
    }
  }
}
