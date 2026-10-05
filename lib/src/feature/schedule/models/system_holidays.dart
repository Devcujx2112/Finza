import 'package:app/src/core/color/app_colors.dart';
import 'package:app/src/feature/schedule/models/day_event_model.dart';

/// Public holidays and shared observances shown to every user.
///
/// Solar dates repeat every year. Lunar dates (Tết, Giỗ Tổ, Trung Thu) move,
/// so they come from a table of converted dates until the backend serves
/// the holiday calendar; years outside the table simply show no lunar
/// holiday rather than a wrong one.
class SystemHolidays {
  const SystemHolidays._();

  static const List<_SolarHoliday> _solar = [
    _SolarHoliday('new-year', 'Tết Dương lịch', 1, 1),
    _SolarHoliday('womens-day', 'Quốc tế Phụ nữ', 3, 8),
    _SolarHoliday('reunification', 'Ngày Giải phóng miền Nam', 4, 30),
    _SolarHoliday('labour', 'Quốc tế Lao động', 5, 1),
    _SolarHoliday('children', 'Quốc tế Thiếu nhi', 6, 1),
    _SolarHoliday('national', 'Quốc khánh', 9, 2),
    _SolarHoliday('vn-womens-day', 'Ngày Phụ nữ Việt Nam', 10, 20),
    _SolarHoliday('teachers', 'Ngày Nhà giáo Việt Nam', 11, 20),
    _SolarHoliday('christmas', 'Lễ Giáng sinh', 12, 25),
  ];

  /// Lunar holidays converted to solar dates, keyed by year.
  static final Map<int, List<_LunarHoliday>> _lunar = {
    2025: [
      _LunarHoliday('lunar-new-year', 'Tết Nguyên Đán', DateTime(2025, 1, 29)),
      _LunarHoliday('hung-kings', 'Giỗ Tổ Hùng Vương', DateTime(2025, 4, 7)),
      _LunarHoliday('mid-autumn', 'Tết Trung Thu', DateTime(2025, 10, 6)),
    ],
    2026: [
      _LunarHoliday('lunar-new-year', 'Tết Nguyên Đán', DateTime(2026, 2, 17)),
      _LunarHoliday('hung-kings', 'Giỗ Tổ Hùng Vương', DateTime(2026, 4, 26)),
      _LunarHoliday('mid-autumn', 'Tết Trung Thu', DateTime(2026, 9, 25)),
    ],
    2027: [
      _LunarHoliday('lunar-new-year', 'Tết Nguyên Đán', DateTime(2027, 2, 6)),
      _LunarHoliday('hung-kings', 'Giỗ Tổ Hùng Vương', DateTime(2027, 4, 16)),
      _LunarHoliday('mid-autumn', 'Tết Trung Thu', DateTime(2027, 9, 15)),
    ],
    2028: [
      _LunarHoliday('lunar-new-year', 'Tết Nguyên Đán', DateTime(2028, 1, 26)),
      _LunarHoliday('hung-kings', 'Giỗ Tổ Hùng Vương', DateTime(2028, 4, 4)),
      _LunarHoliday('mid-autumn', 'Tết Trung Thu', DateTime(2028, 10, 3)),
    ],
  };

  /// Every system event that falls in the given month.
  static List<DayEventModel> forMonth(int year, int month) {
    final events = <DayEventModel>[
      for (final holiday in _solar)
        if (holiday.month == month)
          _event(holiday.id, holiday.title, DateTime(year, month, holiday.day)),
      for (final holiday in _lunar[year] ?? const <_LunarHoliday>[])
        if (holiday.date.month == month)
          _event(holiday.id, holiday.title, holiday.date),
    ];
    events.sort((a, b) => a.date.compareTo(b.date));
    return events;
  }

  static DayEventModel _event(String id, String title, DateTime date) {
    return DayEventModel(
      id: 'system-$id-${date.year}',
      title: title,
      date: date,
      type: DayEventType.holiday,
      source: DayEventSource.system,
      colorValue: AppColors.scheduleHoliday.toARGB32(),
      iconKey: DayEventIcons.holidayKey,
    );
  }
}

class _SolarHoliday {
  final String id;
  final String title;
  final int month;
  final int day;

  const _SolarHoliday(this.id, this.title, this.month, this.day);
}

class _LunarHoliday {
  final String id;
  final String title;
  final DateTime date;

  const _LunarHoliday(this.id, this.title, this.date);
}
