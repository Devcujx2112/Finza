import 'package:app/router/router_name.dart';
import 'package:app/src/feature/auth/forgot_password/forgot_password_view.dart';
import 'package:app/src/feature/auth/new_password/new_password_view.dart';
import 'package:app/src/feature/auth/verify_code/verify_code_view.dart';
import 'package:app/src/feature/auth/login/login_view.dart';
import 'package:app/src/feature/auth/main_auth.dart';
import 'package:app/src/feature/auth/signup/signup_view.dart';
import 'package:app/src/feature/home/homepage_view.dart';
import 'package:app/src/feature/notification/notification_view.dart';
import 'package:app/src/feature/onboarding/onboarding_view.dart';
import 'package:app/src/feature/splash/splash_page.dart';
import 'package:get/route_manager.dart';

class Pages {
  static List<GetPage> page = [
    GetPage(name: RouterName.splash, page: () => Splashpage()),
    GetPage(name: RouterName.home, page: () => HomepageView()),
    GetPage(name: RouterName.login, page: () => LoginView()),
    GetPage(name: RouterName.signUp, page: () => SignUpView()),
    GetPage(name: RouterName.notification, page: () => NotificationView()),
    GetPage(name: RouterName.forgotPassword, page: () => ForgotPasswordView()),
    GetPage(name: RouterName.newPassword, page: () => NewPasswordView()),
    // GetPage(name: RouterName.profile, page: () => ProfileView()),
    // GetPage(name: RouterName.setting, page: () => SettingView()),
    GetPage(name: RouterName.onboarding, page: () => OnboardingView()),
    GetPage(name: RouterName.mainLogin, page: () => MainAuth()),
    GetPage(name: RouterName.verifyCode, page: () => VerifyCodeView()),
  ];
}
