import 'package:app/domain/entities/onboarding_setup/custom_category.dart';
import 'package:app/domain/entities/onboarding_setup/fixed_expense.dart';
import 'package:app/domain/entities/onboarding_setup/onboarding_setup_config.dart';
import 'package:flutter/foundation.dart';

/// One version of the user's monthly spending plan.
///
/// A plan never changes once its month has started. Editing produces a new
/// version whose [effectiveFrom] is the first day of a later month, and the
/// plan for any month is the latest version that started on or before it.
/// That keeps every past and current month exactly as it was planned.
@immutable
class SpendingPattern {
  const SpendingPattern({
    required this.effectiveFrom,
    required this.monthlyIncome,
    required this.monthlySavingGoal,
    required this.fixedExpenses,
    required this.categoryAllocations,
    required this.customCategories,
    required this.updatedAt,
  });

  /// The plan the setup questionnaire produced, starting in the month the
  /// questionnaire was completed.
  factory SpendingPattern.fromSetup(OnboardingSetupConfig config) {
    return SpendingPattern(
      effectiveFrom: monthStart(config.completedAt),
      monthlyIncome: config.monthlyIncome,
      monthlySavingGoal: config.monthlySavingGoal,
      fixedExpenses: List<FixedExpense>.unmodifiable(config.fixedExpenses),
      categoryAllocations: Map<String, double>.unmodifiable(<String, double>{
        for (final category in SetupCategory.values)
          category.id: config.budgetAllocations[category.id] ?? 0,
      }),
      customCategories: List<CustomCategory>.unmodifiable(
        config.customCategories,
      ),
      updatedAt: config.completedAt,
    );
  }

  /// A blank plan for a user who has none yet.
  factory SpendingPattern.empty(DateTime effectiveFrom) => SpendingPattern(
    effectiveFrom: monthStart(effectiveFrom),
    monthlyIncome: 0,
    monthlySavingGoal: 0,
    fixedExpenses: const <FixedExpense>[],
    categoryAllocations: <String, double>{
      for (final category in SetupCategory.values) category.id: 0,
    },
    customCategories: const <CustomCategory>[],
    updatedAt: effectiveFrom,
  );

  /// Always the first day of a month.
  final DateTime effectiveFrom;
  final double monthlyIncome;
  final double monthlySavingGoal;
  final List<FixedExpense> fixedExpenses;

  /// Built-in category id ([SetupCategory.id]) to amount.
  final Map<String, double> categoryAllocations;

  /// Categories the user added, each carrying its own amount.
  final List<CustomCategory> customCategories;
  final DateTime updatedAt;

  static DateTime monthStart(DateTime date) => DateTime(date.year, date.month);

  /// The first day of the month after [date]. December rolls into January.
  static DateTime nextMonthStart(DateTime date) =>
      DateTime(date.year, date.month + 1);

  /// What the user plans to spend each month: income less the saving goal.
  /// Fixed costs and every category are paid out of this.
  double get spendingBudget => monthlyIncome - monthlySavingGoal;

  double get totalFixedExpenses =>
      fixedExpenses.fold(0, (sum, item) => sum + item.amount);

  /// The part of [spendingBudget] left for the categories after fixed costs.
  double get allocatableBudget => spendingBudget - totalFixedExpenses;

  double amountFor(SetupCategory category) =>
      categoryAllocations[category.id] ?? 0;

  double get allocatedTotal =>
      categoryAllocations.values.fold<double>(0, (sum, v) => sum + v) +
      customCategories.fold<double>(0, (sum, item) => sum + item.amount);

  /// Positive while budget is waiting to be split, negative once the
  /// categories ask for more than there is.
  double get unallocatedAmount => allocatableBudget - allocatedTotal;

  /// Splits what is left after fixed costs and custom categories across the
  /// built-in categories, using the same shares and rounding as the setup
  /// questionnaire's automatic allocation.
  SpendingPattern withAutomaticSplit() {
    final customTotal = customCategories.fold<double>(
      0,
      (sum, item) => sum + item.amount,
    );
    final budget = allocatableBudget - customTotal;
    final split = <String, double>{};
    if (budget <= 0) {
      for (final category in SetupCategory.values) {
        split[category.id] = 0;
      }
    } else {
      for (final category in SetupCategory.values) {
        final share =
            ((budget * category.defaultShare) / 1000).roundToDouble() * 1000;
        split[category.id] = share;
      }
      // The largest bucket absorbs the rounding remainder.
    }
    return copyWith(categoryAllocations: Map.unmodifiable(split));
  }

  /// True when both plans ask for the same money in the same places. The
  /// effective date and edit time are not part of the comparison.
  bool hasSameFiguresAs(SpendingPattern other) {
    if (monthlyIncome != other.monthlyIncome) return false;
    if (monthlySavingGoal != other.monthlySavingGoal) return false;
    if (!listEquals(fixedExpenses, other.fixedExpenses)) return false;
    if (!listEquals(customCategories, other.customCategories)) return false;
    for (final category in SetupCategory.values) {
      if (amountFor(category) != other.amountFor(category)) return false;
    }
    return true;
  }

  SpendingPattern copyWith({
    DateTime? effectiveFrom,
    double? monthlyIncome,
    double? monthlySavingGoal,
    List<FixedExpense>? fixedExpenses,
    Map<String, double>? categoryAllocations,
    List<CustomCategory>? customCategories,
    DateTime? updatedAt,
  }) {
    return SpendingPattern(
      effectiveFrom: effectiveFrom ?? this.effectiveFrom,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      monthlySavingGoal: monthlySavingGoal ?? this.monthlySavingGoal,
      fixedExpenses: fixedExpenses ?? this.fixedExpenses,
      categoryAllocations: categoryAllocations ?? this.categoryAllocations,
      customCategories: customCategories ?? this.customCategories,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'effectiveFrom': _dateOnly(effectiveFrom),
    'monthlyIncome': monthlyIncome,
    'monthlySavingGoal': monthlySavingGoal,
    'fixedExpenses': fixedExpenses.map((e) => e.toJson()).toList(),
    'categoryAllocations': categoryAllocations,
    'customCategories': customCategories.map((e) => e.toJson()).toList(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  static SpendingPattern fromJson(Map<String, dynamic> json) {
    final rawAllocations =
        (json['categoryAllocations'] as Map?)?.cast<String, dynamic>() ??
        const <String, dynamic>{};
    final effectiveFrom =
        DateTime.tryParse(json['effectiveFrom'] as String? ?? '') ??
        DateTime.now();
    return SpendingPattern(
      effectiveFrom: monthStart(effectiveFrom),
      monthlyIncome: (json['monthlyIncome'] as num?)?.toDouble() ?? 0,
      monthlySavingGoal: (json['monthlySavingGoal'] as num?)?.toDouble() ?? 0,
      fixedExpenses:
          (json['fixedExpenses'] as List?)
              ?.map(
                (item) => FixedExpense.fromJson(
                  (item as Map).cast<String, dynamic>(),
                ),
              )
              .toList() ??
          const <FixedExpense>[],
      categoryAllocations: <String, double>{
        for (final category in SetupCategory.values)
          category.id: (rawAllocations[category.id] as num?)?.toDouble() ?? 0,
      },
      customCategories:
          (json['customCategories'] as List?)
              ?.map(
                (item) => CustomCategory.fromJson(
                  (item as Map).cast<String, dynamic>(),
                ),
              )
              .toList() ??
          const <CustomCategory>[],
      updatedAt:
          DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          effectiveFrom,
    );
  }

  static String _dateOnly(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-01';
}
