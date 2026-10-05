import 'package:app/domain/entities/onboarding_setup/onboarding_setup_config.dart';
import 'package:app/domain/repositories/onboarding_setup_repository.dart';

class OnboardingSetupUsecase {
  OnboardingSetupUsecase(this._repository);

  final OnboardingSetupRepository _repository;

  Future<void> completeSetup(OnboardingSetupConfig config) async {
    return await _repository.save(config);
  }

  Future<OnboardingSetupConfig?> readSetup() async {
    return await _repository.read();
  }

  Future<bool> hasCompletedSetup() async {
    return await _repository.hasCompleted();
  }

  Future<void> resetSetup() async {
    return await _repository.clear();
  }
}
