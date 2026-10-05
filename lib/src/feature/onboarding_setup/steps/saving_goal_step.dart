import 'package:app/l10n/app_localizations.dart';
import 'package:app/domain/entities/onboarding_setup/onboarding_setup_config.dart';
import 'package:app/src/feature/onboarding_setup/onboarding_setup_controller.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_controls.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_currency.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_fields.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_palette.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Optional saving goal. The amount only appears once the user says yes,
/// so the screen still reads as a single question.
class SavingGoalStep extends StatefulWidget {
  const SavingGoalStep({
    super.key,
    required this.controller,
    required this.palette,
  });

  final OnboardingSetupController controller;
  final SetupPalette palette;

  @override
  State<SavingGoalStep> createState() => _SavingGoalStepState();
}

class _SavingGoalStepState extends State<SavingGoalStep> {
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    final current = widget.controller.monthlySavingGoal.value;
    final isCustom = widget.controller.isSavingGoalCustom.value;
    _amountController = TextEditingController(
      text: isCustom && current > 0 ? SetupCurrency.formatPlain(current) : '',
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
    final palette = widget.palette;
    final controller = widget.controller;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SetupStepHeader(
          title: l10n.setupSavingTitle,
          description: l10n.setupSavingDescription,
          palette: palette,
        ),
        SizedBox(height: 32.h),
        Obx(() {
          final choice = controller.savingGoalChoice.value;
          return Column(
            children: <Widget>[
              SetupSelectionTile(
                palette: palette,
                icon: Icons.schedule_rounded,
                title: l10n.setupSavingSkip,
                isSelected: choice == SavingGoalChoice.skipped,
                onTap: () {
                  _amountController.clear();
                  controller.selectSavingGoalChoice(SavingGoalChoice.skipped);
                },
              ),
              SizedBox(height: 12.h),
              SetupSelectionTile(
                palette: palette,
                icon: Icons.savings_outlined,
                title: l10n.setupSavingEnable,
                isSelected: choice == SavingGoalChoice.enabled,
                onTap: () =>
                    controller.selectSavingGoalChoice(SavingGoalChoice.enabled),
              ),
            ],
          );
        }),
        Obx(() {
          final isEnabled =
              controller.savingGoalChoice.value == SavingGoalChoice.enabled;
          return AnimatedSize(
            duration: SetupMotion.resolve(context, SetupMotion.reveal),
            curve: SetupMotion.curve,
            alignment: Alignment.topCenter,
            child: isEnabled
                ? Padding(
                    padding: EdgeInsets.only(top: 26.h),
                    child: _SavingAmountSection(
                      controller: controller,
                      palette: palette,
                      amountController: _amountController,
                    ),
                  )
                : const SizedBox(width: double.infinity),
          );
        }),
      ],
    );
  }
}

class _SavingAmountSection extends StatelessWidget {
  const _SavingAmountSection({
    required this.controller,
    required this.palette,
    required this.amountController,
  });

  final OnboardingSetupController controller;
  final SetupPalette palette;
  final TextEditingController amountController;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          l10n.setupSavingAmountTitle,
          style: SetupText.sectionTitle(palette),
        ),
        SizedBox(height: 14.h),
        Obx(() {
          final isCustom = controller.isSavingGoalCustom.value;
          final amount = controller.monthlySavingGoal.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Wrap(
                spacing: 10.w,
                runSpacing: 10.h,
                children: <Widget>[
                  for (final preset
                      in OnboardingSetupController.savingGoalPresets)
                    SetupChoiceChip(
                      palette: palette,
                      label: SetupCurrency.format(preset),
                      isSelected: !isCustom && amount == preset,
                      onTap: () {
                        amountController.clear();
                        controller.selectSavingGoalPreset(preset);
                      },
                    ),
                  SetupChoiceChip(
                    palette: palette,
                    label: l10n.setupSavingCustom,
                    isSelected: isCustom,
                    onTap: controller.openSavingGoalCustom,
                  ),
                ],
              ),
              AnimatedSize(
                duration: SetupMotion.resolve(context, SetupMotion.reveal),
                curve: SetupMotion.curve,
                alignment: Alignment.topCenter,
                child: isCustom
                    ? Padding(
                        padding: EdgeInsets.only(top: 18.h),
                        child: SetupAmountField(
                          controller: amountController,
                          palette: palette,
                          label: l10n.setupSavingFieldLabel,
                          isLarge: true,
                          onChanged: controller.setCustomSavingGoal,
                        ),
                      )
                    : const SizedBox(width: double.infinity),
              ),
            ],
          );
        }),
      ],
    );
  }
}
