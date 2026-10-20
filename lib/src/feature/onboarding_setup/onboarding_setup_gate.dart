import 'package:app/domain/usecases/onboarding_setup_usecase.dart';
import 'package:app/router/router_name.dart';
import 'package:app/src/data/repositories/onboarding_setup_repository_impl.dart';
import 'package:get/get.dart';

class OnboardingSetupGate {
  const OnboardingSetupGate._();

  static final OnboardingSetupUsecase _usecase = OnboardingSetupUsecase(
    const OnboardingSetupRepositoryImpl(),
  );

  static Future<String> routeAfterAuth({bool? hasSetupSpendingConfig}) async {
    if (hasSetupSpendingConfig != null) {
      if (!hasSetupSpendingConfig) {
        // Clear any old local setup cache from another user on this device
        await _usecase.resetSetup();
        return RouterName.onboardingSetup;
      }
      return RouterName.home;
    }
    final hasCompleted = await _usecase.hasCompletedSetup();
    return hasCompleted ? RouterName.home : RouterName.onboardingSetup;
  }

  static Future<void> enterApp({bool? hasSetupSpendingConfig}) async =>
      Get.offAllNamed(
        await routeAfterAuth(hasSetupSpendingConfig: hasSetupSpendingConfig),
      );
}
