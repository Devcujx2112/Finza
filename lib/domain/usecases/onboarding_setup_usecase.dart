import 'package:app/domain/entities/onboarding_setup/onboarding_setup_config.dart';
import 'package:app/domain/entities/onboarding_setup/spending_config.dart';
import 'package:app/domain/repositories/onboarding_setup_repository.dart';
import 'package:app/models/onboarding/setup_user_budget_request_model.dart';
import 'package:app/src/core/constant/constant.dart';

class OnboardingSetupUsecase {
  OnboardingSetupUsecase(this._repository);

  final OnboardingSetupRepository _repository;

  Future<bool> completeSetup(
    OnboardingSetupConfig config, {
    List<SetupUserBudgetRequestModel> budgets = const [],
  }) async {
    final isBudget = config.mode == ExpenseManagementMode.budget;
    final configSaved = await _repository.saveSpendingConfig(
      spendingConfigOf(config),
    );
    if (!configSaved) return false;
    if (isBudget && budgets.isNotEmpty) {
      final budgetSaved = await _repository.saveBudgetUser(budgets);
      if (!budgetSaved) return false;
    }
    await _repository.save(config);
    return true;
  }
 
  static SpendingConfig spendingConfigOf(OnboardingSetupConfig config) {
    final isBudget = config.mode == ExpenseManagementMode.budget;
    final cycle = config.cycleStartDay;
    return SpendingConfig(
      spendingConfigId: null,
      userId: null,
      spendingMethod: isBudget
          ? Constants.budgetManagement
          : Constants.expenditureAnalysis,
      dayStarted: cycle.isLastDayOfMonth ? null : cycle.day.toString(),
      isLastDayOfMonth: cycle.isLastDayOfMonth,
      totalInCome: isBudget ? config.monthlyIncome.round() : null,
      monthlySaving: isBudget ? config.monthlySavingGoal.round() : null,
    );
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

  Future<bool> saveSpendingConfig(SpendingConfig data) async {
    return await _repository.saveSpendingConfig(data);
  }

  Future<bool> saveBudgetUser(List<SetupUserBudgetRequestModel> data) async {
    return await _repository.saveBudgetUser(data);
  }
}
