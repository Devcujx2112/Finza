import 'package:app/l10n/app_localizations.dart';
import 'package:app/domain/entities/onboarding_setup/fixed_expense.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_controls.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_currency.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_fields.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_palette.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Result of the add or edit sheet.
class FixedExpenseDraft {
  const FixedExpenseDraft({required this.name, required this.amount});

  final String name;
  final double amount;
}

/// Opens the sheet used to add or edit one fixed cost. Returns null when
/// the user dismisses it.
Future<FixedExpenseDraft?> showFixedExpenseSheet(
  BuildContext context, {
  FixedExpense? existing,
}) {
  return showModalBottomSheet<FixedExpenseDraft>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => _FixedExpenseSheet(existing: existing),
  );
}

class _FixedExpenseSheet extends StatefulWidget {
  const _FixedExpenseSheet({this.existing});

  final FixedExpense? existing;

  @override
  State<_FixedExpenseSheet> createState() => _FixedExpenseSheetState();
}

class _FixedExpenseSheetState extends State<_FixedExpenseSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  late String _name;
  late double _amount;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _name = existing?.name ?? '';
    _amount = existing?.amount ?? 0;
    _nameController = TextEditingController(text: _name);
    _amountController = TextEditingController(
      text: _amount > 0 ? SetupCurrency.formatPlain(_amount) : '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  bool get _canSave => _name.trim().isNotEmpty && _amount > 0;

  void _submit() {
    if (!_canSave) return;
    Navigator.of(
      context,
    ).pop(FixedExpenseDraft(name: _name.trim(), amount: _amount));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = SetupPalette.of(context);
    final isEditing = widget.existing != null;

    return Padding(
      // Keeps the fields and the save button clear of the keyboard.
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        decoration: BoxDecoration(
          color: palette.pageBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  width: 36.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: palette.border,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      isEditing ? l10n.setupFixedEditTitle : l10n.setupFixedAdd,
                      style: SetupText.sectionTitle(
                        palette,
                      ).copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700),
                    ),
                  ),
                  SetupPressable(
                    onTap: () => Navigator.of(context).pop(),
                    scale: 0.9,
                    child: Semantics(
                      button: true,
                      label: l10n.cancel,
                      child: Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Icon(
                          Icons.close_rounded,
                          size: 22.sp,
                          color: palette.secondaryText,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              SetupTextField(
                controller: _nameController,
                palette: palette,
                label: l10n.setupFixedNameLabel,
                hintText: l10n.setupFixedNameHint,
                autofocus: !isEditing,
                onChanged: (value) => setState(() => _name = value),
              ),
              SizedBox(height: 18.h),
              SetupAmountField(
                controller: _amountController,
                palette: palette,
                label: l10n.amount,
                isLarge: true,
                onChanged: (value) => setState(() => _amount = value),
              ),
              SizedBox(height: 24.h),
              SetupPrimaryButton(
                palette: palette,
                label: l10n.save,
                isEnabled: _canSave,
                onTap: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
