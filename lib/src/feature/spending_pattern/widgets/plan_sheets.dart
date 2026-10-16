import 'package:app/l10n/app_localizations.dart';
import 'package:app/src/feature/onboarding_setup/widgets/category_icons.dart';
import 'package:app/src/feature/spending_pattern/widgets/plan_amount_field.dart';
import 'package:app/src/feature/spending_pattern/widgets/spending_pattern_labels.dart';
import 'package:app/src/feature/spending_pattern/widgets/spending_pattern_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shared frame for every sheet in this feature: rounded top, drag handle,
/// lifted above the keyboard and the home indicator.
class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.tokens, required this.child});

  final SpendingPatternTokens tokens;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: Container(
        constraints: BoxConstraints(maxHeight: media.size.height * 0.88),
        padding: EdgeInsets.fromLTRB(
          20.w,
          10.h,
          20.w,
          media.padding.bottom + 18.h,
        ),
        decoration: BoxDecoration(
          color: tokens.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Container(
                width: 36.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: tokens.secondaryText.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Flexible(child: child),
          ],
        ),
      ),
    );
  }
}

/// Primary and secondary actions laid out side by side, as on the other
/// sheets in the app.
class PlanSheetActions extends StatelessWidget {
  const PlanSheetActions({
    super.key,
    required this.tokens,
    required this.cancelLabel,
    required this.confirmLabel,
    required this.onCancel,
    required this.onConfirm,
    this.destructive = false,
    this.busy = false,
  });

  final SpendingPatternTokens tokens;
  final String cancelLabel;
  final String confirmLabel;
  final VoidCallback onCancel;
  final VoidCallback? onConfirm;
  final bool destructive;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final t = tokens;
    final enabled = onConfirm != null && !busy;
    final fill = destructive ? t.danger : t.action;
    return Row(
      children: <Widget>[
        Expanded(
          child: OutlinedButton(
            onPressed: busy ? null : onCancel,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: t.fieldBorder, width: 1.w),
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            child: Text(
              cancelLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: t.text(14.5, weight: FontWeight.w600),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: ElevatedButton(
            onPressed: enabled ? onConfirm : null,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: fill,
              disabledBackgroundColor: busy ? fill : t.actionDisabled,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            child: busy
                ? SizedBox(
                    width: 20.r,
                    height: 20.r,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    confirmLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.text(
                      14.5,
                      weight: FontWeight.w600,
                      color: enabled ? Colors.white : t.actionDisabledLabel,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

// --- Confirmation ---------------------------------------------------------

/// Yes or no question. Returns true only when the user confirms.
Future<bool> showPlanConfirmSheet(
  BuildContext context, {
  required SpendingPatternTokens tokens,
  required String title,
  required String body,
  required String confirmLabel,
  required String cancelLabel,
  bool destructive = false,
}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => _SheetFrame(
      tokens: tokens,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: tokens.text(18, weight: FontWeight.w700)),
          SizedBox(height: 8.h),
          Text(
            body,
            style: tokens.text(
              13.5,
              weight: FontWeight.w400,
              color: tokens.secondaryText,
              height: 1.45,
            ),
          ),
          SizedBox(height: 22.h),
          PlanSheetActions(
            tokens: tokens,
            cancelLabel: cancelLabel,
            confirmLabel: confirmLabel,
            destructive: destructive,
            onCancel: () => Navigator.of(sheetContext).pop(false),
            onConfirm: () => Navigator.of(sheetContext).pop(true),
          ),
        ],
      ),
    ),
  );
  return result ?? false;
}

// --- Review ---------------------------------------------------------------

/// Shows what the edit changes compared with this month, says plainly which
/// month it starts in, and saves on confirm. Returns true once saved.
Future<bool> showPlanReviewSheet(
  BuildContext context, {
  required SpendingPatternTokens tokens,
  required String currentMonth,
  required String nextMonth,
  required List<PlanLineChange> changes,
  required Future<bool> Function() onConfirm,
}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _ReviewSheet(
      tokens: tokens,
      currentMonth: currentMonth,
      nextMonth: nextMonth,
      changes: changes,
      onConfirm: onConfirm,
    ),
  );
  return result ?? false;
}

class _ReviewSheet extends StatefulWidget {
  const _ReviewSheet({
    required this.tokens,
    required this.currentMonth,
    required this.nextMonth,
    required this.changes,
    required this.onConfirm,
  });

  final SpendingPatternTokens tokens;
  final String currentMonth;
  final String nextMonth;
  final List<PlanLineChange> changes;
  final Future<bool> Function() onConfirm;

  @override
  State<_ReviewSheet> createState() => _ReviewSheetState();
}

class _ReviewSheetState extends State<_ReviewSheet> {
  bool _busy = false;
  bool _failed = false;

  Future<void> _confirm() async {
    setState(() {
      _busy = true;
      _failed = false;
    });
    final saved = await widget.onConfirm();
    if (!mounted) return;
    if (saved) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _busy = false;
        _failed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.tokens;
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: !_busy,
      child: _SheetFrame(
        tokens: t,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              l10n.spendingPatternConfirmTitle,
              style: t.text(18, weight: FontWeight.w700),
            ),
            SizedBox(height: 8.h),
            Text(
              l10n.spendingPatternConfirmBody(
                widget.nextMonth,
                widget.currentMonth,
              ),
              style: t.text(
                13.5,
                weight: FontWeight.w400,
                color: t.secondaryText,
                height: 1.45,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              l10n.spendingPatternCompareTo(widget.currentMonth),
              style: t.sectionLabel(),
            ),
            SizedBox(height: 6.h),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: widget.changes.length,
                separatorBuilder: (_, _) =>
                    Divider(height: 1, thickness: 0.6, color: t.border),
                itemBuilder: (_, index) =>
                    _ChangeRow(tokens: t, change: widget.changes[index]),
              ),
            ),
            if (_failed) ...<Widget>[
              SizedBox(height: 10.h),
              Text(
                l10n.spendingPatternSaveFailed,
                style: t.text(12.5, color: t.danger),
              ),
            ],
            SizedBox(height: 18.h),
            PlanSheetActions(
              tokens: t,
              cancelLabel: l10n.cancel,
              confirmLabel: l10n.spendingPatternConfirm,
              busy: _busy,
              onCancel: () => Navigator.of(context).pop(false),
              onConfirm: _confirm,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChangeRow extends StatelessWidget {
  const _ChangeRow({required this.tokens, required this.change});

  final SpendingPatternTokens tokens;
  final PlanLineChange change;

  @override
  Widget build(BuildContext context) {
    final t = tokens;
    final l10n = AppLocalizations.of(context)!;
    final before = change.before;
    final after = change.after;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 11.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PlanLineGlyph(
            icon: change.icon,
            emoji: change.emoji,
            color: t.accent,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              change.label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: t.text(13.5, weight: FontWeight.w600),
            ),
          ),
          SizedBox(width: 10.w),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  after == null
                      ? l10n.spendingPatternRemoved
                      : SpendingPatternLabels.amount(after),
                  textAlign: TextAlign.end,
                  style: t.text(
                    13.5,
                    weight: FontWeight.w700,
                    color: after == null ? t.danger : t.primaryText,
                  ),
                ),
                Text(
                  before == null
                      ? l10n.spendingPatternAdded
                      : SpendingPatternLabels.amount(before),
                  textAlign: TextAlign.end,
                  style: t
                      .text(11.5, color: t.secondaryText)
                      .copyWith(
                        decoration: before == null
                            ? TextDecoration.none
                            : TextDecoration.lineThrough,
                        decorationColor: t.secondaryText,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Add or edit one entry -------------------------------------------------

/// What the entry sheet hands back.
class PlanEntryResult {
  const PlanEntryResult.save({
    required this.name,
    required this.amount,
    this.iconKey,
  }) : remove = false;

  const PlanEntryResult.remove()
    : name = '',
      amount = 0,
      iconKey = null,
      remove = true;

  final String name;
  final double amount;
  final String? iconKey;
  final bool remove;
}

/// Adds or edits a fixed expense, or a custom category when [iconKey] is
/// given. [removeLabel] adds a remove action for an existing entry.
Future<PlanEntryResult?> showPlanEntrySheet(
  BuildContext context, {
  required SpendingPatternTokens tokens,
  required String title,
  required String nameLabel,
  required String nameHint,
  required String amountLabel,
  String initialName = '',
  double initialAmount = 0,
  String? iconKey,
  String? iconLabel,
  String? removeLabel,
}) {
  return showModalBottomSheet<PlanEntryResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _EntrySheet(
      tokens: tokens,
      title: title,
      nameLabel: nameLabel,
      nameHint: nameHint,
      amountLabel: amountLabel,
      initialName: initialName,
      initialAmount: initialAmount,
      initialIconKey: iconKey,
      iconLabel: iconLabel,
      removeLabel: removeLabel,
    ),
  );
}

class _EntrySheet extends StatefulWidget {
  const _EntrySheet({
    required this.tokens,
    required this.title,
    required this.nameLabel,
    required this.nameHint,
    required this.amountLabel,
    required this.initialName,
    required this.initialAmount,
    required this.initialIconKey,
    required this.iconLabel,
    required this.removeLabel,
  });

  final SpendingPatternTokens tokens;
  final String title;
  final String nameLabel;
  final String nameHint;
  final String amountLabel;
  final String initialName;
  final double initialAmount;
  final String? initialIconKey;
  final String? iconLabel;
  final String? removeLabel;

  @override
  State<_EntrySheet> createState() => _EntrySheetState();
}

class _EntrySheetState extends State<_EntrySheet> {
  late final TextEditingController _nameController = TextEditingController(
    text: widget.initialName,
  );
  late double _amount = widget.initialAmount;
  late String? _iconKey = widget.initialIconKey;

  bool get _canSave => _nameController.text.trim().isNotEmpty && _amount > 0;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.tokens;
    final l10n = AppLocalizations.of(context)!;

    return _SheetFrame(
      tokens: t,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    widget.title,
                    style: t.text(18, weight: FontWeight.w700),
                  ),
                ),
                if (widget.removeLabel != null)
                  TextButton.icon(
                    onPressed: () => Navigator.of(
                      context,
                    ).pop(const PlanEntryResult.remove()),
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      size: 18.sp,
                      color: t.danger,
                    ),
                    label: Text(
                      widget.removeLabel!,
                      style: t.text(
                        13,
                        weight: FontWeight.w600,
                        color: t.danger,
                      ),
                    ),
                  ),
              ],
            ),
            if (_iconKey != null) ...<Widget>[
              SizedBox(height: 14.h),
              Text(widget.iconLabel ?? '', style: _labelStyle(t)),
              SizedBox(height: 8.h),
              CategoryEmojiPicker(
                style: CategoryEmojiPickerStyle(
                  fill: t.softSurface,
                  selectedFill: t.accentSoft,
                  border: t.fieldBorder,
                  selectedBorder: t.accent,
                  primaryText: t.primaryText,
                  secondaryText: t.secondaryText,
                  sheetBackground: t.surface,
                ),
                selected: _iconKey!,
                onSelected: (key) => setState(() => _iconKey = key),
              ),
            ],
            SizedBox(height: 16.h),
            Text(widget.nameLabel, style: _labelStyle(t)),
            SizedBox(height: 8.h),
            TextField(
              controller: _nameController,
              autofocus: widget.initialName.isEmpty,
              maxLength: 40,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              style: t.text(15, weight: FontWeight.w600),
              cursorColor: t.accent,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                counterText: '',
                isDense: true,
                filled: true,
                fillColor: t.softSurface,
                hintText: widget.nameHint,
                hintStyle: t.text(15, color: t.secondaryText),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 14.h,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide(color: t.fieldBorder, width: 1.w),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide(color: t.accent, width: 1.5.w),
                ),
              ),
            ),
            SizedBox(height: 14.h),
            Text(widget.amountLabel, style: _labelStyle(t)),
            SizedBox(height: 8.h),
            PlanAmountField(
              tokens: t,
              value: _amount,
              textInputAction: TextInputAction.done,
              onChanged: (value) => setState(() => _amount = value),
            ),
            SizedBox(height: 22.h),
            PlanSheetActions(
              tokens: t,
              cancelLabel: l10n.cancel,
              confirmLabel: l10n.save,
              onCancel: () => Navigator.of(context).pop(),
              onConfirm: _canSave
                  ? () => Navigator.of(context).pop(
                      PlanEntryResult.save(
                        name: _nameController.text.trim(),
                        amount: _amount,
                        iconKey: _iconKey,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _labelStyle(SpendingPatternTokens t) =>
      t.text(12.5, weight: FontWeight.w600, color: t.secondaryText);
}
