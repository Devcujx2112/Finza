import 'package:app/l10n/app_localizations.dart';
import 'package:app/src/feature/schedule/models/day_event_model.dart';
import 'package:app/src/feature/schedule/schedule_controller.dart';
import 'package:app/src/feature/schedule/widgets/schedule_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

/// Month grid that shows what each day holds without tapping it:
///
/// * public holiday: red number on a soft red disc
/// * user day event: one dot per event, in the color the user picked
/// * timed activities: a short neutral bar after the dots
///
/// Dots and bars sit under the day disc, so the selected and today states
/// never hide them.
class ScheduleCalendar extends StatelessWidget {
  final ScheduleTokens tokens;
  final DateTime month;
  final DateTime selectedDate;
  final Map<int, DayMarkers> markers;
  final ValueChanged<DateTime> onSelectDate;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  /// Cap on event dots per cell so a busy day stays a clean row.
  static const int _maxEventDots = 3;

  const ScheduleCalendar({
    super.key,
    required this.tokens,
    required this.month,
    required this.selectedDate,
    required this.markers,
    required this.onSelectDate,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: tokens.border, width: 1.w),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMonthHeader(context),
          SizedBox(height: 14.h),
          _buildWeekdayRow(context),
          SizedBox(height: 4.h),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragEnd: (details) {
              final velocity = details.primaryVelocity ?? 0;
              if (velocity > 250) onPreviousMonth();
              if (velocity < -250) onNextMonth();
            },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: KeyedSubtree(
                key: ValueKey('${month.year}-${month.month}'),
                child: _buildGrid(),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Divider(height: 1, thickness: 1.w, color: tokens.border),
          SizedBox(height: 12.h),
          _buildLegend(context),
        ],
      ),
    );
  }

  Widget _buildMonthHeader(BuildContext context) {
    final appLocal = AppLocalizations.of(context);
    final monthYear = DateFormat('MM, yyyy').format(month);

    return Row(
      children: [
        Expanded(
          child: Text(
            appLocal?.monthFormatLabel(monthYear) ?? 'Tháng $monthYear',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: tokens.text(15.5, weight: FontWeight.w700),
          ),
        ),
        SizedBox(width: 8.w),
        _buildNavButton(Icons.chevron_left_rounded, onPreviousMonth),
        SizedBox(width: 6.w),
        _buildNavButton(Icons.chevron_right_rounded, onNextMonth),
      ],
    );
  }

  Widget _buildNavButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 34.r,
        width: 34.r,
        decoration: BoxDecoration(
          color: tokens.softSurface,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(icon, color: tokens.primaryText, size: 20.sp),
      ),
    );
  }

  Widget _buildWeekdayRow(BuildContext context) {
    final labels =
        (AppLocalizations.of(context)?.scheduleWeekdayShort ??
                'T2,T3,T4,T5,T6,T7,CN')
            .split(',');

    return Row(
      children: [
        for (final label in labels)
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: tokens.text(
                11,
                weight: FontWeight.w600,
                color: tokens.secondaryText,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildGrid() {
    final firstDay = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leadingBlanks = firstDay.weekday - 1;
    final weekCount = ((leadingBlanks + daysInMonth) / 7).ceil();

    return Column(
      children: List.generate(weekCount, (week) {
        return Row(
          children: List.generate(7, (weekday) {
            final dayNumber = week * 7 + weekday - leadingBlanks + 1;
            if (dayNumber < 1 || dayNumber > daysInMonth) {
              return const Expanded(child: SizedBox.shrink());
            }
            return Expanded(
              child: _buildDayCell(
                DateTime(month.year, month.month, dayNumber),
                markers[dayNumber] ?? DayMarkers.empty,
              ),
            );
          }),
        );
      }),
    );
  }

  Widget _buildDayCell(DateTime date, DayMarkers marker) {
    final isSelected = _isSameDay(date, selectedDate);
    final isToday = _isSameDay(date, DateTime.now());

    final Color fill;
    final Color numberColor;
    if (isSelected) {
      fill = tokens.action;
      numberColor = Colors.white;
    } else if (marker.hasHoliday) {
      fill = tokens.holidaySoft;
      numberColor = tokens.holiday;
    } else {
      fill = Colors.transparent;
      numberColor = isToday ? tokens.accent : tokens.primaryText;
    }

    final emphasised = isSelected || isToday || marker.hasHoliday;

    return GestureDetector(
      onTap: () => onSelectDate(date),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 48.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              width: 32.r,
              height: 32.r,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: fill,
                shape: BoxShape.circle,
                border: isToday && !isSelected
                    ? Border.all(color: tokens.accent, width: 1.5.w)
                    : null,
              ),
              child: Text(
                '${date.day}',
                style: tokens.text(
                  13,
                  weight: emphasised ? FontWeight.w700 : FontWeight.w500,
                  color: numberColor,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            SizedBox(height: 5.r, child: _buildMarks(marker)),
          ],
        ),
      ),
    );
  }

  Widget _buildMarks(DayMarkers marker) {
    final marks = <Widget>[
      for (final color in marker.eventColors.take(_maxEventDots))
        _dot(DayEventPalette.tone(color, tokens.isDark)),
      if (marker.hasSchedule) _scheduleBar(),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < marks.length; i++) ...[
          if (i > 0) SizedBox(width: 2.5.r),
          marks[i],
        ],
      ],
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 5.r,
      height: 5.r,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _scheduleBar() {
    return Container(
      width: 9.r,
      height: 3.r,
      decoration: BoxDecoration(
        color: tokens.secondaryText,
        borderRadius: BorderRadius.circular(999.r),
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    final appLocal = AppLocalizations.of(context);

    return Wrap(
      spacing: 14.w,
      runSpacing: 8.h,
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _legendItem(
          Container(
            width: 16.r,
            height: 16.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: tokens.holidaySoft,
              shape: BoxShape.circle,
            ),
            child: Text(
              '1',
              style: tokens.text(
                8.5,
                weight: FontWeight.w700,
                color: tokens.holiday,
                height: 1,
              ),
            ),
          ),
          appLocal?.scheduleLegendHoliday ?? 'Ngày lễ',
        ),
        _legendItem(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dot(
                DayEventPalette.tone(
                  DayEventPalette.swatches[0],
                  tokens.isDark,
                ),
              ),
              SizedBox(width: 2.5.r),
              _dot(
                DayEventPalette.tone(
                  DayEventPalette.swatches[1],
                  tokens.isDark,
                ),
              ),
              SizedBox(width: 2.5.r),
              _dot(
                DayEventPalette.tone(
                  DayEventPalette.swatches[5],
                  tokens.isDark,
                ),
              ),
            ],
          ),
          appLocal?.scheduleLegendUserEvent ?? 'Sự kiện của bạn',
        ),
        _legendItem(
          _scheduleBar(),
          appLocal?.scheduleLegendDaily ?? 'Có lịch trong ngày',
        ),
      ],
    );
  }

  Widget _legendItem(Widget sample, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        sample,
        SizedBox(width: 6.w),
        Text(label, style: tokens.text(11, color: tokens.secondaryText)),
      ],
    );
  }

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
