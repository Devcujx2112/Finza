import 'package:app/l10n/app_localizations.dart';
import 'package:app/domain/entities/onboarding_setup/cycle_day.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_controls.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_labels.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_palette.dart';
import 'package:app/src/feature/onboarding_setup/widgets/setup_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Picks the day a cycle starts on. Shared by the reporting cycle question
/// of the analysis flow and the income day question of the budget flow,
/// which differ only in their copy and their shortlist of days.
class CycleDayStep extends StatelessWidget {
  const CycleDayStep({
    super.key,
    required this.title,
    required this.description,
    required this.presetDays,
    required this.selected,
    required this.isCustomOpen,
    required this.onSelectPreset,
    required this.onSelectLastDay,
    required this.onOpenCustom,
    required this.onSelectCustomDay,
    required this.palette,
  });

  final String title;
  final String description;
  final List<int> presetDays;
  final CycleDay? selected;
  final bool isCustomOpen;
  final ValueChanged<int> onSelectPreset;
  final VoidCallback onSelectLastDay;
  final VoidCallback onOpenCustom;
  final ValueChanged<int> onSelectCustomDay;
  final SetupPalette palette;

  bool _isPresetSelected(int day) =>
      !isCustomOpen && selected == CycleDay.onDay(day);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SetupStepHeader(
          title: title,
          description: description,
          palette: palette,
        ),
        SizedBox(height: 32.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: <Widget>[
            for (final day in presetDays)
              SetupChoiceChip(
                palette: palette,
                label: SetupLabels.dayNumber(l10n, day),
                isSelected: _isPresetSelected(day),
                onTap: () => onSelectPreset(day),
              ),
            SetupChoiceChip(
              palette: palette,
              label: l10n.setupLastDayOfMonth,
              isSelected:
                  !isCustomOpen && selected == const CycleDay.lastDayOfMonth(),
              onTap: onSelectLastDay,
            ),
            SetupChoiceChip(
              palette: palette,
              label: l10n.setupCustomDay,
              isSelected: isCustomOpen,
              onTap: onOpenCustom,
            ),
          ],
        ),
        AnimatedSize(
          duration: SetupMotion.resolve(context, SetupMotion.reveal),
          curve: SetupMotion.curve,
          alignment: Alignment.topCenter,
          child: isCustomOpen
              ? Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: _CustomDayGrid(
                    palette: palette,
                    selectedDay: selected != null && !selected!.isLastDayOfMonth
                        ? selected!.day
                        : null,
                    onSelect: onSelectCustomDay,
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}

class _CustomDayGrid extends StatelessWidget {
  const _CustomDayGrid({
    required this.palette,
    required this.selectedDay,
    required this.onSelect,
  });

  final SetupPalette palette;
  final int? selectedDay;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // No container around the grid: the day cells are controls in their own
    // right, so a card here would only add another box to the page.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: 31,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 8.h,
            crossAxisSpacing: 8.w,
          ),
          itemBuilder: (context, index) {
            final day = index + 1;
            final isSelected = selectedDay == day;
            return Semantics(
              button: true,
              selected: isSelected,
              label: SetupLabels.dayNumber(l10n, day),
              child: SetupPressable(
                onTap: () => onSelect(day),
                scale: 0.9,
                child: AnimatedContainer(
                  duration: SetupMotion.resolve(context, SetupMotion.selection),
                  curve: SetupMotion.curve,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? palette.accentSoft
                        : palette.fieldSurface,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isSelected ? palette.accent : palette.border,
                      width: isSelected ? 1.5.w : 1.w,
                    ),
                  ),
                  child: Text(
                    '$day',
                    style: SetupText.optionTitle(palette).copyWith(
                      fontSize: 13.sp,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(height: 14.h),
        Text(l10n.setupCustomDayHint, style: SetupText.optionBody(palette)),
      ],
    );
  }
}
