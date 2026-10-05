import 'package:app/domain/repositories/onboarding_setup_repository.dart';
import 'package:app/domain/usecases/onboarding_setup_usecase.dart';
import 'package:app/domain/entities/onboarding_setup/cycle_day.dart';
import 'package:app/domain/entities/onboarding_setup/onboarding_setup_config.dart';
import 'package:app/src/feature/onboarding_setup/onboarding_setup_controller.dart';
import 'package:flutter_test/flutter_test.dart';

/// Keeps the tests off disk; only the in memory answer state is under test.
class _InMemoryRepository implements OnboardingSetupRepository {
  OnboardingSetupConfig? saved;

  @override
  Future<void> save(OnboardingSetupConfig config) async => saved = config;

  @override
  Future<OnboardingSetupConfig?> read() async => saved;

  @override
  Future<bool> hasCompleted() async => saved != null;

  @override
  Future<void> clear() async => saved = null;
}

OnboardingSetupController buildController({DateTime? now}) =>
    OnboardingSetupController(
      OnboardingSetupUsecase(_InMemoryRepository()),
      clock: () => now ?? DateTime(2026, 9, 24),
    );

void main() {
  group('CycleDay', () {
    test('resolves the last day against the month being asked about', () {
      const lastDay = CycleDay.lastDayOfMonth();
      expect(lastDay.resolveFor(DateTime(2026, 2, 10)), 28);
      expect(lastDay.resolveFor(DateTime(2024, 2, 10)), 29);
      expect(lastDay.resolveFor(DateTime(2026, 4, 10)), 30);
      expect(lastDay.resolveFor(DateTime(2026, 1, 10)), 31);
    });

    test('clamps a day that a shorter month does not have', () {
      expect(const CycleDay.onDay(31).resolveFor(DateTime(2026, 2, 1)), 28);
      expect(const CycleDay.onDay(15).resolveFor(DateTime(2026, 2, 1)), 15);
    });
  });

  group('flow shape', () {
    test('the analysis flow asks one question after the method', () {
      final controller = buildController()
        ..selectMode(ExpenseManagementMode.analytics);
      expect(controller.steps, <SetupStep>[
        SetupStep.method,
        SetupStep.analyticsCycleDay,
        SetupStep.completion,
      ]);
      expect(controller.questionCount, 2);
    });

    test('the budget flow asks five questions after the method', () {
      final controller = buildController()
        ..selectMode(ExpenseManagementMode.budget);
      expect(controller.questionCount, 6);
      expect(controller.steps.last, SetupStep.completion);
    });

    test('switching mode keeps the answers of the other branch', () {
      final controller = buildController()
        ..selectMode(ExpenseManagementMode.budget)
        ..selectIncomeDay(const CycleDay.onDay(25))
        ..setMonthlyIncome(20000000)
        ..selectMode(ExpenseManagementMode.analytics)
        ..selectAnalyticsCycleDay(const CycleDay.onDay(1))
        ..selectMode(ExpenseManagementMode.budget);

      expect(controller.incomeDay.value, const CycleDay.onDay(25));
      expect(controller.monthlyIncome.value, 20000000);
      expect(controller.analyticsCycleDay.value, const CycleDay.onDay(1));
    });
  });

  group('validation', () {
    test('a saving goal at or above income blocks the step', () {
      final controller = buildController()
        ..selectMode(ExpenseManagementMode.budget)
        ..setMonthlyIncome(20000000)
        ..stepIndex.value = 3
        ..selectSavingGoalChoice(SavingGoalChoice.enabled)
        ..setCustomSavingGoal(20000000);

      expect(controller.currentStep, SetupStep.savingGoal);
      expect(
        controller.validationIssue,
        SetupValidationIssue.savingGoalNotBelowIncome,
      );
      expect(controller.canContinue, isFalse);

      controller.setCustomSavingGoal(19999999);
      expect(controller.validationIssue, isNull);
      expect(controller.canContinue, isTrue);
    });

    test('skipping the saving goal always lets the user continue', () {
      final controller = buildController()
        ..selectMode(ExpenseManagementMode.budget)
        ..setMonthlyIncome(20000000)
        ..stepIndex.value = 3
        ..selectSavingGoalChoice(SavingGoalChoice.skipped);

      expect(controller.monthlySavingGoal.value, 0);
      expect(controller.canContinue, isTrue);
    });

    test('fixed costs above what is left block the step', () {
      final controller = buildController()
        ..selectMode(ExpenseManagementMode.budget)
        ..setMonthlyIncome(20000000)
        ..selectSavingGoalPreset(3000000)
        ..stepIndex.value = 4
        ..addFixedExpense('Rent', 18000000);

      expect(controller.currentStep, SetupStep.fixedExpenses);
      expect(
        controller.validationIssue,
        SetupValidationIssue.commitmentsExceedIncome,
      );
      expect(controller.canContinue, isFalse);
    });

    test('an empty list of fixed costs is a valid answer', () {
      final controller = buildController()
        ..selectMode(ExpenseManagementMode.budget)
        ..setMonthlyIncome(20000000)
        ..stepIndex.value = 4;

      expect(controller.fixedExpenses, isEmpty);
      expect(controller.canContinue, isTrue);
    });

    test('a manual split has to match the remaining budget exactly', () {
      final controller = buildController()
        ..selectMode(ExpenseManagementMode.budget)
        ..setMonthlyIncome(20000000)
        ..selectSavingGoalPreset(3000000)
        ..addFixedExpense('Rent', 5000000)
        ..stepIndex.value = 5
        ..selectAllocationMode(BudgetAllocationMode.manual);

      expect(controller.remainingBudget, 12000000);
      expect(
        controller.validationIssue,
        SetupValidationIssue.allocationUnderBudget,
      );

      controller.setManualAllocation(SetupCategory.food, 13000000);
      expect(
        controller.validationIssue,
        SetupValidationIssue.allocationOverBudget,
      );
      expect(controller.unallocatedAmount, -1000000);

      controller.setManualAllocation(SetupCategory.food, 12000000);
      expect(controller.validationIssue, isNull);
      expect(controller.canContinue, isTrue);
    });

    test('custom categories count towards a manual split', () {
      final controller = buildController()
        ..selectMode(ExpenseManagementMode.budget)
        ..setMonthlyIncome(10000000)
        ..stepIndex.value = 5
        ..selectAllocationMode(BudgetAllocationMode.manual)
        ..setManualAllocation(SetupCategory.food, 7000000)
        ..addCustomCategory('Gym', 'fitness', 3000000);

      expect(controller.validationIssue, isNull);
      expect(controller.effectiveAllocations.length, 5);

      final gym = controller.customCategories.single;
      controller.updateCustomCategory(gym.id, 'Gym', 'sport', 4000000);
      expect(controller.customCategories.single.iconKey, 'sport');
      expect(
        controller.validationIssue,
        SetupValidationIssue.allocationOverBudget,
      );

      controller.removeCustomCategory(gym.id);
      expect(
        controller.validationIssue,
        SetupValidationIssue.allocationUnderBudget,
      );
    });

    test('custom categories cannot overspend an automatic split', () {
      final controller = buildController()
        ..selectMode(ExpenseManagementMode.budget)
        ..setMonthlyIncome(5000000)
        ..stepIndex.value = 5
        ..selectAllocationMode(BudgetAllocationMode.automatic)
        ..addCustomCategory('Travel', 'travel', 6000000);

      expect(
        controller.validationIssue,
        SetupValidationIssue.allocationOverBudget,
      );
      expect(controller.canContinue, isFalse);
    });

    test('a step with nothing to split can be completed without a mode', () {
      final controller = buildController()
        ..selectMode(ExpenseManagementMode.budget)
        ..setMonthlyIncome(10000000)
        ..selectSavingGoalPreset(5000000)
        ..addFixedExpense('Rent', 5000000)
        ..stepIndex.value = 5;

      expect(controller.hasNothingToAllocate, isTrue);
      expect(controller.canContinue, isTrue);
    });

    test('changing an earlier answer invalidates a split that no longer fits', () {
      final controller = buildController()
        ..selectMode(ExpenseManagementMode.budget)
        ..setMonthlyIncome(20000000)
        ..stepIndex.value = 5
        ..selectAllocationMode(BudgetAllocationMode.manual)
        ..setManualAllocation(SetupCategory.food, 20000000);

      expect(controller.canContinue, isTrue);

      controller.setMonthlyIncome(15000000);
      expect(
        controller.validationIssue,
        SetupValidationIssue.allocationOverBudget,
      );
      expect(controller.canContinue, isFalse);
    });
  });

  group('automatic allocation', () {
    test('spends the whole remaining budget', () {
      final controller = buildController()
        ..selectMode(ExpenseManagementMode.budget)
        ..setMonthlyIncome(20000000)
        ..selectSavingGoalPreset(3000000)
        ..addFixedExpense('Rent', 5000000);

      final allocations = controller.automaticAllocations;
      final total = allocations.values.fold<double>(0, (sum, v) => sum + v);
      expect(total, controller.remainingBudget);
      expect(allocations[SetupCategory.food.id], 5400000);
    });

    test('rounding leftovers land in the largest bucket', () {
      final controller = buildController()
        ..selectMode(ExpenseManagementMode.budget)
        ..setMonthlyIncome(10000333);

      final allocations = controller.automaticAllocations;
      final total = allocations.values.fold<double>(0, (sum, v) => sum + v);
      expect(total, controller.remainingBudget);
      expect(allocations[SetupCategory.food.id], 4500333);
      expect(allocations.containsKey('other'), isFalse);
    });

    test('custom categories are set aside before the split', () {
      final controller = buildController()
        ..selectMode(ExpenseManagementMode.budget)
        ..setMonthlyIncome(12000000)
        ..addCustomCategory(' Pets ', 'pets', 2000000);

      final pet = controller.customCategories.single;
      expect(pet.name, 'Pets');
      final allocations = controller.automaticAllocations;
      expect(allocations[pet.id], 2000000);
      expect(allocations[SetupCategory.food.id], 4500000);
      final total = allocations.values.fold<double>(0, (sum, v) => sum + v);
      expect(total, controller.remainingBudget);
    });

    test('nothing is allocated when nothing is left', () {
      final controller = buildController()
        ..selectMode(ExpenseManagementMode.budget)
        ..setMonthlyIncome(10000000)
        ..selectSavingGoalPreset(5000000)
        ..addFixedExpense('Rent', 5000000);

      expect(controller.remainingBudget, 0);
      expect(controller.hasNothingToAllocate, isTrue);
      expect(controller.automaticAllocations.values, everyElement(0));
    });
  });

  group('mid cycle', () {
    test('is true when setup finishes away from the income day', () {
      final controller = buildController(now: DateTime(2026, 9, 13))
        ..selectMode(ExpenseManagementMode.budget)
        ..selectIncomeDay(const CycleDay.onDay(25));

      expect(controller.isMidCycle, isTrue);
      expect(controller.resolvedCycleStartDay, 25);
    });

    test('is false when setup finishes on the income day', () {
      final controller = buildController(now: DateTime(2026, 9, 25))
        ..selectMode(ExpenseManagementMode.budget)
        ..selectIncomeDay(const CycleDay.onDay(25));

      expect(controller.isMidCycle, isFalse);
    });

    test('the last day of a short month counts as the cycle start', () {
      final controller = buildController(now: DateTime(2026, 2, 28))
        ..selectMode(ExpenseManagementMode.budget)
        ..selectIncomeDay(const CycleDay.lastDayOfMonth());

      expect(controller.isMidCycle, isFalse);
    });

    test('the analysis flow never reports a mid cycle state', () {
      final controller = buildController(now: DateTime(2026, 9, 13))
        ..selectMode(ExpenseManagementMode.analytics)
        ..selectAnalyticsCycleDay(const CycleDay.onDay(1));

      expect(controller.isMidCycle, isFalse);
    });
  });

  group('result', () {
    test('the saved configuration round trips through JSON', () {
      final controller = buildController()
        ..selectMode(ExpenseManagementMode.budget)
        ..selectIncomeDay(const CycleDay.onDay(25))
        ..setMonthlyIncome(20000000)
        ..selectSavingGoalPreset(3000000)
        ..addFixedExpense('Rent', 5000000)
        ..addCustomCategory('Pets', 'pets', 1000000)
        ..selectAllocationMode(BudgetAllocationMode.automatic);

      final config = controller.buildConfig()!;
      final restored = OnboardingSetupConfig.fromJson(config.toJson());
      final pet = restored.customCategories.single;
      expect(pet.name, 'Pets');
      expect(pet.iconKey, 'pets');
      expect(restored.budgetAllocations[pet.id], 1000000);

      expect(restored.mode, ExpenseManagementMode.budget);
      expect(restored.cycleStartDay, const CycleDay.onDay(25));
      expect(restored.monthlyIncome, 20000000);
      expect(restored.monthlySavingGoal, 3000000);
      expect(restored.fixedExpenses.single.name, 'Rent');
      expect(restored.allocationMode, BudgetAllocationMode.automatic);
      expect(restored.remainingBudget, 12000000);
      expect(
        restored.budgetAllocations.values.fold<double>(0, (s, v) => s + v),
        12000000,
      );
    });

    test('the analysis flow carries no budget figures', () {
      final controller = buildController()
        ..selectMode(ExpenseManagementMode.analytics)
        ..selectAnalyticsCycleDay(const CycleDay.lastDayOfMonth());

      final config = controller.buildConfig()!;
      expect(config.monthlyIncome, 0);
      expect(config.fixedExpenses, isEmpty);
      expect(config.budgetAllocations, isEmpty);
      expect(config.allocationMode, isNull);
    });

    test('no configuration is built before the cycle day is answered', () {
      final controller = buildController()
        ..selectMode(ExpenseManagementMode.budget);
      expect(controller.buildConfig(), isNull);
    });
  });
}
