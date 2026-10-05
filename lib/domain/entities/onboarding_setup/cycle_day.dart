import 'package:flutter/foundation.dart';

/// The day of the month a budget or reporting cycle starts on.
///
/// `lastDayOfMonth` resolves to 28, 29, 30 or 31 depending on the month it is
/// asked about, so a cycle pinned to the end of the month stays correct in
/// February.
@immutable
class CycleDay {
  const CycleDay.onDay(this.day) : isLastDayOfMonth = false;

  const CycleDay.lastDayOfMonth() : day = 0, isLastDayOfMonth = true;

  final int day;
  final bool isLastDayOfMonth;

  /// Resolves this cycle day inside the month of [reference], clamping a day
  /// like 31 down to the real last day of a shorter month.
  int resolveFor(DateTime reference) {
    final lastDay = DateTime(reference.year, reference.month + 1, 0).day;
    if (isLastDayOfMonth) return lastDay;
    return day.clamp(1, lastDay);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'day': day,
    'isLastDayOfMonth': isLastDayOfMonth,
  };

  static CycleDay fromJson(Map<String, dynamic> json) {
    if (json['isLastDayOfMonth'] == true) return const CycleDay.lastDayOfMonth();
    return CycleDay.onDay((json['day'] as num?)?.toInt() ?? 1);
  }

  @override
  bool operator ==(Object other) =>
      other is CycleDay &&
      other.day == day &&
      other.isLastDayOfMonth == isLastDayOfMonth;

  @override
  int get hashCode => Object.hash(day, isLastDayOfMonth);
}
