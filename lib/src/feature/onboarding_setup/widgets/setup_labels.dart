import 'package:app/l10n/app_localizations.dart';
import 'package:app/domain/entities/onboarding_setup/cycle_day.dart';
import 'package:app/domain/entities/onboarding_setup/onboarding_setup_config.dart';
import 'package:app/src/feature/onboarding_setup/onboarding_setup_controller.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_controls.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_currency.dart';
import 'package:app/src/feature/budget/models/expense_model.dart';

class SetupLabels {
  const SetupLabels._();

  static String cycleDay(AppLocalizations l10n, CycleDay day) =>
      day.isLastDayOfMonth
      ? l10n.setupLastDayOfMonth
      : l10n.setupDayLabel(day.day.toString().padLeft(2, '0'));

  static String dayNumber(AppLocalizations l10n, int day) =>
      l10n.setupDayLabel(day.toString().padLeft(2, '0'));

  static String mode(AppLocalizations l10n, ExpenseManagementMode mode) =>
      switch (mode) {
        ExpenseManagementMode.analytics => l10n.setupMethodAnalyticsTitle,
        ExpenseManagementMode.budget => l10n.setupMethodBudgetTitle,
      };

  static String category(AppLocalizations l10n, SetupCategory category) =>
      switch (category) {
        SetupCategory.transport => l10n.setupCategoryTransport,
        SetupCategory.shopping => l10n.setupCategoryShopping,
        SetupCategory.entertainment => l10n.setupCategoryEntertainment,
      };

  static String categoryEmoji(SetupCategory category) =>
      ExpenseCategory.getById(category.id).emoji;

  static String? validation(
    AppLocalizations l10n,
    SetupValidationIssue? issue, {
    double difference = 0,
  }) => switch (issue) {
    null => null,
    SetupValidationIssue.savingGoalNotBelowIncome => l10n.setupErrorSavingGoal,
    SetupValidationIssue.commitmentsExceedIncome => l10n.setupErrorCommitments,
    SetupValidationIssue.allocationOverBudget => l10n.setupErrorAllocationOver(
      SetupCurrency.format(difference.abs()),
    ),
    SetupValidationIssue.allocationUnderBudget =>
      l10n.setupErrorAllocationUnder(SetupCurrency.format(difference.abs())),
  };

  static SetupMessageTone validationTone(SetupValidationIssue? issue) =>
      issue == SetupValidationIssue.allocationUnderBudget
      ? SetupMessageTone.guidance
      : SetupMessageTone.error;
}
