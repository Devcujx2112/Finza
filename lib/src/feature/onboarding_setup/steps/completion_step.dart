import 'package:app/l10n/app_localizations.dart';
import 'package:app/domain/entities/onboarding_setup/onboarding_setup_config.dart';
import 'package:app/src/feature/onboarding_setup/onboarding_setup_controller.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_controls.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_currency.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_labels.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_palette.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompletionStep extends StatelessWidget {
  const CompletionStep({
    super.key,
    required this.controller,
    required this.palette,
  });

  final OnboardingSetupController controller;
  final SetupPalette palette;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final body = controller.isMidCycle
        ? l10n.setupMidCycleBody(controller.resolvedCycleStartDay.toString())
        : l10n.setupReviewBody;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(l10n.setupReviewTitle, style: SetupText.question(palette)),
        SizedBox(height: 10.h),
        Text(body, style: SetupText.description(palette)),
        SizedBox(height: 28.h),
        _SummaryCard(controller: controller, palette: palette),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.controller, required this.palette});

  final OnboardingSetupController controller;
  final SetupPalette palette;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mode = controller.mode.value;
    final cycleDay = controller.cycleStartDay;
    final isBudget = mode == ExpenseManagementMode.budget;

    return SetupPanel(
      palette: palette,
      padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(l10n.setupSummaryTitle, style: SetupText.sectionTitle(palette)),
          SizedBox(height: 10.h),
          if (mode != null)
            SetupLedgerRow(
              palette: palette,
              label: l10n.setupSummaryMode,
              value: SetupLabels.mode(l10n, mode),
            ),
          if (cycleDay != null)
            SetupLedgerRow(
              palette: palette,
              label: l10n.setupSummaryCycleStart,
              value: SetupLabels.cycleDay(l10n, cycleDay),
            ),
          if (isBudget) ...<Widget>[
            SetupLedgerRow(
              palette: palette,
              label: l10n.setupLedgerIncome,
              value: SetupCurrency.format(controller.monthlyIncome.value),
            ),
            SetupLedgerRow(
              palette: palette,
              label: l10n.setupLedgerSaving,
              value: SetupCurrency.format(controller.monthlySavingGoal.value),
            ),
            SetupLedgerRow(
              palette: palette,
              label: l10n.setupLedgerFixed,
              value: SetupCurrency.format(controller.totalFixedExpenses),
            ),
            SetupHairline(palette: palette),
            SetupLedgerRow(
              palette: palette,
              label: l10n.setupLedgerRemaining,
              value: SetupCurrency.format(
                controller.remainingBudget < 0 ? 0 : controller.remainingBudget,
              ),
              isTotal: true,
            ),
          ],
        ],
      ),
    );
  }
}
