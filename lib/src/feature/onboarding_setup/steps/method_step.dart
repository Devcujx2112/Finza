import 'package:app/l10n/app_localizations.dart';
import 'package:app/domain/entities/onboarding_setup/onboarding_setup_config.dart';
import 'package:app/src/feature/onboarding_setup/onboarding_setup_controller.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_controls.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// The first decision: which of the two ways of working the user wants.
class MethodStep extends StatelessWidget {
  const MethodStep({
    super.key,
    required this.controller,
    required this.palette,
  });

  final OnboardingSetupController controller;
  final SetupPalette palette;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SetupStepHeader(
          title: l10n.setupMethodTitle,
          description: l10n.setupMethodDescription,
          palette: palette,
        ),
        SizedBox(height: 32.h),
        Obx(() {
          final selected = controller.mode.value;
          return Column(
            children: <Widget>[
              SetupSelectionTile(
                palette: palette,
                icon: Icons.insights_rounded,
                title: l10n.setupMethodAnalyticsTitle,
                description: l10n.setupMethodAnalyticsDescription,
                isSelected: selected == ExpenseManagementMode.analytics,
                onTap: () =>
                    controller.selectMode(ExpenseManagementMode.analytics),
              ),
              SizedBox(height: 12.h),
              SetupSelectionTile(
                palette: palette,
                icon: Icons.savings_outlined,
                title: l10n.setupMethodBudgetTitle,
                description: l10n.setupMethodBudgetDescription,
                isSelected: selected == ExpenseManagementMode.budget,
                onTap: () =>
                    controller.selectMode(ExpenseManagementMode.budget),
              ),
            ],
          );
        }),
      ],
    );
  }
}
