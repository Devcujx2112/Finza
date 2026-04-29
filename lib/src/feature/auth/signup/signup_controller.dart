import 'package:app/domain/entities/country_code/country_code.dart';
import 'package:app/domain/entities/user/user.dart';
import 'package:app/domain/usecases/signup_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  SignupController(this._signupUsecase);

  final SignupUsecase _signupUsecase;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Rx<bool> hidePassword = true.obs;
  Rx<bool> hideConfirmPassword = true.obs;

  final List<CountryCode> countries = CountryCode.countries;

  RxString selectedDialCode = '+84'.obs;

  void unHidePassword() {
    hidePassword.value = !hidePassword.value;
  }

  void unHideConfirmPassword() {
    hideConfirmPassword.value = !hideConfirmPassword.value;
  }

  Future<User?> register() async {
    if (!formKey.currentState!.validate()) return null;
    final user = User(
      role: '',
      userId: '',
      avatar: '',
      refreshToken: '',
      token: '',
      userName: emailController.text,
      password: passwordController.text,
      fullName: fullNameController.text,
      phoneNumber: selectedDialCode.value + phoneNumberController.text,
      dateOfBirth: dateOfBirthController.text,
    );
    final result = await _signupUsecase.register(user);
    if (result != null) {
      Get.snackbar('Success', 'Register success');
    }
    return result;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    dateOfBirthController.dispose();
    super.onClose();
  }
}
