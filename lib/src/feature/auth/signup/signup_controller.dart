import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
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

  void unHidePassword() {
    hidePassword.value = !hidePassword.value;
  }

  void unHideConfirmPassword() {
    hideConfirmPassword.value = !hideConfirmPassword.value;
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
