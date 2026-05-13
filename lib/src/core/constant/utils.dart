class Utils {
  static bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    return emailRegex.hasMatch(email);
  }

  static bool isValidPhoneNumber(String phone) {
    final RegExp phoneRegex = RegExp(r'^\d{8,15}$');
    return phoneRegex.hasMatch(phone);
  }
}
