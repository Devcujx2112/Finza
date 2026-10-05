import 'package:app/l10n/app_localizations.dart';
import 'package:app/domain/entities/onboarding_setup/custom_category.dart';
import 'package:app/src/feature/onboarding_setup/widgets/category_icons.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_controls.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_currency.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_fields.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_palette.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Result of the add or edit sheet.
class CustomCategoryDraft {
  const CustomCategoryDraft({
    required this.name,
    required this.iconKey,
    required this.amount,
  });

  final String name;
  final String iconKey;
  final double amount;
}

/// Opens the sheet used to add or edit one custom category. Returns null
/// when the user dismisses it.
Future<CustomCategoryDraft?> showCustomCategorySheet(
  BuildContext context, {
  CustomCategory? existing,
}) {
  return showModalBottomSheet<CustomCategoryDraft>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => _CustomCategorySheet(existing: existing),
  );
}

class _CustomCategorySheet extends StatefulWidget {
  const _CustomCategorySheet({this.existing});

  final CustomCategory? existing;

  @override
  State<_CustomCategorySheet> createState() => _CustomCategorySheetState();
}

class _CustomCategorySheetState extends State<_CustomCategorySheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  late String _name;
  late String _iconKey;
  late double _amount;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _name = existing?.name ?? '';
    _iconKey = existing?.iconKey ?? SetupCategoryIcons.defaultKey;
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
    Navigator.of(context).pop(
      CustomCategoryDraft(
        name: _name.trim(),
        iconKey: _iconKey,
        amount: _amount,
      ),
    );
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
                      isEditing
                          ? l10n.setupCustomCategoryEditTitle
                          : l10n.setupCustomCategoryAdd,
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
              Text(
                l10n.setupCustomCategoryIconLabel,
                style: SetupText.fieldLabel(palette),
              ),
              SizedBox(height: 10.h),
              _IconGrid(
                palette: palette,
                selectedKey: _iconKey,
                onSelected: (key) => setState(() => _iconKey = key),
              ),
              SizedBox(height: 20.h),
              SetupTextField(
                controller: _nameController,
                palette: palette,
                label: l10n.setupCustomCategoryNameLabel,
                hintText: l10n.setupCustomCategoryNameHint,
                onChanged: (value) => setState(() => _name = value),
              ),
              SizedBox(height: 18.h),
              SetupAmountField(
                controller: _amountController,
                palette: palette,
                label: l10n.setupCustomCategoryAmountLabel,
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

class _IconGrid extends StatelessWidget {
  const _IconGrid({
    required this.palette,
    required this.selectedKey,
    required this.onSelected,
  });

  final SetupPalette palette;
  final String selectedKey;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 6,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10.h,
      crossAxisSpacing: 10.w,
      children: <Widget>[
        for (final entry in SetupCategoryIcons.catalog.entries)
          _IconOption(
            palette: palette,
            icon: entry.value,
            isSelected: entry.key == selectedKey,
            onTap: () => onSelected(entry.key),
          ),
      ],
    );
  }
}

class _IconOption extends StatelessWidget {
  const _IconOption({
    required this.palette,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final SetupPalette palette;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      child: SetupPressable(
        onTap: onTap,
        scale: 0.92,
        child: AnimatedContainer(
          duration: SetupMotion.resolve(context, SetupMotion.selection),
          curve: SetupMotion.curve,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? palette.accentSoft : palette.fieldSurface,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isSelected ? palette.accent : palette.border,
              width: isSelected ? 1.5.w : 1.w,
            ),
          ),
          child: Icon(
            icon,
            size: 20.sp,
            color: isSelected ? palette.accentStrong : palette.secondaryText,
          ),
        ),
      ),
    );
  }
}
