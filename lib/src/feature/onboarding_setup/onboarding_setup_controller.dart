import 'package:app/domain/entities/onboarding_setup/custom_category.dart';
import 'package:app/domain/entities/onboarding_setup/cycle_day.dart';
import 'package:app/domain/entities/onboarding_setup/fixed_expense.dart';
import 'package:app/domain/entities/onboarding_setup/onboarding_setup_config.dart';
import 'package:app/domain/usecases/onboarding_setup_usecase.dart';
import 'package:app/models/onboarding/setup_user_budget_request_model.dart';
import 'package:app/src/core/constant/constant.dart';
import 'package:app/src/core/error/app_exception.dart';
import 'package:app/src/feature/budget/models/expense_model.dart';
import 'package:app/src/feature/onboarding_setup/widgets/category_icons.dart';
import 'package:get/get.dart';

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

enum SetupValidationIssue {
  savingGoalNotBelowIncome,
  commitmentsExceedIncome,
  allocationOverBudget,
  allocationUnderBudget,
}

class OnboardingSetupController extends GetxController {
  OnboardingSetupController(this._usecase, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final OnboardingSetupUsecase _usecase;
  final DateTime Function() _clock;

  static const double _amountTolerance = 0.5;

  static const List<double> savingGoalPresets = <double>[
    2000000,
    3000000,
    5000000,
  ];

  final Rxn<ExpenseManagementMode> mode = Rxn<ExpenseManagementMode>();
  final Rxn<CycleDay> analyticsCycleDay = Rxn<CycleDay>();
  final Rxn<CycleDay> incomeDay = Rxn<CycleDay>();
  final RxDouble monthlyIncome = 0.0.obs;
  final Rxn<SavingGoalChoice> savingGoalChoice = Rxn<SavingGoalChoice>();
  final RxDouble monthlySavingGoal = 0.0.obs;
  final RxList<FixedExpense> fixedExpenses = <FixedExpense>[].obs;
  final Rxn<BudgetAllocationMode> allocationMode = Rxn<BudgetAllocationMode>();

  final RxMap<String, double> manualAllocations = <String, double>{}.obs;

  final RxList<CustomCategory> customCategories = <CustomCategory>[].obs;

  final RxBool isAnalyticsCustomDayOpen = false.obs;
  final RxBool isIncomeCustomDayOpen = false.obs;

  final RxBool isSavingGoalCustom = false.obs;

  final RxInt stepIndex = 0.obs;
  final RxBool isSaving = false.obs;

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

  int get questionCount => steps.length - 1;

  bool get isOnCompletion => currentStep == SetupStep.completion;

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

  double get totalFixedExpenses =>
      fixedExpenses.fold(0, (sum, item) => sum + item.amount);

  double get remainingBudget =>
      monthlyIncome.value - monthlySavingGoal.value - totalFixedExpenses;

  bool get hasNothingToAllocate => remainingBudget <= _amountTolerance;

  double get customCategoriesTotal =>
      customCategories.fold(0, (sum, item) => sum + item.amount);

  Map<String, double> get _customAllocations => <String, double>{
    for (final category in customCategories) category.id: category.amount,
  };

  Map<String, double> get automaticAllocations {
    final budget = remainingBudget - customCategoriesTotal;
    if (budget <= 0) {
      return <String, double>{
        for (final category in SetupCategory.values) category.id: 0,
        ..._customAllocations,
      };
    }
    final result = <String, double>{};
    for (final category in SetupCategory.values) {
      final share =
          ((budget * category.defaultShare) / 1000).roundToDouble() * 1000;
      result[category.id] = share;
    }
    return <String, double>{
      for (final category in SetupCategory.values)
        category.id: result[category.id]!,
      ..._customAllocations,
    };
  }

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

  CycleDay? get cycleStartDay => mode.value == ExpenseManagementMode.budget
      ? incomeDay.value
      : analyticsCycleDay.value;

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
        if (validationIssue != null) return false;
        return hasNothingToAllocate || allocationMode.value != null;
      case SetupStep.completion:
        return true;
    }
  }

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

  List<SetupUserBudgetRequestModel> budgetRequests({
    required String Function(SetupCategory category) categoryName,
    required String fixedCostCategoryName,
  }) {
    if (mode.value != ExpenseManagementMode.budget) return const [];
    final allocations = effectiveAllocations;
    return <SetupUserBudgetRequestModel>[
      for (final item in fixedExpenses)
        SetupUserBudgetRequestModel(
          typeCost: Constants.fixedCost,
          nameCost: item.name,
          amount: item.amount.round(),
          categoriesName: fixedCostCategoryName,
          stringIcon: SetupCategoryIcons.fixedCost,
        ),
      for (final category in SetupCategory.values)
        if ((allocations[category.id] ?? 0) > 0)
          SetupUserBudgetRequestModel(
            typeCost: Constants.flexibleCosts,
            nameCost: categoryName(category),
            amount: allocations[category.id]!.round(),
            categoriesName: categoryName(category),
            stringIcon: ExpenseCategory.getById(category.id).emoji,
          ),
      for (final category in customCategories)
        if (category.amount > 0)
          SetupUserBudgetRequestModel(
            typeCost: Constants.flexibleCosts,
            nameCost: category.name,
            amount: category.amount.round(),
            categoriesName: category.name,
            stringIcon: SetupCategoryIcons.resolve(category.iconKey),
          ),
    ];
  }

  Future<bool> persist({
    required String Function(SetupCategory category) categoryName,
    required String fixedCostCategoryName,
    required void Function(String message) showError,
    required String fallbackError,
  }) async {
    final config = buildConfig();
    if (config == null) return false;
    isSaving.value = true;
    try {
      final saved = await _usecase.completeSetup(
        config,
        budgets: budgetRequests(
          categoryName: categoryName,
          fixedCostCategoryName: fixedCostCategoryName,
        ),
      );
      if (!saved) showError(fallbackError);
      return saved;
    } on AppException catch (e) {
      showError(e.message.isNotEmpty ? e.message : fallbackError);
      return false;
    } catch (_) {
      showError(fallbackError);
      return false;
    } finally {
      isSaving.value = false;
    }
  }
}
