class ApiPath {
  //Auth
  static const String register = "/auth/register";
  static const String login = "/auth/login";
  static const String loginSocialMedia = "/auth/login-social";
  static const String refreshToken = "/auth/refresh-token";
  static const String trialAccount = "/auth/trial";
  static const String sendOtp = "/auth/send-otp";
  static const String resetPassword = "/auth/reset-password";
  static const String logout = "/auth/logout";
  static const String verifyOtp = "/auth/verify-otp";
  static const String changePassword = "/auth/change-password";

  //Account
  static const String deleteAccount = "/accounts/deleteAccount";
  static const String integration = "/accounts/integration";
  static const String getProfile = "/accounts/getProfile";
  static const String getListCountryCode = "/accounts/getListCountryCode";
}
