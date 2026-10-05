import 'package:app/l10n/app_localizations.dart';
import 'package:app/domain/entities/onboarding_setup/custom_category.dart';
import 'package:app/domain/entities/onboarding_setup/onboarding_setup_config.dart';
import 'package:app/src/feature/onboarding_setup/onboarding_setup_controller.dart';
import 'package:app/src/feature/onboarding_setup/widgets/category_icons.dart';
import 'package:app/src/feature/onboarding_setup/widgets/custom_category_sheet.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_controls.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_currency.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_fields.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_labels.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_palette.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// Splits what is left of the income across the spending categories,
/// either with a suggested split or by hand. Beyond the built-in categories
/// the user can add their own, each with an icon, a name and an amount.
class AllocationStep extends StatefulWidget {
  const AllocationStep({
    super.key,
    required this.controller,
    required this.palette,
  });

  final OnboardingSetupController controller;
  final SetupPalette palette;

  @override
  State<AllocationStep> createState() => _AllocationStepState();
}

class _AllocationStepState extends State<AllocationStep> {
  late final Map<SetupCategory, TextEditingController> _amountControllers;

  @override
  void initState() {
    super.initState();
    _amountControllers = <SetupCategory, TextEditingController>{
      for (final category in SetupCategory.values)
        category: TextEditingController(
          text: _seedFor(category),
        ),
    };
  }

  String _seedFor(SetupCategory category) {
    final value = widget.controller.manualAllocations[category.id] ?? 0;
    return value > 0 ? SetupCurrency.formatPlain(value) : '';
  }

  @override
  void dispose() {
    for (final controller in _amountControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _addCustom() async {
    final draft = await showCustomCategorySheet(context);
    if (draft == null) return;
    widget.controller.addCustomCategory(draft.name, draft.iconKey, draft.amount);
  }

  Future<void> _editCustom(CustomCategory category) async {
    final draft = await showCustomCategorySheet(context, existing: category);
    if (draft == null) return;
    widget.controller.updateCustomCategory(
      category.id,
      draft.name,
      draft.iconKey,
      draft.amount,
    );
  }

  void _removeCustom(CustomCategory category) {
    final l10n = AppLocalizations.of(context)!;
    final palette = widget.palette;
    final categories = widget.controller.customCategories;
    final index = categories.indexWhere((item) => item.id == category.id);
    widget.controller.removeCustomCategory(category.id);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: palette.primaryText,
          content: Text(
            l10n.setupFixedRemoved(category.name),
            style: GoogleFonts.poppins(
              color: palette.pageBackground,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          action: SnackBarAction(
            label: l10n.undo,
            textColor: palette.accent,
            onPressed: () => categories.insert(
              index.clamp(0, categories.length),
              category,
            ),
          ),
        ),
      );
  }

  Widget _customSection() => _CustomCategoriesSection(
    palette: widget.palette,
    categories: widget.controller.customCategories.toList(),
    onAdd: _addCustom,
    onEdit: _editCustom,
    onRemove: _removeCustom,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = widget.palette;
    final controller = widget.controller;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SetupStepHeader(
          title: l10n.setupAllocationTitle,
          description: l10n.setupAllocationDescription,
          palette: palette,
        ),
        SizedBox(height: 28.h),
        Obx(
          () => _BudgetLedger(
            palette: palette,
            income: controller.monthlyIncome.value,
            saving: controller.monthlySavingGoal.value,
            fixed: controller.totalFixedExpenses,
            remaining: controller.remainingBudget,
          ),
        ),
        SizedBox(height: 28.h),
        Obx(() {
          if (controller.hasNothingToAllocate) {
            // Custom categories stay listed so any that no longer fit can
            // still be edited or removed.
            return Column(
              children: <Widget>[
                _NothingToAllocate(palette: palette),
                if (controller.customCategories.isNotEmpty) ...<Widget>[
                  SizedBox(height: 24.h),
                  _customSection(),
                ],
              ],
            );
          }
          final mode = controller.allocationMode.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SetupSelectionTile(
                palette: palette,
                icon: Icons.auto_awesome_outlined,
                title: l10n.setupAllocationAutoTitle,
                description: l10n.setupAllocationAutoDescription,
                isSelected: mode == BudgetAllocationMode.automatic,
                onTap: () => controller.selectAllocationMode(
                  BudgetAllocationMode.automatic,
                ),
              ),
              SizedBox(height: 12.h),
              SetupSelectionTile(
                palette: palette,
                icon: Icons.tune_rounded,
                title: l10n.setupAllocationManualTitle,
                description: l10n.setupAllocationManualDescription,
                isSelected: mode == BudgetAllocationMode.manual,
                onTap: () =>
                    controller.selectAllocationMode(BudgetAllocationMode.manual),
              ),
              AnimatedSize(
                duration: SetupMotion.resolve(context, SetupMotion.reveal),
                curve: SetupMotion.curve,
                alignment: Alignment.topCenter,
                child: switch (mode) {
                  null => const SizedBox(width: double.infinity),
                  BudgetAllocationMode.automatic => Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: Column(
                      children: <Widget>[
                        _SuggestedSplit(
                          palette: palette,
                          allocations: controller.automaticAllocations,
                        ),
                        SizedBox(height: 24.h),
                        _customSection(),
                      ],
                    ),
                  ),
                  BudgetAllocationMode.manual => Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: _ManualSplit(
                      controller: controller,
                      palette: palette,
                      amountControllers: _amountControllers,
                      customSection: _customSection(),
                    ),
                  ),
                },
              ),
            ],
          );
        }),
      ],
    );
  }
}

class _BudgetLedger extends StatelessWidget {
  const _BudgetLedger({
    required this.palette,
    required this.income,
    required this.saving,
    required this.fixed,
    required this.remaining,
  });

  final SetupPalette palette;
  final double income;
  final double saving;
  final double fixed;
  final double remaining;

  /// Subtracted lines carry a minus, except when there is nothing to
  /// subtract, where "-0" would read as a mistake.
  String _signed(double amount) => amount > 0
      ? '-${SetupCurrency.format(amount)}'
      : SetupCurrency.format(0);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: <Widget>[
        SetupLedgerRow(
          palette: palette,
          label: l10n.setupLedgerIncome,
          value: SetupCurrency.format(income),
        ),
        SetupLedgerRow(
          palette: palette,
          label: l10n.setupLedgerSaving,
          value: _signed(saving),
        ),
        SetupLedgerRow(
          palette: palette,
          label: l10n.setupLedgerFixed,
          value: _signed(fixed),
        ),
        SetupHairline(palette: palette),
        SetupLedgerRow(
          palette: palette,
          label: l10n.setupLedgerRemaining,
          value: SetupCurrency.format(remaining < 0 ? 0 : remaining),
          isTotal: true,
        ),
      ],
    );
  }
}

class _NothingToAllocate extends StatelessWidget {
  const _NothingToAllocate({required this.palette});

  final SetupPalette palette;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 26.sp,
            color: palette.accentStrong,
          ),
          SizedBox(height: 14.h),
          Text(
            l10n.setupAllocationEmptyTitle,
            textAlign: TextAlign.center,
            style: SetupText.sectionTitle(palette),
          ),
          SizedBox(height: 8.h),
          Text(
            l10n.setupAllocationEmptyBody,
            textAlign: TextAlign.center,
            style: SetupText.optionBody(palette),
          ),
        ],
      ),
    );
  }
}

class _SuggestedSplit extends StatelessWidget {
  const _SuggestedSplit({required this.palette, required this.allocations});

  final SetupPalette palette;
  final Map<String, double> allocations;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SetupPanel(
      palette: palette,
      child: Column(
        children: <Widget>[
          for (final category in SetupCategory.values)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Row(
                children: <Widget>[
                  Icon(
                    SetupLabels.categoryIcon(category),
                    size: 18.sp,
                    color: palette.secondaryText,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      SetupLabels.category(l10n, category),
                      style: SetupText.ledgerValue(palette),
                    ),
                  ),
                  Text(
                    SetupCurrency.format(allocations[category.id] ?? 0),
                    style: SetupText.ledgerValue(palette),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ManualSplit extends StatelessWidget {
  const _ManualSplit({
    required this.controller,
    required this.palette,
    required this.amountControllers,
    required this.customSection,
  });

  final OnboardingSetupController controller;
  final SetupPalette palette;
  final Map<SetupCategory, TextEditingController> amountControllers;
  final Widget customSection;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: <Widget>[
        for (final category in SetupCategory.values)
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Padding(
              padding: EdgeInsets.zero,
              child: Row(
                children: <Widget>[
                  Icon(
                    SetupLabels.categoryIcon(category),
                    size: 18.sp,
                    color: palette.secondaryText,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    flex: 4,
                    child: Text(
                      SetupLabels.category(l10n, category),
                      maxLines: 2,
                      style: SetupText.optionTitle(
                        palette,
                      ).copyWith(fontSize: 13.5.sp),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    flex: 5,
                    child: SetupAmountField(
                      controller: amountControllers[category]!,
                      palette: palette,
                      alignEnd: true,
                      onChanged: (value) =>
                          controller.setManualAllocation(category, value),
                    ),
                  ),
                ],
              ),
            ),
          ),
        SizedBox(height: 12.h),
        customSection,
        SizedBox(height: 16.h),
        Obx(
          () => _AllocationTotals(
            palette: palette,
            allocated: controller.allocatedTotal,
            unallocated: controller.unallocatedAmount,
          ),
        ),
      ],
    );
  }
}

class _AllocationTotals extends StatelessWidget {
  const _AllocationTotals({
    required this.palette,
    required this.allocated,
    required this.unallocated,
  });

  final SetupPalette palette;
  final double allocated;
  final double unallocated;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final remainingColor = unallocated < 0
        ? palette.errorText
        : unallocated == 0
        ? palette.accentStrong
        : palette.primaryText;

    return SetupPanel(
      palette: palette,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  l10n.setupAllocatedLabel,
                  style: SetupText.ledgerLabel(palette),
                ),
              ),
              Text(
                SetupCurrency.format(allocated),
                style: SetupText.ledgerValue(palette),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  l10n.setupUnallocatedLabel,
                  style: SetupText.ledgerLabel(palette),
                ),
              ),
              Text(
                SetupCurrency.format(unallocated),
                style: SetupText.ledgerValue(
                  palette,
                ).copyWith(color: remainingColor, fontSize: 15.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The categories the user added. Their amounts are set aside first, in
/// either allocation mode.
class _CustomCategoriesSection extends StatelessWidget {
  const _CustomCategoriesSection({
    required this.palette,
    required this.categories,
    required this.onAdd,
    required this.onEdit,
    required this.onRemove,
  });

  final SetupPalette palette;
  final List<CustomCategory> categories;
  final VoidCallback onAdd;
  final ValueChanged<CustomCategory> onEdit;
  final ValueChanged<CustomCategory> onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          l10n.setupCustomCategoriesTitle,
          style: SetupText.sectionTitle(palette),
        ),
        SizedBox(height: 4.h),
        Text(
          l10n.setupCustomCategoriesDescription,
          style: SetupText.optionBody(palette),
        ),
        SizedBox(height: 12.h),
        for (final category in categories) ...<Widget>[
          _CustomCategoryRow(
            palette: palette,
            category: category,
            onEdit: () => onEdit(category),
            onRemove: () => onRemove(category),
          ),
          SetupHairline(palette: palette),
        ],
        SizedBox(height: 4.h),
        _AddCustomTile(palette: palette, onTap: onAdd),
      ],
    );
  }
}

class _CustomCategoryRow extends StatelessWidget {
  const _CustomCategoryRow({
    required this.palette,
    required this.category,
    required this.onEdit,
    required this.onRemove,
  });

  final SetupPalette palette;
  final CustomCategory category;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: <Widget>[
          Container(
            height: 38.r,
            width: 38.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: palette.accentSoft,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              SetupCategoryIcons.resolve(category.iconKey),
              size: 19.sp,
              color: palette.accentStrong,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  category.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: SetupText.optionTitle(palette),
                ),
                SizedBox(height: 2.h),
                Text(
                  SetupCurrency.format(category.amount),
                  style: SetupText.optionBody(
                    palette,
                  ).copyWith(color: palette.accentStrong, fontSize: 13.sp),
                ),
              ],
            ),
          ),
          _RowAction(
            palette: palette,
            icon: Icons.edit_outlined,
            label: l10n.edit,
            onTap: onEdit,
          ),
          _RowAction(
            palette: palette,
            icon: Icons.delete_outline_rounded,
            label: l10n.delete,
            onTap: onRemove,
            color: palette.errorText,
          ),
        ],
      ),
    );
  }
}

class _RowAction extends StatelessWidget {
  const _RowAction({
    required this.palette,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final SetupPalette palette;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: SetupPressable(
        onTap: onTap,
        scale: 0.88,
        child: Padding(
          padding: EdgeInsets.all(10.w),
          child: Icon(
            icon,
            size: 20.sp,
            color: color ?? palette.secondaryText,
          ),
        ),
      ),
    );
  }
}

class _AddCustomTile extends StatelessWidget {
  const _AddCustomTile({required this.palette, required this.onTap});

  final SetupPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Semantics(
      button: true,
      child: SetupPressable(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: palette.accent, width: 1.2.w),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.add_rounded,
                size: 20.sp,
                color: palette.accentStrong,
              ),
              SizedBox(width: 8.w),
              Text(
                l10n.setupCustomCategoryAdd,
                style: SetupText.optionTitle(
                  palette,
                ).copyWith(color: palette.accentStrong),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
