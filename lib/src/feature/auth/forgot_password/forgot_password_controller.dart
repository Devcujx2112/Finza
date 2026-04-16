import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();

  String? validatorUserName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your user name';
    }
    return null;
  }
}
