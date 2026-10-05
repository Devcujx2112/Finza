import 'package:app/domain/entities/onboarding_setup/custom_category.dart';
import 'package:app/domain/entities/onboarding_setup/cycle_day.dart';
import 'package:app/domain/entities/onboarding_setup/fixed_expense.dart';
import 'package:flutter/foundation.dart';

/// How the user wants the app to work for them. Chosen on the first screen of
/// the setup questionnaire, it decides which questions follow.
enum ExpenseManagementMode { analytics, budget }

/// Whether the user wants a monthly saving target.
enum SavingGoalChoice { skipped, enabled }

/// How the remaining budget is split across spending categories.
enum BudgetAllocationMode { automatic, manual }

/// The built-in spending buckets offered during allocation. The ids match the
/// category ids the budget feature already uses, so the configuration lines up
/// with recorded expenses later on. Anything beyond these is added by the user
/// as a [CustomCategory] instead of falling into a fixed "other" bucket.
enum SetupCategory { food, transport, shopping, entertainment }

extension SetupCategoryData on SetupCategory {
  String get id => switch (this) {
    SetupCategory.food => 'food',
    SetupCategory.transport => 'transport',
    SetupCategory.shopping => 'shopping',
    SetupCategory.entertainment => 'entertainment',
  };

  /// Share of the budget the automatic allocation gives this category. The
  /// shares add up to one.
  double get defaultShare => switch (this) {
    SetupCategory.food => 0.45,
    SetupCategory.transport => 0.15,
    SetupCategory.shopping => 0.20,
    SetupCategory.entertainment => 0.20,
  };
}

/// The complete answer set from the setup questionnaire, shaped so a backend
/// can persist it as-is.
@immutable
class OnboardingSetupConfig {
  const OnboardingSetupConfig({
    required this.mode,
    required this.cycleStartDay,
    required this.monthlyIncome,
    required this.monthlySavingGoal,
    required this.fixedExpenses,
    required this.allocationMode,
    required this.customCategories,
    required this.budgetAllocations,
    required this.completedAt,
  });

  final ExpenseManagementMode mode;
  final CycleDay cycleStartDay;

  /// Zero for the analytics mode, which does not ask about income.
  final double monthlyIncome;
  final double monthlySavingGoal;
  final List<FixedExpense> fixedExpenses;
  final BudgetAllocationMode? allocationMode;

  /// Categories the user added. Their amounts are also in
  /// [budgetAllocations], under their ids.
  final List<CustomCategory> customCategories;

  /// Category id to amount, covering both the built-in and the custom
  /// categories. Empty for the analytics mode.
  final Map<String, double> budgetAllocations;
  final DateTime completedAt;

  double get totalFixedExpenses =>
      fixedExpenses.fold(0, (sum, item) => sum + item.amount);

  double get remainingBudget =>
      monthlyIncome - monthlySavingGoal - totalFixedExpenses;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'expenseManagementMode': mode.name,
    'cycleStartDay': cycleStartDay.toJson(),
    'monthlyIncome': monthlyIncome,
    'monthlySavingGoal': monthlySavingGoal,
    'fixedExpenses': fixedExpenses.map((e) => e.toJson()).toList(),
    'budgetAllocationMode': allocationMode?.name,
    'customCategories': customCategories.map((e) => e.toJson()).toList(),
    'budgetAllocations': budgetAllocations,
    'completedAt': completedAt.toIso8601String(),
  };

  static OnboardingSetupConfig fromJson(Map<String, dynamic> json) {
    final rawAllocations =
        (json['budgetAllocations'] as Map?)?.cast<String, dynamic>() ??
        const <String, dynamic>{};
    final rawMode = json['budgetAllocationMode'] as String?;
    return OnboardingSetupConfig(
      mode: ExpenseManagementMode.values.firstWhere(
        (value) => value.name == json['expenseManagementMode'],
        orElse: () => ExpenseManagementMode.analytics,
      ),
      cycleStartDay: CycleDay.fromJson(
        (json['cycleStartDay'] as Map).cast<String, dynamic>(),
      ),
      monthlyIncome: (json['monthlyIncome'] as num?)?.toDouble() ?? 0,
      monthlySavingGoal: (json['monthlySavingGoal'] as num?)?.toDouble() ?? 0,
      fixedExpenses:
          (json['fixedExpenses'] as List?)
              ?.map(
                (item) =>
                    FixedExpense.fromJson((item as Map).cast<String, dynamic>()),
              )
              .toList() ??
          const <FixedExpense>[],
      allocationMode: rawMode == null
          ? null
          : BudgetAllocationMode.values.firstWhere(
              (value) => value.name == rawMode,
              orElse: () => BudgetAllocationMode.automatic,
            ),
      customCategories:
          (json['customCategories'] as List?)
              ?.map(
                (item) => CustomCategory.fromJson(
                  (item as Map).cast<String, dynamic>(),
                ),
              )
              .toList() ??
          const <CustomCategory>[],
      budgetAllocations: rawAllocations.map(
        (key, value) => MapEntry(key, (value as num).toDouble()),
      ),
      completedAt:
          DateTime.tryParse(json['completedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
