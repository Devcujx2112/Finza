import 'package:app/src/feature/schedule/models/day_event_model.dart';
import 'package:app/src/feature/schedule/models/schedule_item_model.dart';
import 'package:app/src/feature/schedule/models/system_holidays.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// What the calendar grid needs to draw one day cell.
class DayMarkers {
  final bool hasHoliday;
  final List<Color> eventColors;
  final bool hasSchedule;

  const DayMarkers({
    this.hasHoliday = false,
    this.eventColors = const [],
    this.hasSchedule = false,
  });

  static const empty = DayMarkers();
}

class ScheduleController extends GetxController {
  final Rx<DateTime> selectedMonth = DateTime(2026, 9, 1).obs;
  final Rx<DateTime> selectedDate = DateTime(2026, 9, 7).obs;

  final RxList<ScheduleItemModel> items = <ScheduleItemModel>[].obs;
  final RxList<DayEventModel> userEvents = <DayEventModel>[].obs;

  ScheduleItemModel? lastDeletedItem;
  int? lastDeletedIndex;
  DayEventModel? lastDeletedEvent;
  int? lastDeletedEventIndex;

  @override
  void onInit() {
    super.onInit();
    _loadInitialMockData();
    _loadInitialMockEvents();
  }

  void _loadInitialMockEvents() {
    userEvents.assignAll([
      DayEventModel(
        id: 'event-1',
        title: 'Sinh nhật mẹ',
        date: DateTime(1968, 9, 7),
        type: DayEventType.birthday,
        colorValue: DayEventPalette.swatches[0].toARGB32(),
        iconKey: 'cake',
        repeatsYearly: true,
        note: 'Đặt bánh và hoa từ hôm trước.',
      ),
      DayEventModel(
        id: 'event-2',
        title: 'Kỷ niệm ngày cưới',
        date: DateTime(2019, 9, 7),
        type: DayEventType.anniversary,
        colorValue: DayEventPalette.swatches[1].toARGB32(),
        iconKey: 'heart',
        repeatsYearly: true,
      ),
      DayEventModel(
        id: 'event-3',
        title: 'Sinh nhật của tôi',
        date: DateTime(1998, 9, 18),
        type: DayEventType.birthday,
        colorValue: DayEventPalette.swatches[6].toARGB32(),
        iconKey: 'celebration',
        repeatsYearly: true,
      ),
      DayEventModel(
        id: 'event-4',
        title: 'Họp lớp cấp 3',
        date: DateTime(2026, 9, 10),
        type: DayEventType.special,
        colorValue: DayEventPalette.swatches[3].toARGB32(),
        iconKey: 'school',
      ),
      DayEventModel(
        id: 'event-5',
        title: 'Rước đèn cùng bé',
        date: DateTime(2026, 9, 25),
        type: DayEventType.custom,
        colorValue: DayEventPalette.swatches[5].toARGB32(),
        iconKey: 'family',
      ),
    ]);
  }

  void _loadInitialMockData() {
    items.assignAll([
      // Today (07/09/2026)
      ScheduleItemModel(
        id: '1',
        title: 'Họp team',
        date: DateTime(2026, 9, 7),
        startTime: '08:00',
        endTime: '09:00',
        reminder: '10 phút trước',
        repeat: 'Không lặp lại',
        category: 'Công việc',
        note: 'Chuẩn bị slide báo cáo tiến độ tuần này.',
      ),
      ScheduleItemModel(
        id: '2',
        title: 'Tập gym',
        date: DateTime(2026, 9, 7),
        startTime: '10:30',
        endTime: '11:30',
        reminder: '15 phút trước',
        repeat: 'Hàng ngày',
        category: 'Tập luyện',
      ),
      ScheduleItemModel(
        id: '3',
        title: 'Làm project',
        date: DateTime(2026, 9, 7),
        startTime: '14:00',
        endTime: '17:00',
        reminder: '30 phút trước',
        repeat: 'Không lặp lại',
        category: 'Học tập',
        note: 'Hoàn thiện giao diện màn hình Lịch Finza.',
      ),
      ScheduleItemModel(
        id: '4',
        title: 'Mua đồ',
        date: DateTime(2026, 9, 7),
        startTime: '18:00',
        endTime: '19:00',
        reminder: 'Đúng giờ',
        repeat: 'Không lặp lại',
        category: 'Cá nhân',
      ),

      // Other dates in Sept 2026
      ScheduleItemModel(
        id: '5',
        title: 'Gặp đối tác UI/UX',
        date: DateTime(2026, 9, 10),
        startTime: '09:30',
        endTime: '11:00',
        reminder: '1 giờ trước',
        category: 'Công việc',
      ),
      ScheduleItemModel(
        id: '6',
        title: 'Thanh toán tiền nhà',
        date: DateTime(2026, 9, 15),
        startTime: '08:00',
        endTime: '08:30',
        reminder: '1 ngày trước',
        category: 'Cá nhân',
      ),
      ScheduleItemModel(
        id: '7',
        title: 'Review thiết kế Finza App',
        date: DateTime(2026, 9, 22),
        startTime: '15:00',
        endTime: '16:30',
        reminder: '15 phút trước',
        category: 'Công việc',
      ),
    ]);
  }

  List<ScheduleItemModel> get selectedDateItems {
    final sel = selectedDate.value;
    return items.where((item) {
      return item.date.year == sel.year &&
          item.date.month == sel.month &&
          item.date.day == sel.day;
    }).toList()..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  bool hasEventsOnDate(DateTime day) {
    return items.any(
      (item) =>
          item.date.year == day.year &&
          item.date.month == day.month &&
          item.date.day == day.day,
    );
  }

  List<ScheduleItemModel> scheduleItemsOn(DateTime day) {
    return items.where((item) => _sameDay(item.date, day)).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  /// System events first, then the user's own, in the order they were added.
  List<DayEventModel> dayEventsOn(DateTime day) {
    return [
      ...SystemHolidays.forMonth(
        day.year,
        day.month,
      ).where((event) => _sameDay(event.date, day)),
      ...userEvents.where((event) => event.occursOn(day)),
    ];
  }

  List<DayEventModel> get selectedDateEvents => dayEventsOn(selectedDate.value);

  /// Markers for every day of [month], keyed by day of month. Built once per
  /// render instead of scanning every list for each of the 42 cells.
  Map<int, DayMarkers> markersForMonth(DateTime month) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final holidays = SystemHolidays.forMonth(month.year, month.month);
    final markers = <int, DayMarkers>{};

    for (var day = 1; day <= daysInMonth; day++) {
      final date = DateTime(month.year, month.month, day);
      final hasHoliday = holidays.any((event) => event.date.day == day);
      final eventColors = [
        for (final event in userEvents)
          if (event.occursOn(date)) event.color,
      ];
      final hasSchedule = items.any((item) => _sameDay(item.date, date));

      if (hasHoliday || eventColors.isNotEmpty || hasSchedule) {
        markers[day] = DayMarkers(
          hasHoliday: hasHoliday,
          eventColors: eventColors,
          hasSchedule: hasSchedule,
        );
      }
    }
    return markers;
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  void goToToday() {
    final now = DateTime.now();
    selectedMonth.value = DateTime(now.year, now.month, 1);
    selectedDate.value = DateTime(now.year, now.month, now.day);
  }

  void addDayEvent(DayEventModel event) {
    userEvents.add(event);
  }

  void updateDayEvent(DayEventModel event) {
    final index = userEvents.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      userEvents[index] = event;
    }
  }

  void deleteDayEvent(String id) {
    final index = userEvents.indexWhere((e) => e.id == id);
    if (index != -1) {
      lastDeletedEvent = userEvents[index];
      lastDeletedEventIndex = index;
      userEvents.removeAt(index);
    }
  }

  void undoDeleteDayEvent() {
    final event = lastDeletedEvent;
    final index = lastDeletedEventIndex;
    if (event == null) return;
    if (index != null && index >= 0 && index <= userEvents.length) {
      userEvents.insert(index, event);
    } else {
      userEvents.add(event);
    }
    lastDeletedEvent = null;
    lastDeletedEventIndex = null;
  }

  void selectDate(DateTime day) {
    selectedDate.value = day;
  }

  void previousMonth() {
    final current = selectedMonth.value;
    selectedMonth.value = DateTime(current.year, current.month - 1, 1);
  }

  void nextMonth() {
    final current = selectedMonth.value;
    selectedMonth.value = DateTime(current.year, current.month + 1, 1);
  }

  void toggleComplete(String id) {
    final index = items.indexWhere((e) => e.id == id);
    if (index != -1) {
      final current = items[index];
      items[index] = current.copyWith(isCompleted: !current.isCompleted);
    }
  }

  void addScheduleItem(ScheduleItemModel item) {
    items.add(item);
  }

  void updateScheduleItem(ScheduleItemModel item) {
    final index = items.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      items[index] = item;
    }
  }

  void deleteScheduleItem(String id) {
    final index = items.indexWhere((e) => e.id == id);
    if (index != -1) {
      lastDeletedItem = items[index];
      lastDeletedIndex = index;
      items.removeAt(index);
    }
  }

  void undoDelete() {
    if (lastDeletedItem != null) {
      if (lastDeletedIndex != null &&
          lastDeletedIndex! <= items.length &&
          lastDeletedIndex! >= 0) {
        items.insert(lastDeletedIndex!, lastDeletedItem!);
      } else {
        items.add(lastDeletedItem!);
      }
      lastDeletedItem = null;
      lastDeletedIndex = null;
    }
  }
}
