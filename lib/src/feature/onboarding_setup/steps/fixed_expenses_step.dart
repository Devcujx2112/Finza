import 'package:app/l10n/app_localizations.dart';
import 'package:app/domain/entities/onboarding_setup/fixed_expense.dart';
import 'package:app/src/feature/onboarding_setup/onboarding_setup_controller.dart';
import 'package:app/src/feature/onboarding_setup/widgets/fixed_expense_sheet.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_controls.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_currency.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_palette.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// Recurring monthly commitments. Adding any is optional, so this step can
/// always be completed.
class FixedExpensesStep extends StatelessWidget {
  const FixedExpensesStep({
    super.key,
    required this.controller,
    required this.palette,
  });

  final OnboardingSetupController controller;
  final SetupPalette palette;

  Future<void> _add(BuildContext context) async {
    final draft = await showFixedExpenseSheet(context);
    if (draft == null) return;
    controller.addFixedExpense(draft.name, draft.amount);
  }

  Future<void> _edit(BuildContext context, FixedExpense expense) async {
    final draft = await showFixedExpenseSheet(context, existing: expense);
    if (draft == null) return;
    controller.updateFixedExpense(expense.id, draft.name, draft.amount);
  }

  void _remove(BuildContext context, FixedExpense expense) {
    final l10n = AppLocalizations.of(context)!;
    final index = controller.fixedExpenses.indexWhere(
      (item) => item.id == expense.id,
    );
    controller.removeFixedExpense(expense.id);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: palette.primaryText,
          content: Text(
            l10n.setupFixedRemoved(expense.name),
            style: GoogleFonts.poppins(
              color: palette.pageBackground,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          action: SnackBarAction(
            label: l10n.undo,
            textColor: palette.accent,
            onPressed: () => controller.fixedExpenses.insert(
              index.clamp(0, controller.fixedExpenses.length),
              expense,
            ),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SetupStepHeader(
          title: l10n.setupFixedTitle,
          description: l10n.setupFixedDescription,
          palette: palette,
        ),
        SizedBox(height: 32.h),
        Obx(() {
          final expenses = controller.fixedExpenses;
          if (expenses.isEmpty) {
            return _EmptyState(palette: palette);
          }
          return Column(
            children: <Widget>[
              for (final expense in expenses) ...<Widget>[
                _FixedExpenseRow(
                  palette: palette,
                  expense: expense,
                  onEdit: () => _edit(context, expense),
                  onRemove: () => _remove(context, expense),
                ),
                SetupHairline(palette: palette),
              ],
              SizedBox(height: 4.h),
              _TotalRow(palette: palette, total: controller.totalFixedExpenses),
            ],
          );
        }),
        SizedBox(height: 16.h),
        _AddTile(palette: palette, onTap: () => _add(context)),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.palette});

  final SetupPalette palette;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: Column(
        children: <Widget>[
          Container(
            height: 56.r,
            width: 56.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: palette.fieldSurface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              size: 25.sp,
              color: palette.accentStrong,
            ),
          ),
          SizedBox(height: 18.h),
          Text(
            l10n.setupFixedEmptyTitle,
            textAlign: TextAlign.center,
            style: SetupText.sectionTitle(palette),
          ),
          SizedBox(height: 8.h),
          Text(
            l10n.setupFixedEmptyBody,
            textAlign: TextAlign.center,
            style: SetupText.optionBody(palette),
          ),
        ],
      ),
    );
  }
}

class _FixedExpenseRow extends StatelessWidget {
  const _FixedExpenseRow({
    required this.palette,
    required this.expense,
    required this.onEdit,
    required this.onRemove,
  });

  final SetupPalette palette;
  final FixedExpense expense;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  expense.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: SetupText.optionTitle(palette),
                ),
                SizedBox(height: 2.h),
                Text(
                  SetupCurrency.format(expense.amount),
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

class _TotalRow extends StatelessWidget {
  const _TotalRow({required this.palette, required this.total});

  final SetupPalette palette;
  final double total;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              l10n.setupFixedTotal,
              style: SetupText.ledgerLabel(palette),
            ),
          ),
          Text(
            SetupCurrency.format(total),
            style: SetupText.ledgerValue(palette).copyWith(
              color: palette.accentStrong,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddTile extends StatelessWidget {
  const _AddTile({required this.palette, required this.onTap});

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
                l10n.setupFixedAdd,
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
