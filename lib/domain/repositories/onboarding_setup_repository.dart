import 'package:app/domain/entities/onboarding_setup/onboarding_setup_config.dart';

abstract class OnboardingSetupRepository {
  Future<void> save(OnboardingSetupConfig config);

  Future<OnboardingSetupConfig?> read();

  Future<bool> hasCompleted();

  Future<void> clear();
}
