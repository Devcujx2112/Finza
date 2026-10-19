import 'package:app/domain/entities/onboarding_setup/cycle_day.dart';
import 'package:app/domain/entities/onboarding_setup/custom_category.dart';
import 'package:app/domain/entities/onboarding_setup/fixed_expense.dart';
import 'package:app/domain/entities/onboarding_setup/onboarding_setup_config.dart';
import 'package:app/domain/entities/onboarding_setup/spending_config.dart';
import 'package:app/domain/repositories/onboarding_setup_repository.dart';
import 'package:app/domain/usecases/onboarding_setup_usecase.dart';
import 'package:app/models/onboarding/setup_user_budget_request_model.dart';
import 'package:app/src/core/constant/constant.dart';
import 'package:flutter_test/flutter_test.dart';

class _RecordingRepository implements OnboardingSetupRepository {
  _RecordingRepository({this.budgetAccepted = true});

  final bool budgetAccepted;
  final List<SpendingConfig> configs = <SpendingConfig>[];
  final List<SetupUserBudgetRequestModel> budgets =
      <SetupUserBudgetRequestModel>[];
  OnboardingSetupConfig? saved;

  @override
  Future<bool> saveSpendingConfig(SpendingConfig data) async {
    configs.add(data);
    return true;
  }

  @override
  Future<bool> saveBudgetUser(List<SetupUserBudgetRequestModel> data) async {
    budgets.addAll(data);
    return budgetAccepted;
  }

  @override
  Future<void> save(OnboardingSetupConfig config) async => saved = config;

  @override
  Future<OnboardingSetupConfig?> read() async => saved;

  @override
  Future<bool> hasCompleted() async => saved != null;

  @override
  Future<void> clear() async => saved = null;
}

OnboardingSetupConfig _config(ExpenseManagementMode mode) =>
    OnboardingSetupConfig(
      mode: mode,
      cycleStartDay: const CycleDay.onDay(5),
      monthlyIncome: mode == ExpenseManagementMode.budget ? 25000000 : 0,
      monthlySavingGoal: mode == ExpenseManagementMode.budget ? 5000000 : 0,
      fixedExpenses: const <FixedExpense>[],
      allocationMode: null,
      customCategories: const <CustomCategory>[],
      budgetAllocations: const <String, double>{},
      completedAt: DateTime(2026, 10, 6),
    );

const _budgetLine = SetupUserBudgetRequestModel(
  typeCost: Constants.flexibleCosts,
  nameCost: 'Di chuyển',
  amount: 2000000,
  categoriesName: 'Di chuyển',
  stringIcon: '🚕',
);

void main() {
  test('spending analysis sends only the spending configuration', () async {
    final repository = _RecordingRepository();
    final saved = await OnboardingSetupUsecase(repository).completeSetup(
      _config(ExpenseManagementMode.analytics),
      budgets: const [_budgetLine],
    );

    expect(saved, isTrue);
    expect(
      repository.configs.single.spendingMethod,
      Constants.expenditureAnalysis,
    );
    expect(repository.configs.single.dayStarted, '5');
    expect(repository.configs.single.totalInCome, isNull);
    expect(repository.budgets, isEmpty);
    expect(repository.saved, isNotNull);
  });

  test(
    'budget management sends the configuration and every budget line',
    () async {
      final repository = _RecordingRepository();
      final saved = await OnboardingSetupUsecase(repository).completeSetup(
        _config(ExpenseManagementMode.budget),
        budgets: const [_budgetLine, _budgetLine],
      );

      expect(saved, isTrue);
      expect(
        repository.configs.single.spendingMethod,
        Constants.budgetManagement,
      );
      expect(repository.configs.single.totalInCome, 25000000);
      expect(repository.configs.single.monthlySaving, 5000000);
      expect(repository.budgets, hasLength(2));
    },
  );

  test('a declined budget line leaves setup open on this device', () async {
    final repository = _RecordingRepository(budgetAccepted: false);
    final saved = await OnboardingSetupUsecase(repository).completeSetup(
      _config(ExpenseManagementMode.budget),
      budgets: const [_budgetLine],
    );

    expect(saved, isFalse);
    expect(repository.saved, isNull);
  });
}
