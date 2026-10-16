import 'package:app/domain/usecases/onboarding_setup_usecase.dart';
import 'package:app/router/router_name.dart';
import 'package:app/src/data/repositories/onboarding_setup_repository_impl.dart';
import 'package:get/get.dart';

class OnboardingSetupGate {
  const OnboardingSetupGate._();

  static final OnboardingSetupUsecase _usecase = OnboardingSetupUsecase(
    const OnboardingSetupRepositoryImpl(),
  );

  static Future<String> routeAfterAuth() async {
    final hasCompleted = await _usecase.hasCompletedSetup();
    return hasCompleted ? RouterName.home : RouterName.onboardingSetup;
  }

  static Future<void> enterApp() async =>
      Get.offAllNamed(await routeAfterAuth());
}
