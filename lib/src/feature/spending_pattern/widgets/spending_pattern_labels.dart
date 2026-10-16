import 'package:app/domain/entities/onboarding_setup/onboarding_setup_config.dart';
import 'package:app/domain/entities/spending_pattern/spending_pattern.dart';
import 'package:app/domain/usecases/spending_pattern_usecase.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/src/feature/onboarding_setup/widgets/category_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_currency.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_labels.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// One row of a plan as the user reads it: fixed costs as a single bill
/// line, then every category.
@immutable
class PlanLine {
  const PlanLine({
    required this.key,
    required this.label,
    required this.amount,
    this.icon,
    this.emoji,
    this.detail,
  });

  /// Stable across versions, so two plans can be compared line by line.
  final String key;
  final String label;

  /// A category shows its emoji; the budget lines show a functional icon.
  final IconData? icon;
  final String? emoji;
  final double amount;
  final String? detail;
}

/// A line whose amount differs between two plans. A null side means the
/// line does not exist in that plan.
@immutable
class PlanLineChange {
  const PlanLineChange({
    required this.label,
    required this.before,
    required this.after,
    this.icon,
    this.emoji,
  });

  final String label;
  final IconData? icon;
  final String? emoji;
  final double? before;
  final double? after;
}

/// Turns spending plan state into localized text. No widget in this feature
/// formats a month or an amount on its own.
class SpendingPatternLabels {
  const SpendingPatternLabels._();

  static const String fixedKey = 'fixed';

  static String amount(double value) => SetupCurrency.format(value);

  /// `11/2026` in Vietnamese, read inside "tháng {month}", and
  /// `November 2026` elsewhere.
  static String month(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context);
    if (locale.languageCode == 'vi') return DateFormat('MM/yyyy').format(date);
    return DateFormat.yMMMM(locale.toString()).format(date);
  }

  static List<PlanLine> lines(AppLocalizations l10n, SpendingPattern plan) {
    return <PlanLine>[
      if (plan.fixedExpenses.isNotEmpty)
        PlanLine(
          key: fixedKey,
          label: l10n.setupLedgerFixed,
          icon: Icons.receipt_long_outlined,
          amount: plan.totalFixedExpenses,
          detail: l10n.spendingPatternFixedCount(plan.fixedExpenses.length),
        ),
      for (final category in SetupCategory.values)
        PlanLine(
          key: category.id,
          label: SetupLabels.category(l10n, category),
          emoji: SetupLabels.categoryEmoji(category),
          amount: plan.amountFor(category),
        ),
      for (final category in plan.customCategories)
        PlanLine(
          key: category.id,
          label: category.name,
          emoji: category.iconKey,
          amount: category.amount,
        ),
    ];
  }

  /// Every figure that moves between [before] and [after], budget first.
  static List<PlanLineChange> changes(
    AppLocalizations l10n,
    SpendingPattern? before,
    SpendingPattern after,
  ) {
    final result = <PlanLineChange>[];
    void compare(
      String label,
      IconData? icon,
      double? a,
      double? b, {
      String? emoji,
    }) {
      if (a == b) return;
      result.add(
        PlanLineChange(
          label: label,
          icon: icon,
          emoji: emoji,
          before: a,
          after: b,
        ),
      );
    }

    compare(
      l10n.setupLedgerIncome,
      Icons.payments_outlined,
      before?.monthlyIncome,
      after.monthlyIncome,
    );
    compare(
      l10n.setupLedgerSaving,
      Icons.savings_outlined,
      before?.monthlySavingGoal,
      after.monthlySavingGoal,
    );
    final beforeLines = <String, PlanLine>{
      if (before != null)
        for (final line in lines(l10n, before)) line.key: line,
    };
    final afterLines = <String, PlanLine>{
      for (final line in lines(l10n, after)) line.key: line,
    };
    for (final key in <String>{...beforeLines.keys, ...afterLines.keys}) {
      final a = beforeLines[key];
      final b = afterLines[key];
      final shown = b ?? a!;
      compare(
        shown.label,
        shown.icon,
        a?.amount,
        b?.amount,
        emoji: shown.emoji,
      );
    }
    return result;
  }

  static String? issue(
    AppLocalizations l10n,
    SpendingPatternIssue? issue,
    SpendingPattern draft,
  ) => switch (issue) {
    null => null,
    SpendingPatternIssue.incomeNotPositive => l10n.spendingPatternErrorIncome,
    SpendingPatternIssue.negativeAmount => l10n.spendingPatternErrorNegative,
    SpendingPatternIssue.savingGoalNotBelowIncome => l10n.setupErrorSavingGoal,
    SpendingPatternIssue.commitmentsExceedIncome => l10n.setupErrorCommitments,
    SpendingPatternIssue.customCategoryNameMissing =>
      l10n.spendingPatternErrorCategoryName,
    SpendingPatternIssue.allocationOverBudget => l10n.setupErrorAllocationOver(
      amount(draft.unallocatedAmount.abs()),
    ),
    SpendingPatternIssue.allocationUnderBudget =>
      l10n.setupErrorAllocationUnder(amount(draft.unallocatedAmount.abs())),
  };
}

/// The leading mark of a plan line: the category's emoji, or a functional
/// icon for income, saving and fixed costs.
class PlanLineGlyph extends StatelessWidget {
  const PlanLineGlyph({
    super.key,
    required this.color,
    this.icon,
    this.emoji,
    this.size = 18,
  });

  final IconData? icon;
  final String? emoji;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final value = emoji;
    if (value != null) return CategoryEmoji(value, size: size - 1);
    return Icon(icon ?? Icons.category_outlined, size: size.sp, color: color);
  }
}
