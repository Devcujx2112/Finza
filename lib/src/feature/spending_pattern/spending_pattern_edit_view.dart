import 'package:app/domain/entities/onboarding_setup/custom_category.dart';
import 'package:app/domain/entities/onboarding_setup/fixed_expense.dart';
import 'package:app/domain/entities/onboarding_setup/onboarding_setup_config.dart';
import 'package:app/domain/entities/spending_pattern/spending_pattern.dart';
import 'package:app/domain/usecases/spending_pattern_usecase.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/src/core/color/app_colors.dart';
import 'package:app/src/core/widget/adaptive_page.dart';
import 'package:app/src/feature/onboarding_setup/widgets/category_icons.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_labels.dart';
import 'package:app/src/feature/spending_pattern/spending_pattern_edit_controller.dart';
import 'package:app/src/feature/spending_pattern/widgets/plan_amount_field.dart';
import 'package:app/src/feature/spending_pattern/widgets/plan_sheets.dart';
import 'package:app/src/feature/spending_pattern/widgets/spending_pattern_labels.dart';
import 'package:app/src/feature/spending_pattern/widgets/spending_pattern_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// Edits the plan for next month. The screen opens with the month the edit
/// takes effect in, and every path out of it says the same.
class SpendingPatternEditView extends StatefulWidget {
  const SpendingPatternEditView({super.key});

  @override
  State<SpendingPatternEditView> createState() =>
      _SpendingPatternEditViewState();
}

class _SpendingPatternEditViewState extends State<SpendingPatternEditView>
    with AdaptivePage {
  final SpendingPatternEditController _controller =
      Get.find<SpendingPatternEditController>();

  @override
  Widget build(BuildContext context) => adaptiveBody(context);

  @override
  Widget mobilePortraitBody(BuildContext context, Size size) =>
      _buildScreen(context, size);

  @override
  Widget mobileLandscapeBody(BuildContext context, Size size) =>
      _buildScreen(context, size);

  @override
  Widget tabletPortraitBody(BuildContext context, Size size) =>
      _buildScreen(context, size);

  @override
  Widget tabletLandscapeBody(BuildContext context, Size size) =>
      _buildScreen(context, size);

  Widget _buildScreen(BuildContext context, Size size) {
    return Obx(() {
      final t = SpendingPatternTokens.of(context);
      final l10n = AppLocalizations.of(context)!;
      final status = _controller.status.value;
      final draft = _controller.draft.value;
      final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
      final gutter = (size.width - 600) / 2 > 20.w
          ? (size.width - 600) / 2
          : 20.w;
      final canLeave = !_controller.hasChanges || _controller.isSaved;

      final Widget body;
      if (status == SpendingPatternLoadStatus.loading) {
        body = Center(child: CircularProgressIndicator(color: t.accent));
      } else if (status == SpendingPatternLoadStatus.failed || draft == null) {
        body = Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                l10n.spendingPatternLoadFailed,
                style: t.text(14.5, weight: FontWeight.w600),
              ),
              TextButton(
                onPressed: _controller.load,
                child: Text(
                  l10n.spendingPatternRetry,
                  style: t.text(14, weight: FontWeight.w600, color: t.link),
                ),
              ),
            ],
          ),
        );
      } else {
        body = _buildForm(context, t, l10n, draft, gutter);
      }

      return PopScope(
        canPop: canLeave,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _confirmLeave();
        },
        child: Scaffold(
          backgroundColor: t.page,
          appBar: AppBar(
            backgroundColor: t.page,
            surfaceTintColor: AppColors.transparentColor,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: t.primaryText),
            title: Text(
              l10n.spendingPatternEditTitle,
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: t.primaryText,
              ),
            ),
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            behavior: HitTestBehavior.translucent,
            child: body,
          ),
          // Steps aside while the keyboard is up so it never covers the
          // field being typed in.
          bottomNavigationBar:
              draft == null ||
                  status != SpendingPatternLoadStatus.ready ||
                  keyboardOpen
              ? null
              : _SaveBar(
                  tokens: t,
                  draft: draft,
                  issue: _controller.hasChanges
                      ? (_controller.budgetIssue ??
                            _controller.fixedIssue ??
                            _controller.allocationIssue)
                      : null,
                  canSave: _controller.canReview,
                  nextMonth: SpendingPatternLabels.month(
                    context,
                    _controller.nextMonth,
                  ),
                  currentMonth: SpendingPatternLabels.month(
                    context,
                    _controller.currentMonth,
                  ),
                  gutter: gutter,
                  onSave: _openReview,
                ),
        ),
      );
    });
  }

  Widget _buildForm(
    BuildContext context,
    SpendingPatternTokens t,
    AppLocalizations l10n,
    SpendingPattern draft,
    double gutter,
  ) {
    final budgetIssue = SpendingPatternLabels.issue(
      l10n,
      _controller.budgetIssue,
      draft,
    );
    final fixedIssue = SpendingPatternLabels.issue(
      l10n,
      _controller.fixedIssue,
      draft,
    );
    final allocationIssue = SpendingPatternLabels.issue(
      l10n,
      _controller.allocationIssue,
      draft,
    );
    final isGuidance =
        _controller.allocationIssue ==
        SpendingPatternIssue.allocationUnderBudget;
    final allocatable = draft.allocatableBudget < 0
        ? 0.0
        : draft.allocatableBudget;

    return ListView(
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.fromLTRB(gutter, 4.h, gutter, 28.h),
      children: <Widget>[
        // The figure the whole screen is about.
        Text(
          l10n.spendingPatternSpendingBudget,
          style: t.text(13, weight: FontWeight.w600, color: t.secondaryText),
        ),
        SizedBox(height: 2.h),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text.rich(
            TextSpan(
              children: <InlineSpan>[
                TextSpan(
                  text: SpendingPatternLabels.amount(
                    draft.spendingBudget < 0 ? 0 : draft.spendingBudget,
                  ),
                  style: t.text(30, weight: FontWeight.w700, height: 1.15),
                ),
                TextSpan(
                  text: '  ${l10n.spendingPatternPerMonth}',
                  style: t.text(13, color: t.secondaryText),
                ),
              ],
            ),
          ),
        ),
        Text(
          l10n.spendingPatternSpendingBudgetHint,
          style: t.text(12, color: t.secondaryText),
        ),
        SizedBox(height: 18.h),
        _FieldLabel(tokens: t, text: l10n.setupIncomeFieldLabel),
        PlanAmountField(
          tokens: t,
          value: draft.monthlyIncome,
          semanticLabel: l10n.setupIncomeFieldLabel,
          hasError:
              _controller.budgetIssue == SpendingPatternIssue.incomeNotPositive,
          onChanged: _controller.setIncome,
        ),
        SizedBox(height: 14.h),
        _FieldLabel(tokens: t, text: l10n.setupSavingFieldLabel),
        PlanAmountField(
          tokens: t,
          value: draft.monthlySavingGoal,
          semanticLabel: l10n.setupSavingFieldLabel,
          hasError:
              _controller.budgetIssue ==
              SpendingPatternIssue.savingGoalNotBelowIncome,
          onChanged: _controller.setSavingGoal,
        ),
        if (budgetIssue != null) _InlineMessage(tokens: t, text: budgetIssue),

        // --- Fixed costs ---
        _SectionTitle(
          tokens: t,
          text: l10n.setupLedgerFixed,
          trailing: SpendingPatternLabels.amount(draft.totalFixedExpenses),
        ),
        for (final item in draft.fixedExpenses)
          _TappableRow(
            tokens: t,
            icon: Icons.receipt_long_outlined,
            label: item.name,
            amount: item.amount,
            onTap: () => _editFixed(item),
          ),
        _AddRow(tokens: t, label: l10n.setupFixedAdd, onTap: _addFixed),
        if (fixedIssue != null) _InlineMessage(tokens: t, text: fixedIssue),

        // --- Categories ---
        _SectionTitle(
          tokens: t,
          text: l10n.spendingPatternAllocationSection,
          action: l10n.spendingPatternAutoSplit,
          onAction: draft.allocatableBudget > 0
              ? () {
                  FocusScope.of(context).unfocus();
                  _controller.splitAutomatically();
                }
              : null,
        ),
        Text(
          l10n.spendingPatternAllocationHint(
            SpendingPatternLabels.amount(allocatable),
          ),
          style: t.text(12.5, color: t.secondaryText),
        ),
        SizedBox(height: 4.h),
        for (final category in SetupCategory.values)
          _AmountRow(
            tokens: t,
            emoji: SetupLabels.categoryEmoji(category),
            label: SetupLabels.category(l10n, category),
            field: PlanAmountField(
              tokens: t,
              compact: true,
              value: draft.amountFor(category),
              semanticLabel: SetupLabels.category(l10n, category),
              onChanged: (value) =>
                  _controller.setCategoryAmount(category, value),
            ),
          ),
        for (final category in draft.customCategories)
          _AmountRow(
            tokens: t,
            emoji: category.iconKey,
            label: category.name,
            onLabelTap: () => _editCustom(category),
            field: PlanAmountField(
              tokens: t,
              compact: true,
              value: category.amount,
              semanticLabel: category.name,
              onChanged: (value) =>
                  _controller.updateCustomCategory(category.id, amount: value),
            ),
          ),
        _AddRow(
          tokens: t,
          label: l10n.setupCustomCategoryAdd,
          onTap: _addCustom,
        ),
        SizedBox(height: 6.h),
        Text(
          l10n.spendingPatternAllocated(
            SpendingPatternLabels.amount(draft.allocatedTotal),
            SpendingPatternLabels.amount(allocatable),
          ),
          style: t.text(12.5, weight: FontWeight.w600),
        ),
        if (allocationIssue != null)
          _InlineMessage(
            tokens: t,
            text: allocationIssue,
            color: isGuidance ? t.guidance : null,
            icon: isGuidance ? Icons.pie_chart_outline_rounded : null,
          ),
      ],
    );
  }

  // --- Sheets --------------------------------------------------------------

  Future<void> _addFixed() async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showPlanEntrySheet(
      context,
      tokens: SpendingPatternTokens.of(context),
      title: l10n.setupFixedAdd,
      nameLabel: l10n.setupFixedNameLabel,
      nameHint: l10n.setupFixedNameHint,
      amountLabel: l10n.amount,
    );
    if (result == null || result.remove) return;
    _controller.addFixedExpense(result.name, result.amount);
  }

  Future<void> _editFixed(FixedExpense item) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showPlanEntrySheet(
      context,
      tokens: SpendingPatternTokens.of(context),
      title: l10n.setupFixedEditTitle,
      nameLabel: l10n.setupFixedNameLabel,
      nameHint: l10n.setupFixedNameHint,
      amountLabel: l10n.amount,
      initialName: item.name,
      initialAmount: item.amount,
      removeLabel: l10n.spendingPatternRemoveFixed,
    );
    if (result == null) return;
    if (result.remove) {
      _controller.removeFixedExpense(item.id);
    } else {
      _controller.updateFixedExpense(item.id, result.name, result.amount);
    }
  }

  Future<void> _addCustom() async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showPlanEntrySheet(
      context,
      tokens: SpendingPatternTokens.of(context),
      title: l10n.setupCustomCategoryAdd,
      nameLabel: l10n.setupCustomCategoryNameLabel,
      nameHint: l10n.setupCustomCategoryNameHint,
      amountLabel: l10n.setupCustomCategoryAmountLabel,
      iconKey: SetupCategoryIcons.defaultKey,
      iconLabel: l10n.setupCustomCategoryIconLabel,
    );
    if (result == null || result.remove) return;
    _controller.addCustomCategory(
      result.name,
      result.iconKey ?? SetupCategoryIcons.defaultKey,
      result.amount,
    );
  }

  Future<void> _editCustom(CustomCategory category) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showPlanEntrySheet(
      context,
      tokens: SpendingPatternTokens.of(context),
      title: l10n.setupCustomCategoryEditTitle,
      nameLabel: l10n.setupCustomCategoryNameLabel,
      nameHint: l10n.setupCustomCategoryNameHint,
      amountLabel: l10n.setupCustomCategoryAmountLabel,
      initialName: category.name,
      initialAmount: category.amount,
      iconKey: category.iconKey,
      iconLabel: l10n.setupCustomCategoryIconLabel,
      removeLabel: l10n.spendingPatternRemoveCategory,
    );
    if (result == null) return;
    if (result.remove) {
      _controller.removeCustomCategory(category.id);
    } else {
      _controller.updateCustomCategory(
        category.id,
        name: result.name,
        iconKey: result.iconKey,
        amount: result.amount,
      );
    }
  }

  Future<void> _openReview() async {
    final draft = _controller.draft.value;
    if (draft == null || !_controller.canReview) return;
    FocusScope.of(context).unfocus();
    final l10n = AppLocalizations.of(context)!;
    final t = SpendingPatternTokens.of(context);
    final nextMonth = SpendingPatternLabels.month(
      context,
      _controller.nextMonth,
    );
    SpendingPatternSaveOutcome? outcome;
    final saved = await showPlanReviewSheet(
      context,
      tokens: t,
      currentMonth: SpendingPatternLabels.month(
        context,
        _controller.currentMonth,
      ),
      nextMonth: nextMonth,
      changes: SpendingPatternLabels.changes(
        l10n,
        _controller.currentPlan,
        draft,
      ),
      onConfirm: () async {
        outcome = await _controller.save();
        return outcome != null;
      },
    );
    if (!saved || !mounted) return;
    // The app-wide messenger keeps the message on screen after this route
    // closes, so the confirmation lands where the user returns to.
    final messenger = ScaffoldMessenger.of(context);
    Get.back(result: outcome);
    messenger
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(
            outcome == SpendingPatternSaveOutcome.scheduled
                ? l10n.spendingPatternSaved(nextMonth)
                : l10n.spendingPatternReverted(nextMonth),
            style: GoogleFonts.poppins(fontSize: 13.sp, color: Colors.white),
          ),
          duration: const Duration(seconds: 4),
          backgroundColor: t.isDark
              ? AppColors.profileDarkSurface
              : AppColors.colorMenuBar,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      );
  }

  Future<void> _confirmLeave() async {
    final l10n = AppLocalizations.of(context)!;
    final leave = await showPlanConfirmSheet(
      context,
      tokens: SpendingPatternTokens.of(context),
      title: l10n.spendingPatternDiscardTitle,
      body: l10n.spendingPatternDiscardBody,
      confirmLabel: l10n.spendingPatternDiscard,
      cancelLabel: l10n.spendingPatternKeepEditing,
      destructive: true,
    );
    if (!leave || !mounted) return;
    _controller.isSaved = true; // nothing left to protect
    Get.back();
  }
}

// --- Building blocks --------------------------------------------------------

/// A section heading separated from the one above by a hairline, instead of
/// wrapping every group in its own card.
class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.tokens,
    required this.text,
    this.trailing,
    this.action,
    this.onAction,
  });

  final SpendingPatternTokens tokens;
  final String text;
  final String? trailing;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final t = tokens;
    return Padding(
      padding: EdgeInsets.only(top: 22.h, bottom: 6.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Divider(height: 1, thickness: 0.6, color: t.border),
          SizedBox(height: 16.h),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(text, style: t.text(15.5, weight: FontWeight.w700)),
              ),
              if (trailing != null)
                Text(
                  trailing!,
                  style: t.text(
                    13.5,
                    weight: FontWeight.w700,
                    color: t.secondaryText,
                  ),
                ),
              if (action != null)
                TextButton(
                  onPressed: onAction,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    minimumSize: Size(0, 36.h),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    action!,
                    style: t.text(
                      13,
                      weight: FontWeight.w600,
                      color: onAction == null ? t.actionDisabledLabel : t.link,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.tokens, required this.text});

  final SpendingPatternTokens tokens;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: tokens.text(
          12.5,
          weight: FontWeight.w600,
          color: tokens.secondaryText,
        ),
      ),
    );
  }
}

class _InlineMessage extends StatelessWidget {
  const _InlineMessage({
    required this.tokens,
    required this.text,
    this.color,
    this.icon,
  });

  final SpendingPatternTokens tokens;
  final String text;

  /// Defaults to the error colour; budget still waiting to be split passes
  /// the guidance colour instead.
  final Color? color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final tone = color ?? tokens.danger;
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon ?? Icons.error_outline_rounded, size: 15.sp, color: tone),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              text,
              style: tokens.text(12.5, color: tone, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

/// A category with its amount field on the right. Long names wrap to two
/// lines before the field gives up any width.
class _AmountRow extends StatelessWidget {
  const _AmountRow({
    required this.tokens,
    required this.emoji,
    required this.label,
    required this.field,
    this.onLabelTap,
  });

  final SpendingPatternTokens tokens;
  final String emoji;
  final String label;
  final Widget field;
  final VoidCallback? onLabelTap;

  @override
  Widget build(BuildContext context) {
    final t = tokens;
    final name = Row(
      children: <Widget>[
        Container(
          width: 34.r,
          height: 34.r,
          decoration: BoxDecoration(
            color: t.accentSoft,
            borderRadius: BorderRadius.circular(11.r),
          ),
          alignment: Alignment.center,
          child: CategoryEmoji(emoji, size: 17),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: t.text(13.5, weight: FontWeight.w600),
          ),
        ),
        if (onLabelTap != null)
          Icon(Icons.more_horiz_rounded, size: 18.sp, color: t.secondaryText),
      ],
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: <Widget>[
          Expanded(
            child: onLabelTap == null
                ? name
                : InkWell(
                    onTap: onLabelTap,
                    borderRadius: BorderRadius.circular(12.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: name,
                    ),
                  ),
          ),
          SizedBox(width: 10.w),
          SizedBox(width: 150.w, child: field),
        ],
      ),
    );
  }
}

class _TappableRow extends StatelessWidget {
  const _TappableRow({
    required this.tokens,
    required this.icon,
    required this.label,
    required this.amount,
    required this.onTap,
  });

  final SpendingPatternTokens tokens;
  final IconData icon;
  final String label;
  final double amount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = tokens;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 11.h),
        child: Row(
          children: <Widget>[
            Icon(icon, size: 18.sp, color: t.accent),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: t.text(13.5, weight: FontWeight.w600),
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              SpendingPatternLabels.amount(amount),
              style: t.text(13.5, weight: FontWeight.w700),
            ),
            SizedBox(width: 4.w),
            Icon(
              Icons.chevron_right_rounded,
              size: 18.sp,
              color: t.secondaryText,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddRow extends StatelessWidget {
  const _AddRow({
    required this.tokens,
    required this.label,
    required this.onTap,
  });

  final SpendingPatternTokens tokens;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = tokens;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.add_circle_outline_rounded,
              size: 18.sp,
              color: t.accent,
            ),
            SizedBox(width: 10.w),
            Text(
              label,
              style: t.text(13.5, weight: FontWeight.w600, color: t.accent),
            ),
          ],
        ),
      ),
    );
  }
}

/// The save action, with the one line that matters above it: which month
/// the change starts in, and that this month stays as it is.
class _SaveBar extends StatelessWidget {
  const _SaveBar({
    required this.tokens,
    required this.draft,
    required this.issue,
    required this.canSave,
    required this.nextMonth,
    required this.currentMonth,
    required this.gutter,
    required this.onSave,
  });

  final SpendingPatternTokens tokens;
  final SpendingPattern draft;
  final SpendingPatternIssue? issue;
  final bool canSave;
  final String nextMonth;
  final String currentMonth;
  final double gutter;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final t = tokens;
    final l10n = AppLocalizations.of(context)!;
    final message = SpendingPatternLabels.issue(l10n, issue, draft);
    final isGuidance = issue == SpendingPatternIssue.allocationUnderBudget;

    return Container(
      padding: EdgeInsets.fromLTRB(
        gutter,
        12.h,
        gutter,
        MediaQuery.of(context).padding.bottom + 12.h,
      ),
      decoration: BoxDecoration(
        color: t.page,
        border: Border(
          top: BorderSide(color: t.border, width: 1.w),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (message != null) ...<Widget>[
            Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: t.text(
                12.5,
                weight: FontWeight.w600,
                color: isGuidance ? t.guidance : t.danger,
                height: 1.35,
              ),
            ),
            SizedBox(height: 6.h),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 1.h),
                child: Icon(
                  Icons.info_outline_rounded,
                  size: 15.sp,
                  color: t.secondaryText,
                ),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  l10n.spendingPatternApplyNote(nextMonth, currentMonth),
                  style: t.text(12.5, color: t.secondaryText, height: 1.35),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          ElevatedButton(
            onPressed: canSave ? onSave : null,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: t.action,
              disabledBackgroundColor: t.actionDisabled,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: Text(
              l10n.spendingPatternSaveChanges,
              style: t.text(
                15,
                weight: FontWeight.w600,
                color: canSave ? Colors.white : t.actionDisabledLabel,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
