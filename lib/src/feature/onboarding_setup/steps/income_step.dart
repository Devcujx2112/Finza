import 'package:app/l10n/app_localizations.dart';
import 'package:app/src/feature/onboarding_setup/onboarding_setup_controller.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_controls.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_currency.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_fields.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Monthly income. One field, nothing else on the screen.
class IncomeStep extends StatefulWidget {
  const IncomeStep({
    super.key,
    required this.controller,
    required this.palette,
  });

  final OnboardingSetupController controller;
  final SetupPalette palette;

  @override
  State<IncomeStep> createState() => _IncomeStepState();
}

class _IncomeStepState extends State<IncomeStep> {
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    // Seeded from state so a value entered before going back is still here.
    final current = widget.controller.monthlyIncome.value;
    _amountController = TextEditingController(
      text: current > 0 ? SetupCurrency.formatPlain(current) : '',
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SetupStepHeader(
          title: l10n.setupIncomeTitle,
          description: l10n.setupIncomeDescription,
          palette: palette,
        ),
        SizedBox(height: 26.h),
        SetupAmountField(
          controller: _amountController,
          palette: palette,
          label: l10n.setupIncomeFieldLabel,
          isLarge: true,
          autofocus: true,
          hintText: '0',
          onChanged: widget.controller.setMonthlyIncome,
        ),
      ],
    );
  }

  SetupPalette get palette => widget.palette;
}
