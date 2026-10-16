import 'package:app/domain/entities/onboarding_setup/onboarding_setup_config.dart';
import 'package:app/domain/entities/onboarding_setup/spending_config.dart';
import 'package:app/models/onboarding/setup_user_budget_request_model.dart';

abstract class OnboardingSetupRepository {
  Future<void> save(OnboardingSetupConfig config);

  Future<OnboardingSetupConfig?> read();

  Future<bool> hasCompleted();

  Future<void> clear();

  Future<bool> saveSpendingConfig(SpendingConfig data);

  Future<bool> saveBudgetUser(List<SetupUserBudgetRequestModel> data);
}
