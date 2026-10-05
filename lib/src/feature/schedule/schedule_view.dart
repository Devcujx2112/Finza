import 'dart:math' as math;

import 'package:app/l10n/app_localizations.dart';
import 'package:app/src/core/color/app_colors.dart';
import 'package:app/src/core/widget/adaptive_page.dart';
import 'package:app/src/feature/main_controller/main_controller.dart';
import 'package:app/src/feature/schedule/models/day_event_model.dart';
import 'package:app/src/feature/schedule/models/schedule_item_model.dart';
import 'package:app/src/feature/schedule/schedule_controller.dart';
import 'package:app/src/feature/schedule/widgets/day_event_sheets.dart';
import 'package:app/src/feature/schedule/widgets/schedule_calendar.dart';
import 'package:app/src/feature/schedule/widgets/schedule_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> with AdaptivePage {
  late final ScheduleController controller;
  MainController? mainController;

  /// Day events beyond this count fold behind a "Show more" link.
  static const int _collapsedEventCount = 3;

  /// The day whose event list the user expanded, if any. Keyed by date so
  /// picking another day folds the list again.
  DateTime? _expandedEventsDay;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ScheduleController());
    if (Get.isRegistered<MainController>()) {
      mainController = Get.find<MainController>();
    }
  }

  bool _isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ||
        (mainController?.isDarkMode ?? false);
  }

  Color _surfaceColor(bool isDark) =>
      isDark ? AppColors.homeDarkSurface : AppColors.homeSurface;

  Color _softSurfaceColor(bool isDark) =>
      isDark ? AppColors.homeDarkSoftSurface : AppColors.homeSoftSurface;

  Color _primaryText(bool isDark) =>
      isDark ? AppColors.primaryColor : AppColors.colorMenuBar;

  Color _secondaryText(bool isDark) =>
      isDark ? AppColors.homeDarkMutedText : AppColors.homeMutedText;

  @override
  Widget build(BuildContext context) {
    return adaptiveBody(context);
  }

  @override
  Widget mobileLandscapeBody(BuildContext context, Size size) =>
      _buildScreen(context, size);

  @override
  Widget mobilePortraitBody(BuildContext context, Size size) =>
      _buildScreen(context, size);

  @override
  Widget tabletLandscapeBody(BuildContext context, Size size) =>
      _buildScreen(context, size);

  @override
  Widget tabletPortraitBody(BuildContext context, Size size) =>
      _buildScreen(context, size);

  Widget _buildScreen(BuildContext context, Size size) {
    final tokens = ScheduleTokens(_isDark(context));
    // Keep the calendar a comfortable reading width on tablets.
    final horizontalPadding = math.max(20.w, (size.width - 640) / 2);

    return Scaffold(
      backgroundColor: tokens.page,
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          final month = controller.selectedMonth.value;
          final selected = controller.selectedDate.value;
          final markers = controller.markersForMonth(month);
          final events = controller.dayEventsOn(selected);
          final activities = controller.scheduleItemsOn(selected);

          return ListView(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              12.h,
              horizontalPadding,
              140.h,
            ),
            physics: const BouncingScrollPhysics(),
            children: [
              _buildHeader(tokens),
              SizedBox(height: 16.h),
              ScheduleCalendar(
                tokens: tokens,
                month: month,
                selectedDate: selected,
                markers: markers,
                onSelectDate: controller.selectDate,
                onPreviousMonth: controller.previousMonth,
                onNextMonth: controller.nextMonth,
              ),
              SizedBox(height: 22.h),
              _buildSelectedDateHeader(tokens, selected),
              SizedBox(height: 14.h),
              if (events.isEmpty && activities.isEmpty)
                _buildEmptyDay(tokens)
              else ...[
                _buildDayEventsSection(tokens, events, selected),
                SizedBox(height: 24.h),
                _buildDailyScheduleSection(tokens, activities),
              ],
            ],
          );
        }),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 80.h),
        child: SizedBox(
          height: 56.r,
          width: 56.r,
          child: FloatingActionButton(
            onPressed: () => showScheduleAddChooser(
              context,
              tokens: tokens,
              onAddEvent: () => _openDayEventForm(tokens),
              onAddActivity: () => _openAddReminderBottomSheet(context),
            ),
            elevation: 3,
            backgroundColor: tokens.action,
            shape: const CircleBorder(),
            child: Icon(Icons.add_rounded, color: Colors.white, size: 26.sp),
          ),
        ),
      ),
    );
  }

  // --- HEADER ---

  Widget _buildHeader(ScheduleTokens tokens) {
    final appLocal = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          appLocal?.scheduleTitle ?? 'Lịch',
          maxLines: 1,
          style: tokens.text(22, weight: FontWeight.w700, height: 1.15),
        ),
        SizedBox(height: 4.h),
        Text(
          appLocal?.scheduleSubtitle ?? 'Quản lý lịch và lời nhắc',
          style: tokens.text(13, color: tokens.secondaryText),
        ),
      ],
    );
  }

  // --- SELECTED DATE ---

  Widget _buildSelectedDateHeader(ScheduleTokens tokens, DateTime selected) {
    final locale = Localizations.localeOf(context).toString();
    final now = DateTime.now();
    final isToday =
        selected.year == now.year &&
        selected.month == now.month &&
        selected.day == now.day;

    final title = isToday
        ? (AppLocalizations.of(context)?.today ?? 'Hôm nay')
        : DateFormat.EEEE(locale).format(selected).capitalizeFirst ?? '';
    final subtitle = isToday
        ? DateFormat.yMMMMEEEEd(locale).format(selected)
        : DateFormat.yMMMMd(locale).format(selected);

    final isTodayMonth =
        controller.selectedMonth.value.year == now.year &&
        controller.selectedMonth.value.month == now.month;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: tokens.text(18, weight: FontWeight.w700)),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: tokens.text(12.5, color: tokens.secondaryText),
              ),
            ],
          ),
        ),
        // Jump back to today, shown only once the user has moved away.
        if (!isToday || !isTodayMonth) ...[
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: controller.goToToday,
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 34.r,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: tokens.softSurface,
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: Text(
                AppLocalizations.of(context)?.today ?? 'Hôm nay',
                style: tokens.text(
                  12.5,
                  weight: FontWeight.w600,
                  color: tokens.isDark ? tokens.accent : tokens.action,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(
    ScheduleTokens tokens, {
    required IconData icon,
    required String title,
    required String hint,
    required int count,
    required String addLabel,
    required VoidCallback? onAdd,
  }) {
    return Row(
      children: [
        Container(
          width: 34.r,
          height: 34.r,
          decoration: BoxDecoration(
            color: tokens.softSurface,
            borderRadius: BorderRadius.circular(11.r),
          ),
          child: Icon(icon, color: tokens.accent, size: 18.sp),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tokens.text(15, weight: FontWeight.w700),
                    ),
                  ),
                  if (count > 0) ...[
                    SizedBox(width: 6.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 7.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: tokens.softSurface,
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Text(
                        '$count',
                        style: tokens.text(
                          11,
                          weight: FontWeight.w600,
                          color: tokens.secondaryText,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Text(hint, style: tokens.text(11.5, color: tokens.secondaryText)),
            ],
          ),
        ),
        if (onAdd != null)
          Semantics(
            button: true,
            label: addLabel,
            child: GestureDetector(
              onTap: onAdd,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 34.r,
                height: 34.r,
                decoration: BoxDecoration(
                  border: Border.all(color: tokens.border, width: 1.w),
                  borderRadius: BorderRadius.circular(11.r),
                ),
                child: Icon(
                  Icons.add_rounded,
                  color: tokens.primaryText,
                  size: 19.sp,
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// One-line placeholder for a section with nothing in it. The whole row
  /// is the add action, so the header does not repeat it.
  Widget _buildSectionEmptyRow(
    ScheduleTokens tokens, {
    required String message,
    required String actionLabel,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: tokens.border, width: 1.w),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                message,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: tokens.text(12.5, color: tokens.secondaryText),
              ),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.add_rounded, size: 16.sp, color: tokens.accent),
            SizedBox(width: 2.w),
            Text(
              actionLabel,
              style: tokens.text(
                12.5,
                weight: FontWeight.w600,
                color: tokens.isDark ? tokens.accent : tokens.action,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- DAY EVENTS ---

  Widget _buildDayEventsSection(
    ScheduleTokens tokens,
    List<DayEventModel> events,
    DateTime selected,
  ) {
    final appLocal = AppLocalizations.of(context);
    final addLabel = appLocal?.scheduleAddEvent ?? 'Thêm sự kiện';
    final isExpanded = _expandedEventsDay == selected;
    final hiddenCount = events.length - _collapsedEventCount;
    final visible = isExpanded || hiddenCount <= 0
        ? events
        : events.take(_collapsedEventCount).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          tokens,
          icon: Icons.today_rounded,
          title: appLocal?.scheduleDayEventsTitle ?? 'Sự kiện ngày',
          hint: appLocal?.scheduleAllDay ?? 'Cả ngày',
          count: events.length,
          addLabel: addLabel,
          onAdd: events.isEmpty ? null : () => _openDayEventForm(tokens),
        ),
        SizedBox(height: 12.h),
        if (events.isEmpty)
          _buildSectionEmptyRow(
            tokens,
            message: appLocal?.scheduleNoDayEvents ?? 'Không có sự kiện nào',
            actionLabel: addLabel,
            onTap: () => _openDayEventForm(tokens),
          )
        else ...[
          for (var i = 0; i < visible.length; i++) ...[
            if (i > 0) SizedBox(height: 8.h),
            _buildDayEventRow(tokens, visible[i], selected),
          ],
          if (hiddenCount > 0)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => setState(() {
                  _expandedEventsDay = isExpanded ? null : selected;
                }),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  minimumSize: Size(0, 36.h),
                ),
                child: Text(
                  isExpanded
                      ? (appLocal?.scheduleShowLess ?? 'Thu gọn')
                      : (appLocal?.scheduleShowMore(hiddenCount) ??
                            'Xem thêm $hiddenCount'),
                  style: tokens.text(
                    12.5,
                    weight: FontWeight.w600,
                    color: tokens.isDark ? tokens.accent : tokens.action,
                  ),
                ),
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildDayEventRow(
    ScheduleTokens tokens,
    DayEventModel event,
    DateTime selected,
  ) {
    return GestureDetector(
      onTap: () => showDayEventDetail(
        context,
        tokens: tokens,
        event: event,
        shownOn: selected,
        onEdit: () => _openDayEventForm(tokens, initial: event),
        onDelete: () => _deleteDayEvent(tokens, event),
      ),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: tokens.surface,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: tokens.border, width: 1.w),
        ),
        child: Row(
          children: [
            DayEventBadge(tokens: tokens, event: event),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tokens.text(14, weight: FontWeight.w600),
                  ),
                  // System events say what they are in the pill instead.
                  if (!event.isSystem) ...[
                    SizedBox(height: 1.h),
                    Text(
                      dayEventSubtitle(context, event),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tokens.text(12, color: tokens.secondaryText),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 8.w),
            if (event.isSystem)
              SystemEventPill(tokens: tokens)
            else
              Icon(
                Icons.chevron_right_rounded,
                color: tokens.secondaryText,
                size: 20.sp,
              ),
          ],
        ),
      ),
    );
  }

  void _openDayEventForm(ScheduleTokens tokens, {DayEventModel? initial}) {
    showDayEventForm(
      context,
      tokens: tokens,
      initialDate: controller.selectedDate.value,
      initial: initial,
      onSave: (event) {
        if (initial == null) {
          controller.addDayEvent(event);
        } else {
          controller.updateDayEvent(event);
        }
      },
    );
  }

  void _deleteDayEvent(ScheduleTokens tokens, DayEventModel event) {
    controller.deleteDayEvent(event.id);
    _showUndoSnackBar(
      tokens.isDark,
      AppLocalizations.of(context)?.scheduleEventDeleted ?? 'Đã xóa sự kiện',
      controller.undoDeleteDayEvent,
    );
  }

  void _showUndoSnackBar(bool isDark, String message, VoidCallback onUndo) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins(fontSize: 13.sp)),
        action: SnackBarAction(
          label: AppLocalizations.of(context)?.undo ?? 'Hoàn tác',
          textColor: AppColors.primarySecondaryColor,
          onPressed: onUndo,
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: isDark
            ? AppColors.profileDarkSurface
            : AppColors.colorMenuBar,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  // --- DAILY SCHEDULE ---

  Widget _buildDailyScheduleSection(
    ScheduleTokens tokens,
    List<ScheduleItemModel> items,
  ) {
    final appLocal = AppLocalizations.of(context);
    final addLabel = appLocal?.scheduleAddActivity ?? 'Thêm hoạt động';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          tokens,
          icon: Icons.schedule_rounded,
          title: appLocal?.scheduleDailyTitle ?? 'Lịch trong ngày',
          hint: appLocal?.scheduleByTime ?? 'Theo giờ',
          count: items.length,
          addLabel: addLabel,
          onAdd: items.isEmpty
              ? null
              : () => _openAddReminderBottomSheet(context),
        ),
        SizedBox(height: 12.h),
        if (items.isEmpty)
          _buildSectionEmptyRow(
            tokens,
            message:
                appLocal?.scheduleNoActivities ?? 'Chưa có hoạt động theo giờ',
            actionLabel: addLabel,
            onTap: () => _openAddReminderBottomSheet(context),
          )
        else
          for (var i = 0; i < items.length; i++)
            _buildDismissibleTimelineItem(
              context,
              items[i],
              i == items.length - 1,
              tokens,
            ),
      ],
    );
  }

  Widget _buildDismissibleTimelineItem(
    BuildContext context,
    ScheduleItemModel item,
    bool isLast,
    ScheduleTokens tokens,
  ) {
    final appLocal = AppLocalizations.of(context);

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.horizontal,

      // Swipe right: toggle completion.
      background: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20.w),
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: tokens.action,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Row(
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              color: Colors.white,
              size: 22.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              appLocal?.completed ?? 'Hoàn thành',
              style: tokens.text(
                13.5,
                weight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),

      // Swipe left: delete.
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: AppColors.errorColor,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              appLocal?.delete ?? 'Xóa',
              style: tokens.text(
                13.5,
                weight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.delete_outline_rounded,
              color: Colors.white,
              size: 22.sp,
            ),
          ],
        ),
      ),

      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Keep the row; only its completed state changes.
          controller.toggleComplete(item.id);
          return false;
        }
        return true;
      },

      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          controller.deleteScheduleItem(item.id);
          _showUndoSnackBar(
            tokens.isDark,
            appLocal?.scheduleActivityDeleted ?? 'Đã xóa hoạt động',
            controller.undoDelete,
          );
        }
      },

      // No IntrinsicHeight here: it under-measures Poppins text and clips
      // the card by a pixel or two. The rail is drawn behind the row instead.
      child: Stack(
        children: [
          if (!isLast)
            Positioned(
              left: 50.w + 7.w - 0.75.w,
              top: 17.h + 10.r + 4.h,
              bottom: 0,
              child: Container(width: 1.5.w, color: tokens.border),
            ),
          Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time anchor, same layout as the Home agenda.
                SizedBox(
                  width: 50.w,
                  child: Padding(
                    padding: EdgeInsets.only(top: 12.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.startTime,
                          style: tokens.text(
                            13.5,
                            weight: FontWeight.w700,
                            color: item.isCompleted
                                ? tokens.secondaryText
                                : tokens.primaryText,
                          ),
                        ),
                        Text(
                          item.endTime,
                          style: tokens.text(11, color: tokens.secondaryText),
                        ),
                      ],
                    ),
                  ),
                ),

                // Timeline dot.
                Container(
                  width: 14.w,
                  padding: EdgeInsets.only(top: 17.h),
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 10.r,
                    height: 10.r,
                    decoration: BoxDecoration(
                      color: item.isCompleted ? tokens.accent : tokens.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: tokens.accent, width: 2.w),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),

                // Activity card.
                Expanded(
                  child: GestureDetector(
                    onTap: () => _openEventDetailBottomSheet(context, item),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: EdgeInsets.all(14.r),
                      decoration: BoxDecoration(
                        color: tokens.surface,
                        borderRadius: BorderRadius.circular(18.r),
                        border: Border.all(color: tokens.border, width: 1.w),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    color: item.isCompleted
                                        ? tokens.secondaryText
                                        : tokens.primaryText,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    decoration: item.isCompleted
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    decorationColor: tokens.secondaryText,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              GestureDetector(
                                onTap: () => controller.toggleComplete(item.id),
                                behavior: HitTestBehavior.opaque,
                                child: Padding(
                                  padding: EdgeInsets.all(2.r),
                                  child: Icon(
                                    item.isCompleted
                                        ? Icons.check_circle_rounded
                                        : Icons.circle_outlined,
                                    color: item.isCompleted
                                        ? tokens.accent
                                        : tokens.secondaryText,
                                    size: 20.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (item.reminder.isNotEmpty) ...[
                            SizedBox(height: 6.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.notifications_none_rounded,
                                  color: tokens.accent,
                                  size: 14.sp,
                                ),
                                SizedBox(width: 4.w),
                                Flexible(
                                  child: Text(
                                    item.reminder,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: tokens.text(
                                      11.5,
                                      color: tokens.secondaryText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (item.note != null && item.note!.isNotEmpty) ...[
                            SizedBox(height: 4.h),
                            Text(
                              item.note!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: tokens.text(
                                11.5,
                                weight: FontWeight.w400,
                                color: tokens.secondaryText,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- EMPTY DAY ---

  Widget _buildEmptyDay(ScheduleTokens tokens) {
    final appLocal = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: tokens.border, width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: tokens.softSurface,
                  borderRadius: BorderRadius.circular(13.r),
                ),
                child: Icon(
                  Icons.event_available_rounded,
                  color: tokens.accent,
                  size: 21.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appLocal?.scheduleEmptyDayTitle ?? 'Ngày này còn trống',
                      style: tokens.text(14.5, weight: FontWeight.w600),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      appLocal?.scheduleEmptyDayBody ??
                          'Thêm một sự kiện như sinh nhật, hoặc lên lịch cho một hoạt động theo giờ.',
                      style: tokens.text(
                        12.5,
                        weight: FontWeight.w400,
                        color: tokens.secondaryText,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _openDayEventForm(tokens),
                  icon: Icon(
                    Icons.today_rounded,
                    size: 16.sp,
                    color: tokens.primaryText,
                  ),
                  label: Text(
                    appLocal?.scheduleAddEvent ?? 'Thêm sự kiện',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tokens.text(13, weight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: tokens.border, width: 1.w),
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 11.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _openAddReminderBottomSheet(context),
                  icon: Icon(
                    Icons.schedule_rounded,
                    size: 16.sp,
                    color: Colors.white,
                  ),
                  label: Text(
                    appLocal?.scheduleAddActivity ?? 'Thêm hoạt động',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tokens.text(
                      13,
                      weight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tokens.action,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 11.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- ADD REMINDER BOTTOM SHEET ---

  void _openAddReminderBottomSheet(
    BuildContext context, {
    ScheduleItemModel? initialItem,
  }) {
    final isDark = _isDark(context);
    final titleController = TextEditingController(
      text: initialItem?.title ?? '',
    );
    final noteController = TextEditingController(text: initialItem?.note ?? '');

    final selectedDate = initialItem?.date ?? controller.selectedDate.value;
    DateTime formDate = selectedDate;
    TimeOfDay formTime = const TimeOfDay(hour: 8, minute: 0);
    final initialStart = initialItem?.startTime.split(':');
    if (initialStart != null && initialStart.length == 2) {
      formTime = TimeOfDay(
        hour: int.tryParse(initialStart[0]) ?? 8,
        minute: int.tryParse(initialStart[1]) ?? 0,
      );
    }

    String selectedReminder = initialItem?.reminder ?? '10 phút trước';
    String selectedRepeat = initialItem?.repeat ?? 'Không lặp lại';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.fromLTRB(
                20.w,
                12.h,
                20.w,
                MediaQuery.of(context).viewInsets.bottom + 20.h,
              ),
              decoration: BoxDecoration(
                color: _surfaceColor(isDark),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle Bar
                  Center(
                    child: Container(
                      width: 36.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: _secondaryText(isDark).withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Sheet Title
                  Text(
                    initialItem == null
                        ? (AppLocalizations.of(context)?.scheduleAddActivity ??
                              'Thêm hoạt động')
                        : (AppLocalizations.of(context)?.scheduleEditActivity ??
                              'Chỉnh sửa hoạt động'),
                    style: GoogleFonts.poppins(
                      color: _primaryText(isDark),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Tên hoạt động
                  Text(
                    AppLocalizations.of(context)?.scheduleActivityName ??
                        'Tên hoạt động',
                    style: GoogleFonts.poppins(
                      color: _secondaryText(isDark),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  TextField(
                    controller: titleController,
                    style: GoogleFonts.poppins(
                      color: _primaryText(isDark),
                      fontSize: 14.sp,
                    ),
                    decoration: InputDecoration(
                      hintText:
                          AppLocalizations.of(context)?.reminderNameHint ??
                          'Ví dụ: Họp team',
                      hintStyle: GoogleFonts.poppins(
                        color: _secondaryText(isDark).withValues(alpha: 0.5),
                        fontSize: 14.sp,
                      ),
                      filled: true,
                      fillColor: _softSurfaceColor(isDark),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 12.h,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),

                  // Ngày & Thời gian Row
                  Row(
                    children: [
                      // Date Selector
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)?.date ?? 'Ngày',
                              style: GoogleFonts.poppins(
                                color: _secondaryText(isDark),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            GestureDetector(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: formDate,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2030),
                                );
                                if (picked != null) {
                                  setModalState(() {
                                    formDate = picked;
                                  });
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 12.h,
                                ),
                                decoration: BoxDecoration(
                                  color: _softSurfaceColor(isDark),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_rounded,
                                      size: 16.sp,
                                      color: AppColors.primarySecondaryColor,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      DateFormat('dd/MM/yyyy').format(formDate),
                                      style: GoogleFonts.poppins(
                                        color: _primaryText(isDark),
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),

                      // Time Selector
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)?.time ?? 'Thời gian',
                              style: GoogleFonts.poppins(
                                color: _secondaryText(isDark),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            GestureDetector(
                              onTap: () async {
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: formTime,
                                );
                                if (picked != null) {
                                  setModalState(() {
                                    formTime = picked;
                                  });
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 12.h,
                                ),
                                decoration: BoxDecoration(
                                  color: _softSurfaceColor(isDark),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.access_time_rounded,
                                      size: 16.sp,
                                      color: AppColors.primarySecondaryColor,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      '${formTime.hour.toString().padLeft(2, '0')}:${formTime.minute.toString().padLeft(2, '0')}',
                                      style: GoogleFonts.poppins(
                                        color: _primaryText(isDark),
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),

                  // Nhắc tôi
                  Text(
                    AppLocalizations.of(context)?.remindMe ?? 'Nhắc tôi',
                    style: GoogleFonts.poppins(
                      color: _secondaryText(isDark),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                      color: _softSurfaceColor(isDark),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedReminder,
                        isExpanded: true,
                        dropdownColor: _surfaceColor(isDark),
                        style: GoogleFonts.poppins(
                          color: _primaryText(isDark),
                          fontSize: 13.sp,
                        ),
                        items:
                            [
                              'Đúng giờ',
                              '5 phút trước',
                              '10 phút trước',
                              '15 phút trước',
                              '30 phút trước',
                              '1 giờ trước',
                            ].map((e) {
                              return DropdownMenuItem(value: e, child: Text(e));
                            }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() {
                              selectedReminder = val;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),

                  // Lặp lại
                  Text(
                    AppLocalizations.of(context)?.repeat ?? 'Lặp lại',
                    style: GoogleFonts.poppins(
                      color: _secondaryText(isDark),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                      color: _softSurfaceColor(isDark),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedRepeat,
                        isExpanded: true,
                        dropdownColor: _surfaceColor(isDark),
                        style: GoogleFonts.poppins(
                          color: _primaryText(isDark),
                          fontSize: 13.sp,
                        ),
                        items:
                            [
                              'Không lặp lại',
                              'Hàng ngày',
                              'Hàng tuần',
                              'Hàng tháng',
                              'Hàng năm',
                            ].map((e) {
                              return DropdownMenuItem(value: e, child: Text(e));
                            }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() {
                              selectedRepeat = val;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),

                  // Ghi chú
                  Text(
                    AppLocalizations.of(context)?.noteOptional ??
                        'Ghi chú (Tùy chọn)',
                    style: GoogleFonts.poppins(
                      color: _secondaryText(isDark),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  TextField(
                    controller: noteController,
                    maxLines: 2,
                    style: GoogleFonts.poppins(
                      color: _primaryText(isDark),
                      fontSize: 13.sp,
                    ),
                    decoration: InputDecoration(
                      hintText:
                          AppLocalizations.of(context)?.addDetailedNoteHint ??
                          'Thêm ghi chú chi tiết...',
                      hintStyle: GoogleFonts.poppins(
                        color: _secondaryText(isDark).withValues(alpha: 0.5),
                        fontSize: 13.sp,
                      ),
                      filled: true,
                      fillColor: _softSurfaceColor(isDark),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 10.h,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: () {
                        final title = titleController.text.trim();
                        if (title.isEmpty) return;

                        final startStr =
                            '${formTime.hour.toString().padLeft(2, '0')}:${formTime.minute.toString().padLeft(2, '0')}';
                        final endHour = (formTime.hour + 1) % 24;
                        final endStr =
                            '${endHour.toString().padLeft(2, '0')}:${formTime.minute.toString().padLeft(2, '0')}';

                        if (initialItem == null) {
                          final newItem = ScheduleItemModel(
                            id: DateTime.now().millisecondsSinceEpoch
                                .toString(),
                            title: title,
                            date: formDate,
                            startTime: startStr,
                            endTime: endStr,
                            reminder: selectedReminder,
                            repeat: selectedRepeat,
                            note: noteController.text.trim(),
                          );
                          controller.addScheduleItem(newItem);
                        } else {
                          final updated = initialItem.copyWith(
                            title: title,
                            date: formDate,
                            startTime: startStr,
                            endTime: endStr,
                            reminder: selectedReminder,
                            repeat: selectedRepeat,
                            note: noteController.text.trim(),
                          );
                          controller.updateScheduleItem(updated);
                        }

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.scheduleAction,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        AppLocalizations.of(context)?.saveReminder ?? 'Lưu',
                        style: GoogleFonts.poppins(
                          color: AppColors.whiteColor,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --- POLISHED EVENT DETAILS BOTTOM SHEET ---

  void _openEventDetailBottomSheet(
    BuildContext context,
    ScheduleItemModel item,
  ) {
    final isDark = _isDark(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
          decoration: BoxDecoration(
            color: _surfaceColor(isDark),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: _secondaryText(isDark).withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Title Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.title,
                      style: GoogleFonts.poppins(
                        color: _primaryText(isDark),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.toggleComplete(item.id);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: item.isCompleted
                            ? AppColors.primarySecondaryColor.withValues(
                                alpha: 0.12,
                              )
                            : _softSurfaceColor(isDark),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            item.isCompleted
                                ? Icons.check_circle_rounded
                                : Icons.circle_outlined,
                            size: 14.sp,
                            color: item.isCompleted
                                ? AppColors.primarySecondaryColor
                                : _secondaryText(isDark),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            item.isCompleted
                                ? (AppLocalizations.of(context)?.done ??
                                      'Đã xong')
                                : (AppLocalizations.of(context)?.notDone ??
                                      'Chưa xong'),
                            style: GoogleFonts.poppins(
                              color: item.isCompleted
                                  ? AppColors.primarySecondaryColor
                                  : _secondaryText(isDark),
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Detail List
              _buildDetailRow(
                Icons.calendar_today_rounded,
                AppLocalizations.of(context)?.date ?? 'Ngày',
                DateFormat('dd/MM/yyyy').format(item.date),
                isDark,
              ),
              SizedBox(height: 10.h),
              _buildDetailRow(
                Icons.access_time_rounded,
                AppLocalizations.of(context)?.time ?? 'Thời gian',
                '${item.startTime} - ${item.endTime}',
                isDark,
              ),
              SizedBox(height: 10.h),
              _buildDetailRow(
                Icons.notifications_none_rounded,
                AppLocalizations.of(context)?.remindMe ?? 'Nhắc tôi',
                item.reminder,
                isDark,
              ),
              SizedBox(height: 10.h),
              _buildDetailRow(
                Icons.repeat_rounded,
                AppLocalizations.of(context)?.repeat ?? 'Lặp lại',
                item.repeat,
                isDark,
              ),
              if (item.note != null && item.note!.isNotEmpty) ...[
                SizedBox(height: 10.h),
                _buildDetailRow(
                  Icons.notes_rounded,
                  AppLocalizations.of(context)?.note ?? 'Ghi chú',
                  item.note!,
                  isDark,
                ),
              ],
              SizedBox(height: 20.h),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        controller.deleteScheduleItem(item.id);
                        Navigator.pop(context);
                        _showUndoSnackBar(
                          isDark,
                          AppLocalizations.of(
                                this.context,
                              )?.scheduleActivityDeleted ??
                              'Đã xóa hoạt động',
                          controller.undoDelete,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.errorColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(
                        AppLocalizations.of(context)?.delete ?? 'Xóa',
                        style: GoogleFonts.poppins(
                          color: AppColors.errorColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _openAddReminderBottomSheet(context, initialItem: item);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.scheduleAction,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(
                        AppLocalizations.of(context)?.edit ?? 'Chỉnh sửa',
                        style: GoogleFonts.poppins(
                          color: AppColors.whiteColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    bool isDark,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: AppColors.primarySecondaryColor),
        SizedBox(width: 10.w),
        Text(
          '$label: ',
          style: GoogleFonts.poppins(
            color: _secondaryText(isDark),
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              color: _primaryText(isDark),
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
