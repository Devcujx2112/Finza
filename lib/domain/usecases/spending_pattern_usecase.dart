import 'package:app/domain/entities/onboarding_setup/onboarding_setup_config.dart';
import 'package:app/domain/entities/spending_pattern/spending_pattern.dart';
import 'package:app/domain/repositories/onboarding_setup_repository.dart';
import 'package:app/domain/repositories/spending_pattern_repository.dart';

/// A problem that stops a plan from being saved. The view resolves the
/// localized text, so no user facing copy lives in the domain.
enum SpendingPatternIssue {
  incomeNotPositive,
  negativeAmount,
  savingGoalNotBelowIncome,
  commitmentsExceedIncome,
  customCategoryNameMissing,
  allocationOverBudget,
  allocationUnderBudget,
}

/// What the plan looks like around [currentMonth].
class SpendingPatternOverview {
  const SpendingPatternOverview({
    required this.currentMonth,
    required this.nextMonth,
    required this.current,
    required this.upcoming,
  });

  final DateTime currentMonth;
  final DateTime nextMonth;

  /// The plan in force this month. Never changed by editing.
  final SpendingPattern? current;

  /// A plan already scheduled to start after this month, if any.
  final SpendingPattern? upcoming;

  bool get hasPlan => current != null || upcoming != null;

  /// What an edit starts from: the scheduled plan when there is one, so a
  /// second edit in the same month continues the first.
  SpendingPattern? get editable => upcoming ?? current;
}

/// The result of saving an edited plan.
enum SpendingPatternSaveOutcome {
  /// A version starting next month was created or replaced.
  scheduled,

  /// The edit matched this month's plan, so the scheduled version was
  /// dropped instead of storing a copy of the current one.
  reverted,
}

/// Rules for the monthly spending plan.
///
/// The one rule everything here protects: an edit never touches the plan of
/// the current month or any month before it. Edits are always written to the
/// version that starts next month, and editing again in the same month
/// replaces that version rather than stacking new ones.
class SpendingPatternUsecase {
  SpendingPatternUsecase(this._repository, this._setupRepository);

  final SpendingPatternRepository _repository;
  final OnboardingSetupRepository _setupRepository;

  /// Amounts are whole dong, so totals are compared with a tolerance, the
  /// same one the setup questionnaire uses.
  static const double amountTolerance = 0.5;

  Future<SpendingPatternOverview> loadOverview(DateTime now) async {
    final versions = await _readVersions();
    final month = SpendingPattern.monthStart(now);
    final later = versions
        .where((item) => item.effectiveFrom.isAfter(month))
        .toList();
    return SpendingPatternOverview(
      currentMonth: month,
      nextMonth: SpendingPattern.nextMonthStart(now),
      current: _versionFor(versions, month),
      upcoming: later.isEmpty ? null : later.first,
    );
  }

  /// The plan that applies to the month containing [date], for features
  /// that need the budget of a given month.
  Future<SpendingPattern?> patternFor(DateTime date) async =>
      _versionFor(await _readVersions(), SpendingPattern.monthStart(date));

  List<SpendingPatternIssue> validate(SpendingPattern draft) {
    final issues = <SpendingPatternIssue>[];
    final amounts = <double>[
      draft.monthlyIncome,
      draft.monthlySavingGoal,
      ...draft.fixedExpenses.map((item) => item.amount),
      ...draft.categoryAllocations.values,
      ...draft.customCategories.map((item) => item.amount),
    ];
    if (amounts.any((value) => value < 0)) {
      issues.add(SpendingPatternIssue.negativeAmount);
    }
    if (draft.monthlyIncome <= 0) {
      issues.add(SpendingPatternIssue.incomeNotPositive);
    } else if (draft.monthlySavingGoal >= draft.monthlyIncome) {
      // Also covers a spending budget of zero or less.
      issues.add(SpendingPatternIssue.savingGoalNotBelowIncome);
    } else if (draft.allocatableBudget < -amountTolerance) {
      issues.add(SpendingPatternIssue.commitmentsExceedIncome);
    }
    if (draft.customCategories.any((item) => item.name.trim().isEmpty)) {
      issues.add(SpendingPatternIssue.customCategoryNameMissing);
    }
    // Same rule as the manual allocation in setup: every dong of the budget
    // left after fixed costs goes to a category, no more and no less.
    if (draft.unallocatedAmount < -amountTolerance) {
      issues.add(SpendingPatternIssue.allocationOverBudget);
    } else if (draft.allocatableBudget > amountTolerance &&
        draft.unallocatedAmount > amountTolerance) {
      issues.add(SpendingPatternIssue.allocationUnderBudget);
    }
    return issues;
  }

  /// Saves [draft] as the plan for the month after [now]. The current
  /// month's plan is left exactly as it is.
  Future<SpendingPatternSaveOutcome> scheduleForNextMonth(
    SpendingPattern draft,
    DateTime now,
  ) async {
    if (validate(draft).isNotEmpty) {
      throw ArgumentError('The plan has unresolved issues.');
    }
    final overview = await loadOverview(now);
    final current = overview.current;
    if (current != null && draft.hasSameFiguresAs(current)) {
      final upcoming = overview.upcoming;
      if (upcoming != null) await _repository.remove(upcoming.effectiveFrom);
      return SpendingPatternSaveOutcome.reverted;
    }
    await _repository.upsert(
      draft.copyWith(effectiveFrom: overview.nextMonth, updatedAt: now),
    );
    return SpendingPatternSaveOutcome.scheduled;
  }

  /// Drops the plan scheduled after the month of [now], if any. Only a
  /// version that has not started can be dropped.
  Future<void> cancelUpcoming(DateTime now) async {
    final upcoming = (await loadOverview(now)).upcoming;
    if (upcoming == null) return;
    await _repository.remove(upcoming.effectiveFrom);
  }

  SpendingPattern? _versionFor(List<SpendingPattern> versions, DateTime month) {
    SpendingPattern? match;
    for (final version in versions) {
      if (version.effectiveFrom.isAfter(month)) break;
      match = version;
    }
    return match;
  }

  /// Stored versions, oldest first. The first time it is asked, the plan
  /// from the setup questionnaire becomes the first version, so the
  /// history starts from what the user originally chose.
  Future<List<SpendingPattern>> _readVersions() async {
    final versions = await _repository.readAll();
    if (versions.isNotEmpty) return versions;
    final setup = await _setupRepository.read();
    if (setup == null || setup.mode != ExpenseManagementMode.budget) {
      return versions;
    }
    final seed = SpendingPattern.fromSetup(setup);
    await _repository.upsert(seed);
    return <SpendingPattern>[seed];
  }
}
