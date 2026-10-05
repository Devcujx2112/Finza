import 'package:app/domain/entities/onboarding_setup/custom_category.dart';
import 'package:app/domain/entities/onboarding_setup/cycle_day.dart';
import 'package:app/domain/entities/onboarding_setup/fixed_expense.dart';
import 'package:app/domain/entities/onboarding_setup/onboarding_setup_config.dart';
import 'package:app/domain/usecases/onboarding_setup_usecase.dart';
import 'package:get/get.dart';

/// The ordered screens of the questionnaire. The concrete list depends on
/// [ExpenseManagementMode]; see [OnboardingSetupController.steps].
enum SetupStep {
  method,
  analyticsCycleDay,
  incomeDay,
  income,
  savingGoal,
  fixedExpenses,
  allocation,
  completion,
}

/// A problem the user has to resolve before the step can be completed.
/// The controller reports the case, the view resolves the localized text,
/// so no user facing copy lives in the state layer.
enum SetupValidationIssue {
  savingGoalNotBelowIncome,
  commitmentsExceedIncome,
  allocationOverBudget,
  allocationUnderBudget,
}

/// Drives the setup questionnaire: which step is on screen, what the user
/// has answered so far, and whether the current answer lets them continue.
///
/// Answers are kept per branch, so switching the management mode or walking
/// back through the flow never discards what was already filled in.
class OnboardingSetupController extends GetxController {
  OnboardingSetupController(this._usecase, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final OnboardingSetupUsecase _usecase;
  final DateTime Function() _clock;

  /// Amounts are entered in whole dong, so allocation totals are compared
  /// with a tolerance rather than an exact double equality.
  static const double _amountTolerance = 0.5;

  static const List<double> savingGoalPresets = <double>[2000000, 3000000, 5000000];

  // --- Answers -------------------------------------------------------------

  final Rxn<ExpenseManagementMode> mode = Rxn<ExpenseManagementMode>();
  final Rxn<CycleDay> analyticsCycleDay = Rxn<CycleDay>();
  final Rxn<CycleDay> incomeDay = Rxn<CycleDay>();
  final RxDouble monthlyIncome = 0.0.obs;
  final Rxn<SavingGoalChoice> savingGoalChoice = Rxn<SavingGoalChoice>();
  final RxDouble monthlySavingGoal = 0.0.obs;
  final RxList<FixedExpense> fixedExpenses = <FixedExpense>[].obs;
  final Rxn<BudgetAllocationMode> allocationMode = Rxn<BudgetAllocationMode>();

  /// Amounts typed for the built-in categories in the manual mode.
  final RxMap<String, double> manualAllocations = <String, double>{}.obs;

  /// Categories the user added on the allocation step. Each carries its own
  /// amount, which is reserved in both allocation modes.
  final RxList<CustomCategory> customCategories = <CustomCategory>[].obs;

  /// True while the custom day grid is open on a cycle day step.
  final RxBool isAnalyticsCustomDayOpen = false.obs;
  final RxBool isIncomeCustomDayOpen = false.obs;

  /// True when the saving goal amount is typed instead of picked.
  final RxBool isSavingGoalCustom = false.obs;

  final RxInt stepIndex = 0.obs;
  final RxBool isSaving = false.obs;

  // --- Flow ----------------------------------------------------------------

  List<SetupStep> get steps {
    return switch (mode.value) {
      null => const <SetupStep>[SetupStep.method],
      ExpenseManagementMode.analytics => const <SetupStep>[
        SetupStep.method,
        SetupStep.analyticsCycleDay,
        SetupStep.completion,
      ],
      ExpenseManagementMode.budget => const <SetupStep>[
        SetupStep.method,
        SetupStep.incomeDay,
        SetupStep.income,
        SetupStep.savingGoal,
        SetupStep.fixedExpenses,
        SetupStep.allocation,
        SetupStep.completion,
      ],
    };
  }

  SetupStep get currentStep {
    final all = steps;
    return all[stepIndex.value.clamp(0, all.length - 1)];
  }

  /// Number of question steps, which is every step but the closing one.
  int get questionCount => steps.length - 1;

  bool get isOnCompletion => currentStep == SetupStep.completion;

  bool get isOnLastQuestion => stepIndex.value == questionCount - 1;

  /// Back stays available on the closing screen too, so an answer can
  /// still be corrected after the summary is shown.
  bool get canGoBack => stepIndex.value > 0;

  void goNext() {
    if (!canContinue) return;
    if (isOnCompletion) return;
    if (currentStep == SetupStep.allocation ||
        currentStep == SetupStep.analyticsCycleDay) {
      _freezeAllocations();
    }
    stepIndex.value = (stepIndex.value + 1).clamp(0, steps.length - 1);
  }

  void goBack() {
    if (!canGoBack) return;
    stepIndex.value = stepIndex.value - 1;
  }

  // --- Answer mutations ----------------------------------------------------

  void selectMode(ExpenseManagementMode value) => mode.value = value;

  void selectAnalyticsCycleDay(CycleDay value, {bool custom = false}) {
    analyticsCycleDay.value = value;
    isAnalyticsCustomDayOpen.value = custom;
  }

  void selectIncomeDay(CycleDay value, {bool custom = false}) {
    incomeDay.value = value;
    isIncomeCustomDayOpen.value = custom;
  }

  void openAnalyticsCustomDay() {
    isAnalyticsCustomDayOpen.value = true;
    analyticsCycleDay.value = null;
  }

  void openIncomeCustomDay() {
    isIncomeCustomDayOpen.value = true;
    incomeDay.value = null;
  }

  void setMonthlyIncome(double value) => monthlyIncome.value = value;

  void selectSavingGoalChoice(SavingGoalChoice value) {
    savingGoalChoice.value = value;
    if (value == SavingGoalChoice.skipped) {
      monthlySavingGoal.value = 0;
      isSavingGoalCustom.value = false;
    }
  }

  void selectSavingGoalPreset(double value) {
    savingGoalChoice.value = SavingGoalChoice.enabled;
    isSavingGoalCustom.value = false;
    monthlySavingGoal.value = value;
  }

  void openSavingGoalCustom() {
    savingGoalChoice.value = SavingGoalChoice.enabled;
    isSavingGoalCustom.value = true;
    if (savingGoalPresets.contains(monthlySavingGoal.value)) {
      monthlySavingGoal.value = 0;
    }
  }

  void setCustomSavingGoal(double value) {
    savingGoalChoice.value = SavingGoalChoice.enabled;
    monthlySavingGoal.value = value;
  }

  void addFixedExpense(String name, double amount) {
    fixedExpenses.add(
      FixedExpense(
        id: _clock().microsecondsSinceEpoch.toString(),
        name: name.trim(),
        amount: amount,
      ),
    );
  }

  void updateFixedExpense(String id, String name, double amount) {
    final index = fixedExpenses.indexWhere((item) => item.id == id);
    if (index == -1) return;
    fixedExpenses[index] = fixedExpenses[index].copyWith(
      name: name.trim(),
      amount: amount,
    );
  }

  void removeFixedExpense(String id) =>
      fixedExpenses.removeWhere((item) => item.id == id);

  void selectAllocationMode(BudgetAllocationMode value) {
    allocationMode.value = value;
    if (value == BudgetAllocationMode.manual && manualAllocations.isEmpty) {
      manualAllocations.assignAll(<String, double>{
        for (final category in SetupCategory.values) category.id: 0,
      });
    }
  }

  void setManualAllocation(SetupCategory category, double value) =>
      manualAllocations[category.id] = value;

  void addCustomCategory(String name, String iconKey, double amount) {
    customCategories.add(
      CustomCategory(
        id: 'custom_${_clock().microsecondsSinceEpoch}',
        name: name.trim(),
        iconKey: iconKey,
        amount: amount,
      ),
    );
  }

  void updateCustomCategory(
    String id,
    String name,
    String iconKey,
    double amount,
  ) {
    final index = customCategories.indexWhere((item) => item.id == id);
    if (index == -1) return;
    customCategories[index] = customCategories[index].copyWith(
      name: name.trim(),
      iconKey: iconKey,
      amount: amount,
    );
  }

  void removeCustomCategory(String id) =>
      customCategories.removeWhere((item) => item.id == id);

  // --- Derived figures -----------------------------------------------------

  double get totalFixedExpenses =>
      fixedExpenses.fold(0, (sum, item) => sum + item.amount);

  double get remainingBudget =>
      monthlyIncome.value - monthlySavingGoal.value - totalFixedExpenses;

  /// Nothing to split once saving and commitments use up the whole income.
  bool get hasNothingToAllocate => remainingBudget <= _amountTolerance;

  double get customCategoriesTotal =>
      customCategories.fold(0, (sum, item) => sum + item.amount);

  Map<String, double> get _customAllocations => <String, double>{
    for (final category in customCategories) category.id: category.amount,
  };

  /// The suggested split of the built-in categories. Custom categories keep
  /// the amounts the user gave them, and only what is left after them is
  /// shared out.
  Map<String, double> get automaticAllocations {
    final budget = remainingBudget - customCategoriesTotal;
    if (budget <= 0) {
      return <String, double>{
        for (final category in SetupCategory.values) category.id: 0,
        ..._customAllocations,
      };
    }
    final result = <String, double>{};
    double assigned = 0;
    for (final category in SetupCategory.values) {
      if (category == SetupCategory.food) continue;
      // Round to the nearest thousand so the split reads like real money.
      final share = ((budget * category.defaultShare) / 1000).roundToDouble() * 1000;
      result[category.id] = share;
      assigned += share;
    }
    // The largest bucket absorbs the rounding remainder.
    result[SetupCategory.food.id] = (budget - assigned).clamp(0, budget);
    return <String, double>{
      for (final category in SetupCategory.values)
        category.id: result[category.id]!,
      ..._customAllocations,
    };
  }

  /// Built-in amounts are read by id so values left over from an earlier
  /// automatic split never leak in under a removed custom category.
  Map<String, double> get _manualSplit => <String, double>{
    for (final category in SetupCategory.values)
      category.id: manualAllocations[category.id] ?? 0,
    ..._customAllocations,
  };

  Map<String, double> get effectiveAllocations {
    if (hasNothingToAllocate) {
      return <String, double>{
        for (final category in SetupCategory.values) category.id: 0,
        ..._customAllocations,
      };
    }
    return allocationMode.value == BudgetAllocationMode.manual
        ? _manualSplit
        : automaticAllocations;
  }

  double get allocatedTotal =>
      effectiveAllocations.values.fold(0, (sum, value) => sum + value);

  double get unallocatedAmount => remainingBudget - allocatedTotal;

  /// The day the first full cycle begins on, in the current month.
  CycleDay? get cycleStartDay =>
      mode.value == ExpenseManagementMode.budget
      ? incomeDay.value
      : analyticsCycleDay.value;

  /// True when setup finishes on any day other than the cycle start day,
  /// so the budget plan only takes effect at the next cycle.
  bool get isMidCycle {
    if (mode.value != ExpenseManagementMode.budget) return false;
    final day = incomeDay.value;
    if (day == null) return false;
    final now = _clock();
    return now.day != day.resolveFor(now);
  }

  int get resolvedCycleStartDay {
    final now = _clock();
    return cycleStartDay?.resolveFor(now) ?? now.day;
  }

  // --- Validation ----------------------------------------------------------

  SetupValidationIssue? get validationIssue {
    switch (currentStep) {
      case SetupStep.savingGoal:
        if (savingGoalChoice.value != SavingGoalChoice.enabled) return null;
        if (monthlySavingGoal.value <= 0) return null;
        if (monthlySavingGoal.value >= monthlyIncome.value) {
          return SetupValidationIssue.savingGoalNotBelowIncome;
        }
        return null;
      case SetupStep.fixedExpenses:
        if (remainingBudget < -_amountTolerance) {
          return SetupValidationIssue.commitmentsExceedIncome;
        }
        return null;
      case SetupStep.allocation:
        // Custom categories can overspend in either mode, and even when
        // nothing is left to split.
        if (unallocatedAmount < -_amountTolerance) {
          return SetupValidationIssue.allocationOverBudget;
        }
        if (hasNothingToAllocate) return null;
        if (allocationMode.value != BudgetAllocationMode.manual) return null;
        if (unallocatedAmount > _amountTolerance) {
          return SetupValidationIssue.allocationUnderBudget;
        }
        return null;
      case SetupStep.method:
      case SetupStep.analyticsCycleDay:
      case SetupStep.incomeDay:
      case SetupStep.income:
      case SetupStep.completion:
        return null;
    }
  }

  bool get canContinue {
    switch (currentStep) {
      case SetupStep.method:
        return mode.value != null;
      case SetupStep.analyticsCycleDay:
        return analyticsCycleDay.value != null;
      case SetupStep.incomeDay:
        return incomeDay.value != null;
      case SetupStep.income:
        return monthlyIncome.value > 0;
      case SetupStep.savingGoal:
        if (savingGoalChoice.value == SavingGoalChoice.skipped) return true;
        if (savingGoalChoice.value != SavingGoalChoice.enabled) return false;
        return monthlySavingGoal.value > 0 && validationIssue == null;
      case SetupStep.fixedExpenses:
        return validationIssue == null;
      case SetupStep.allocation:
        // The mode choice is hidden when there is nothing to split.
        if (validationIssue != null) return false;
        return hasNothingToAllocate || allocationMode.value != null;
      case SetupStep.completion:
        return true;
    }
  }

  // --- Result --------------------------------------------------------------

  /// Locks the automatic split into `manualAllocations` so the saved
  /// configuration always carries concrete numbers.
  void _freezeAllocations() {
    if (mode.value != ExpenseManagementMode.budget) return;
    if (allocationMode.value == BudgetAllocationMode.automatic) {
      final split = automaticAllocations;
      manualAllocations.assignAll(<String, double>{
        for (final category in SetupCategory.values)
          category.id: split[category.id] ?? 0,
      });
    }
  }

  OnboardingSetupConfig? buildConfig() {
    final selectedMode = mode.value;
    final startDay = cycleStartDay;
    if (selectedMode == null || startDay == null) return null;
    final isBudget = selectedMode == ExpenseManagementMode.budget;
    return OnboardingSetupConfig(
      mode: selectedMode,
      cycleStartDay: startDay,
      monthlyIncome: isBudget ? monthlyIncome.value : 0,
      monthlySavingGoal: isBudget ? monthlySavingGoal.value : 0,
      fixedExpenses: isBudget
          ? List<FixedExpense>.unmodifiable(fixedExpenses)
          : const <FixedExpense>[],
      allocationMode: isBudget ? allocationMode.value : null,
      customCategories: isBudget
          ? List<CustomCategory>.unmodifiable(customCategories)
          : const <CustomCategory>[],
      budgetAllocations: isBudget
          ? Map<String, double>.unmodifiable(effectiveAllocations)
          : const <String, double>{},
      completedAt: _clock(),
    );
  }

  Future<bool> persist() async {
    final config = buildConfig();
    if (config == null) return false;
    isSaving.value = true;
    try {
      await _usecase.completeSetup(config);
      return true;
    } finally {
      isSaving.value = false;
    }
  }
}
