import 'package:app/domain/entities/onboarding_setup/custom_category.dart';
import 'package:app/domain/entities/onboarding_setup/fixed_expense.dart';
import 'package:app/domain/entities/onboarding_setup/onboarding_setup_config.dart';
import 'package:app/domain/entities/spending_pattern/spending_pattern.dart';
import 'package:app/domain/usecases/spending_pattern_usecase.dart';
import 'package:get/get.dart';

enum SpendingPatternLoadStatus { loading, ready, failed }

/// Holds the draft while the user edits the plan for next month.
///
/// The draft starts from the plan already scheduled for next month when there
/// is one, otherwise from this month's plan. Nothing is written until the
/// user confirms, and what is written always starts next month.
class SpendingPatternEditController extends GetxController {
  SpendingPatternEditController(this._usecase, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final SpendingPatternUsecase _usecase;
  final DateTime Function() _clock;

  final Rx<SpendingPatternLoadStatus> status =
      SpendingPatternLoadStatus.loading.obs;
  final Rxn<SpendingPatternOverview> overview = Rxn<SpendingPatternOverview>();
  final Rxn<SpendingPattern> draft = Rxn<SpendingPattern>();

  /// Set once the plan is saved, so leaving the screen no longer asks
  /// whether to discard anything.
  bool isSaved = false;

  SpendingPattern? _base;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    status.value = SpendingPatternLoadStatus.loading;
    try {
      final loaded = await _usecase.loadOverview(_clock());
      overview.value = loaded;
      _base = loaded.editable ?? SpendingPattern.empty(loaded.nextMonth);
      draft.value = _base;
      status.value = SpendingPatternLoadStatus.ready;
    } catch (_) {
      status.value = SpendingPatternLoadStatus.failed;
    }
  }

  DateTime get currentMonth =>
      overview.value?.currentMonth ?? SpendingPattern.monthStart(_clock());

  DateTime get nextMonth =>
      overview.value?.nextMonth ?? SpendingPattern.nextMonthStart(_clock());

  /// This month's plan, which the review compares against.
  SpendingPattern? get currentPlan => overview.value?.current;

  List<SpendingPatternIssue> get issues {
    final value = draft.value;
    return value == null ? const [] : _usecase.validate(value);
  }

  bool get hasChanges {
    final value = draft.value;
    final base = _base;
    if (value == null || base == null) return false;
    return !value.hasSameFiguresAs(base);
  }

  bool get canReview => hasChanges && issues.isEmpty;

  SpendingPatternIssue? _firstOf(Set<SpendingPatternIssue> group) {
    for (final issue in issues) {
      if (group.contains(issue)) return issue;
    }
    return null;
  }

  /// The problem to show under the income and saving fields.
  SpendingPatternIssue? get budgetIssue => _firstOf(const {
    SpendingPatternIssue.incomeNotPositive,
    SpendingPatternIssue.savingGoalNotBelowIncome,
  });

  SpendingPatternIssue? get fixedIssue =>
      _firstOf(const {SpendingPatternIssue.commitmentsExceedIncome});

  /// The problem to show beside the review action, about the categories.
  SpendingPatternIssue? get allocationIssue => _firstOf(const {
    SpendingPatternIssue.negativeAmount,
    SpendingPatternIssue.customCategoryNameMissing,
    SpendingPatternIssue.allocationOverBudget,
    SpendingPatternIssue.allocationUnderBudget,
  });

  // --- Edits ---------------------------------------------------------------

  void _update(SpendingPattern Function(SpendingPattern plan) change) {
    final value = draft.value;
    if (value == null) return;
    draft.value = change(value);
  }

  void setIncome(double value) =>
      _update((plan) => plan.copyWith(monthlyIncome: value));

  void setSavingGoal(double value) =>
      _update((plan) => plan.copyWith(monthlySavingGoal: value));

  void setCategoryAmount(SetupCategory category, double value) => _update(
    (plan) => plan.copyWith(
      categoryAllocations: <String, double>{
        ...plan.categoryAllocations,
        category.id: value,
      },
    ),
  );

  void addFixedExpense(String name, double amount) => _update(
    (plan) => plan.copyWith(
      fixedExpenses: <FixedExpense>[
        ...plan.fixedExpenses,
        FixedExpense(id: _newId('fixed'), name: name.trim(), amount: amount),
      ],
    ),
  );

  void updateFixedExpense(String id, String name, double amount) => _update(
    (plan) => plan.copyWith(
      fixedExpenses: <FixedExpense>[
        for (final item in plan.fixedExpenses)
          item.id == id
              ? item.copyWith(name: name.trim(), amount: amount)
              : item,
      ],
    ),
  );

  void removeFixedExpense(String id) => _update(
    (plan) => plan.copyWith(
      fixedExpenses: <FixedExpense>[
        for (final item in plan.fixedExpenses)
          if (item.id != id) item,
      ],
    ),
  );

  void addCustomCategory(String name, String iconKey, double amount) => _update(
    (plan) => plan.copyWith(
      customCategories: <CustomCategory>[
        ...plan.customCategories,
        CustomCategory(
          id: _newId('custom'),
          name: name.trim(),
          iconKey: iconKey,
          amount: amount,
        ),
      ],
    ),
  );

  void updateCustomCategory(
    String id, {
    String? name,
    String? iconKey,
    double? amount,
  }) => _update(
    (plan) => plan.copyWith(
      customCategories: <CustomCategory>[
        for (final item in plan.customCategories)
          item.id == id
              ? item.copyWith(
                  name: name?.trim(),
                  iconKey: iconKey,
                  amount: amount,
                )
              : item,
      ],
    ),
  );

  void removeCustomCategory(String id) => _update(
    (plan) => plan.copyWith(
      customCategories: <CustomCategory>[
        for (final item in plan.customCategories)
          if (item.id != id) item,
      ],
    ),
  );

  /// Shares what is left across the built-in categories, the way the setup
  /// questionnaire's automatic allocation does.
  void splitAutomatically() => _update((plan) => plan.withAutomaticSplit());

  /// Writes the draft as next month's plan. Returns null when it could not
  /// be saved, so the review sheet can stay open and say so.
  Future<SpendingPatternSaveOutcome?> save() async {
    final value = draft.value;
    if (value == null || !canReview) return null;
    try {
      final outcome = await _usecase.scheduleForNextMonth(value, _clock());
      isSaved = true;
      return outcome;
    } catch (_) {
      return null;
    }
  }

  String _newId(String prefix) =>
      '${prefix}_${_clock().microsecondsSinceEpoch}';
}
