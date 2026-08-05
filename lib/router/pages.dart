import 'package:app/router/router_name.dart';
import 'package:app/src/feature/navigation/navigation_binding.dart';
import 'package:app/src/feature/navigation/navigation_view.dart';
import 'package:app/src/feature/auth/forgot_password/forgot_password_binding.dart';
import 'package:app/src/feature/auth/forgot_password/forgot_password_view.dart';
import 'package:app/src/feature/auth/login/login_binding.dart';
import 'package:app/src/feature/auth/main_auth/main_auth_binding.dart';
import 'package:app/src/feature/auth/new_password/new_password_binding.dart';
import 'package:app/src/feature/auth/new_password/new_password_view.dart';
import 'package:app/src/feature/auth/signup/signup_binding.dart';
import 'package:app/src/feature/auth/verify_code/verify_code_binding.dart';
import 'package:app/src/feature/auth/verify_code/verify_code_view.dart';
import 'package:app/src/feature/auth/login/login_view.dart';
import 'package:app/src/feature/auth/main_auth/main_auth_view.dart';
import 'package:app/src/feature/auth/signup/signup_view.dart';
import 'package:app/src/feature/budget/budget_view.dart';
import 'package:app/src/feature/notification/notification_view.dart';
import 'package:app/src/feature/onboarding/onboarding_view.dart';
import 'package:app/src/feature/profile/profile_view.dart';
import 'package:app/src/feature/schedule/schedule_view.dart';
import 'package:app/src/feature/splash/splash_page.dart';
import 'package:get/route_manager.dart';

class Pages {
  static List<GetPage> page = [
    GetPage(name: RouterName.splash, page: () => Splashpage()),
    GetPage(
      name: RouterName.navigationMenu,
      page: () => NavigationView(),
      binding: NavigationBinding(),
    ),
    GetPage(
      name: RouterName.home,
      page: () => NavigationView(),
      binding: NavigationBinding(),
    ),
    GetPage(
      name: RouterName.login,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: RouterName.signUp,
      page: () => SignUpView(),
      binding: SignupBinding(),
    ),
    GetPage(name: RouterName.notification, page: () => NotificationView()),
    GetPage(
      name: RouterName.forgotPassword,
      page: () => ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: RouterName.newPassword,
      page: () => NewPasswordView(),
      binding: NewPasswordBinding(),
    ),
    // GetPage(name: RouterName.profile, page: () => ProfileView()),
    // GetPage(name: RouterName.setting, page: () => SettingView()),
    GetPage(name: RouterName.onboarding, page: () => OnboardingView()),
    GetPage(name: RouterName.profile, page: () => ProfileView()),
    GetPage(name: RouterName.budget, page: () => BudgetView()),
    GetPage(
      name: RouterName.mainLogin,
      page: () => MainAuth(),
      binding: MainAuthBinding(),
    ),
    GetPage(name: RouterName.schedule, page: () => ScheduleView()),
    GetPage(
      name: RouterName.verifyCode,
      page: () => VerifyCodeView(),
      binding: VerifyCodeBinding(),
    ),
  ];
}
