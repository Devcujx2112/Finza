import 'package:app/l10n/app_localizations.dart';
import 'package:app/src/feature/schedule/models/day_event_model.dart';
import 'package:app/src/feature/schedule/widgets/schedule_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

String dayEventTypeLabel(BuildContext context, DayEventType type) {
  final appLocal = AppLocalizations.of(context);
  switch (type) {
    case DayEventType.birthday:
      return appLocal?.scheduleEventTypeBirthday ?? 'Sinh nhật';
    case DayEventType.anniversary:
      return appLocal?.scheduleEventTypeAnniversary ?? 'Kỷ niệm';
    case DayEventType.special:
      return appLocal?.scheduleEventTypeSpecial ?? 'Ngày đặc biệt';
    case DayEventType.custom:
      return appLocal?.scheduleEventTypeCustom ?? 'Khác';
    case DayEventType.holiday:
      return appLocal?.scheduleEventTypeHoliday ?? 'Ngày lễ';
  }
}

/// "Birthday · Yearly", or just the type when the event does not repeat.
String dayEventSubtitle(BuildContext context, DayEventModel event) {
  final type = dayEventTypeLabel(context, event.type);
  if (!event.repeatsYearly) return type;
  return '$type · ${AppLocalizations.of(context)?.yearly ?? 'Hàng năm'}';
}

/// The colored icon square used for a day event everywhere it appears, so
/// the user's chosen color and icon read the same in every place.
class DayEventBadge extends StatelessWidget {
  final ScheduleTokens tokens;
  final DayEventModel event;
  final double size;

  const DayEventBadge({
    super.key,
    required this.tokens,
    required this.event,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.r,
      height: size.r,
      decoration: BoxDecoration(
        color: tokens.eventSoft(event),
        borderRadius: BorderRadius.circular((size * 0.3).r),
      ),
      child: Icon(
        event.icon,
        color: tokens.eventTone(event),
        size: (size * 0.5).sp,
      ),
    );
  }
}

/// Small "Holiday" pill that marks a system event as coming from Finza.
class SystemEventPill extends StatelessWidget {
  final ScheduleTokens tokens;

  const SystemEventPill({super.key, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: tokens.holidaySoft,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        AppLocalizations.of(context)?.scheduleEventTypeHoliday ?? 'Ngày lễ',
        style: tokens.text(
          10.5,
          weight: FontWeight.w600,
          color: tokens.holiday,
        ),
      ),
    );
  }
}

Widget _sheetFrame({
  required ScheduleTokens tokens,
  required BuildContext context,
  required Widget child,
  bool keyboardAware = false,
}) {
  return Container(
    padding: EdgeInsets.fromLTRB(
      20.w,
      12.h,
      20.w,
      (keyboardAware ? MediaQuery.of(context).viewInsets.bottom : 0) +
          MediaQuery.of(context).padding.bottom +
          20.h,
    ),
    decoration: BoxDecoration(
      color: tokens.surface,
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
    ),
    child: child,
  );
}

Widget _sheetHandle(ScheduleTokens tokens) {
  return Center(
    child: Container(
      width: 36.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: tokens.secondaryText.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2.r),
      ),
    ),
  );
}

// --- ADD CHOOSER ---

/// Asks whether the user wants a whole-day event or a timed activity, so
/// the two kinds of entries start apart and stay apart.
void showScheduleAddChooser(
  BuildContext context, {
  required ScheduleTokens tokens,
  required VoidCallback onAddEvent,
  required VoidCallback onAddActivity,
}) {
  final appLocal = AppLocalizations.of(context);

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      Widget option({
        required IconData icon,
        required String title,
        required String hint,
        required VoidCallback onTap,
      }) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(sheetContext);
            onTap();
          },
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: tokens.softSurface,
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Row(
              children: [
                Container(
                  width: 42.r,
                  height: 42.r,
                  decoration: BoxDecoration(
                    color: tokens.surface,
                    borderRadius: BorderRadius.circular(13.r),
                  ),
                  child: Icon(icon, color: tokens.accent, size: 21.sp),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: tokens.text(14.5, weight: FontWeight.w600),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        hint,
                        style: tokens.text(12, color: tokens.secondaryText),
                      ),
                    ],
                  ),
                ),
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

      return _sheetFrame(
        tokens: tokens,
        context: sheetContext,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sheetHandle(tokens),
            SizedBox(height: 16.h),
            Text(
              appLocal?.scheduleAddChooserTitle ?? 'Bạn muốn thêm gì?',
              style: tokens.text(18, weight: FontWeight.w700),
            ),
            SizedBox(height: 14.h),
            option(
              icon: Icons.today_rounded,
              title: appLocal?.scheduleDayEventsTitle ?? 'Sự kiện ngày',
              hint:
                  appLocal?.scheduleAddEventHint ??
                  'Sinh nhật, kỷ niệm, ngày đặc biệt',
              onTap: onAddEvent,
            ),
            SizedBox(height: 10.h),
            option(
              icon: Icons.schedule_rounded,
              title: appLocal?.scheduleDailyTitle ?? 'Lịch trong ngày',
              hint:
                  appLocal?.scheduleAddActivityHint ??
                  'Việc có giờ cụ thể trong ngày',
              onTap: onAddActivity,
            ),
          ],
        ),
      );
    },
  );
}

// --- DETAIL ---

void showDayEventDetail(
  BuildContext context, {
  required ScheduleTokens tokens,
  required DayEventModel event,
  required DateTime shownOn,
  VoidCallback? onEdit,
  VoidCallback? onDelete,
}) {
  final appLocal = AppLocalizations.of(context);
  final locale = Localizations.localeOf(context).toString();
  final dateLabel = DateFormat.yMMMMd(locale).format(shownOn);

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      Widget row(IconData icon, String label, String value) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 16.sp, color: tokens.secondaryText),
            SizedBox(width: 10.w),
            SizedBox(
              width: 76.w,
              child: Text(
                label,
                style: tokens.text(13, color: tokens.secondaryText),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: tokens.text(13, weight: FontWeight.w600),
              ),
            ),
          ],
        );
      }

      return _sheetFrame(
        tokens: tokens,
        context: sheetContext,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sheetHandle(tokens),
            SizedBox(height: 16.h),
            Row(
              children: [
                DayEventBadge(tokens: tokens, event: event, size: 46),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: tokens.text(18, weight: FontWeight.w700),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        dayEventSubtitle(context, event),
                        style: tokens.text(
                          12.5,
                          weight: FontWeight.w600,
                          color: tokens.eventTone(event),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 18.h),
            row(
              Icons.calendar_today_rounded,
              appLocal?.date ?? 'Ngày',
              dateLabel,
            ),
            SizedBox(height: 10.h),
            row(
              Icons.wb_sunny_outlined,
              appLocal?.time ?? 'Thời gian',
              appLocal?.scheduleAllDay ?? 'Cả ngày',
            ),
            if (event.note != null && event.note!.isNotEmpty) ...[
              SizedBox(height: 10.h),
              row(
                Icons.notes_rounded,
                appLocal?.note ?? 'Ghi chú',
                event.note!,
              ),
            ],
            SizedBox(height: 20.h),
            if (event.isSystem)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: tokens.softSurface,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 16.sp,
                      color: tokens.secondaryText,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        appLocal?.scheduleSystemEventNote ??
                            'Ngày lễ chung do Finza cung cấp nên không thể chỉnh sửa.',
                        style: tokens.text(12, color: tokens.secondaryText),
                      ),
                    ),
                  ],
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        onDelete?.call();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: tokens.danger),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(
                        appLocal?.delete ?? 'Xóa',
                        style: tokens.text(
                          14,
                          weight: FontWeight.w600,
                          color: tokens.danger,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        onEdit?.call();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: tokens.action,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(
                        appLocal?.edit ?? 'Chỉnh sửa',
                        style: tokens.text(
                          14,
                          weight: FontWeight.w600,
                          color: Colors.white,
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

// --- FORM ---

void showDayEventForm(
  BuildContext context, {
  required ScheduleTokens tokens,
  required DateTime initialDate,
  DayEventModel? initial,
  required ValueChanged<DayEventModel> onSave,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _DayEventFormSheet(
      tokens: tokens,
      initialDate: initialDate,
      initial: initial,
      onSave: onSave,
    ),
  );
}

class _DayEventFormSheet extends StatefulWidget {
  final ScheduleTokens tokens;
  final DateTime initialDate;
  final DayEventModel? initial;
  final ValueChanged<DayEventModel> onSave;

  const _DayEventFormSheet({
    required this.tokens,
    required this.initialDate,
    required this.initial,
    required this.onSave,
  });

  @override
  State<_DayEventFormSheet> createState() => _DayEventFormSheetState();
}

class _DayEventFormSheetState extends State<_DayEventFormSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _noteController;
  late DayEventType _type;
  late DateTime _date;
  late bool _repeatsYearly;
  late Color _color;
  late String _iconKey;
  bool _showTitleError = false;

  // Once the user picks a color, icon or repeat setting by hand, changing
  // the type must not overwrite it with that type's default.
  bool _colorTouched = false;
  bool _iconTouched = false;
  bool _repeatTouched = false;

  ScheduleTokens get t => widget.tokens;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _titleController = TextEditingController(text: initial?.title ?? '');
    _noteController = TextEditingController(text: initial?.note ?? '');
    _type = initial?.type ?? DayEventType.birthday;
    _date = initial?.date ?? widget.initialDate;
    _repeatsYearly = initial?.repeatsYearly ?? _repeatsByDefault(_type);
    _color = initial?.color ?? DayEventPalette.defaultFor(_type);
    _iconKey = initial?.iconKey ?? DayEventIcons.defaultFor(_type);
    if (initial != null) {
      _colorTouched = _iconTouched = _repeatTouched = true;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  static bool _repeatsByDefault(DayEventType type) =>
      type == DayEventType.birthday || type == DayEventType.anniversary;

  void _selectType(DayEventType type) {
    setState(() {
      _type = type;
      if (!_colorTouched) _color = DayEventPalette.defaultFor(type);
      if (!_iconTouched) _iconKey = DayEventIcons.defaultFor(type);
      if (!_repeatTouched) _repeatsYearly = _repeatsByDefault(type);
    });
  }

  DayEventModel _draft() {
    final title = _titleController.text.trim();
    final note = _noteController.text.trim();
    final base =
        widget.initial ??
        DayEventModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          date: _date,
          type: _type,
          colorValue: _color.toARGB32(),
          iconKey: _iconKey,
        );
    return base.copyWith(
      title: title,
      date: _date,
      type: _type,
      colorValue: _color.toARGB32(),
      iconKey: _iconKey,
      repeatsYearly: _repeatsYearly,
      note: note,
    );
  }

  void _save() {
    if (_titleController.text.trim().isEmpty) {
      setState(() => _showTitleError = true);
      return;
    }
    widget.onSave(_draft());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final appLocal = AppLocalizations.of(context);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: _sheetFrame(
        tokens: t,
        context: context,
        keyboardAware: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sheetHandle(t),
            SizedBox(height: 16.h),
            Text(
              widget.initial == null
                  ? (appLocal?.scheduleAddEvent ?? 'Thêm sự kiện')
                  : (appLocal?.scheduleEditEvent ?? 'Chỉnh sửa sự kiện'),
              style: t.text(18, weight: FontWeight.w700),
            ),
            SizedBox(height: 14.h),
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPreview(context),
                    SizedBox(height: 16.h),
                    _label(appLocal?.scheduleEventName ?? 'Tên sự kiện'),
                    _buildTitleField(context),
                    SizedBox(height: 14.h),
                    _label(appLocal?.scheduleEventType ?? 'Loại sự kiện'),
                    _buildTypePicker(context),
                    SizedBox(height: 14.h),
                    _label(appLocal?.date ?? 'Ngày'),
                    _buildDateField(context),
                    SizedBox(height: 8.h),
                    _buildRepeatSwitch(context),
                    SizedBox(height: 12.h),
                    _label(appLocal?.scheduleEventColor ?? 'Màu hiển thị'),
                    _buildColorPicker(),
                    SizedBox(height: 14.h),
                    _label(appLocal?.scheduleEventIcon ?? 'Biểu tượng'),
                    _buildIconPicker(),
                    SizedBox(height: 14.h),
                    _label(appLocal?.noteOptional ?? 'Ghi chú (Tùy chọn)'),
                    _buildNoteField(context),
                  ],
                ),
              ),
            ),
            SizedBox(height: 18.h),
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: t.action,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Text(
                  appLocal?.scheduleSaveEvent ?? 'Lưu sự kiện',
                  style: t.text(
                    15,
                    weight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Text(text, style: t.text(12, color: t.secondaryText)),
    );
  }

  /// Shows the event exactly as the day list will draw it.
  Widget _buildPreview(BuildContext context) {
    final draft = _draft();
    final title = draft.title.isEmpty
        ? (AppLocalizations.of(context)?.scheduleEventNameHint ??
              'Ví dụ: Sinh nhật mẹ')
        : draft.title;

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: t.page,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: t.border, width: 1.w),
      ),
      child: Row(
        children: [
          DayEventBadge(tokens: t, event: draft),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.text(
                    14,
                    weight: FontWeight.w600,
                    color: draft.title.isEmpty
                        ? t.secondaryText
                        : t.primaryText,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  dayEventSubtitle(context, draft),
                  style: t.text(12, color: t.secondaryText),
                ),
              ],
            ),
          ),
          Container(
            width: 8.r,
            height: 8.r,
            decoration: BoxDecoration(
              color: t.eventTone(draft),
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _fieldDecoration(String? hint, {String? error}) {
    final radius = BorderRadius.circular(12.r);
    return InputDecoration(
      hintText: hint,
      hintStyle: t.text(14, weight: FontWeight.w400, color: t.secondaryText),
      errorText: error,
      errorStyle: t.text(11.5, color: t.danger),
      filled: true,
      fillColor: t.softSurface,
      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      border: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: t.accent, width: 1.5.w),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: t.danger, width: 1.w),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: t.danger, width: 1.5.w),
      ),
    );
  }

  Widget _buildTitleField(BuildContext context) {
    final appLocal = AppLocalizations.of(context);
    return TextField(
      controller: _titleController,
      textCapitalization: TextCapitalization.sentences,
      style: t.text(14),
      onChanged: (_) => setState(() => _showTitleError = false),
      decoration: _fieldDecoration(
        appLocal?.scheduleEventNameHint ?? 'Ví dụ: Sinh nhật mẹ',
        error: _showTitleError
            ? (appLocal?.scheduleEventNameRequired ?? 'Hãy nhập tên sự kiện')
            : null,
      ),
    );
  }

  Widget _buildTypePicker(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        for (final type in DayEventType.userSelectable)
          GestureDetector(
            onTap: () => _selectType(type),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: _type == type ? t.action : t.softSurface,
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: Text(
                dayEventTypeLabel(context, type),
                style: t.text(
                  12.5,
                  weight: FontWeight.w600,
                  color: _type == type ? Colors.white : t.primaryText,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDateField(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _date,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (picked != null) setState(() => _date = picked);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: t.softSurface,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_rounded, size: 16.sp, color: t.accent),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                DateFormat.yMMMMd(locale).format(_date),
                style: t.text(13.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRepeatSwitch(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.repeat_rounded, size: 16.sp, color: t.secondaryText),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            AppLocalizations.of(context)?.scheduleRepeatYearly ??
                'Lặp lại hằng năm',
            style: t.text(13.5),
          ),
        ),
        Switch.adaptive(
          value: _repeatsYearly,
          activeTrackColor: t.action,
          onChanged: (value) => setState(() {
            _repeatsYearly = value;
            _repeatTouched = true;
          }),
        ),
      ],
    );
  }

  Widget _buildColorPicker() {
    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: [
        for (final swatch in DayEventPalette.swatches)
          GestureDetector(
            onTap: () => setState(() {
              _color = swatch;
              _colorTouched = true;
            }),
            behavior: HitTestBehavior.opaque,
            child: _swatch(swatch, swatch.toARGB32() == _color.toARGB32()),
          ),
      ],
    );
  }

  Widget _swatch(Color swatch, bool selected) {
    final tone = DayEventPalette.tone(swatch, t.isDark);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 32.r,
      height: 32.r,
      padding: EdgeInsets.all(3.r),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? tone : Colors.transparent,
          width: 2.w,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(color: tone, shape: BoxShape.circle),
        child: selected
            ? Icon(Icons.check_rounded, color: Colors.white, size: 15.sp)
            : null,
      ),
    );
  }

  Widget _buildIconPicker() {
    final tone = DayEventPalette.tone(_color, t.isDark);
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        for (final entry in DayEventIcons.catalog.entries)
          GestureDetector(
            onTap: () => setState(() {
              _iconKey = entry.key;
              _iconTouched = true;
            }),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 42.r,
              height: 42.r,
              decoration: BoxDecoration(
                color: entry.key == _iconKey
                    ? _color.withValues(alpha: t.isDark ? 0.22 : 0.13)
                    : t.softSurface,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: entry.key == _iconKey ? tone : Colors.transparent,
                  width: 1.5.w,
                ),
              ),
              child: Icon(
                entry.value,
                size: 20.sp,
                color: entry.key == _iconKey ? tone : t.secondaryText,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNoteField(BuildContext context) {
    return TextField(
      controller: _noteController,
      maxLines: 2,
      style: t.text(13.5),
      decoration: _fieldDecoration(
        AppLocalizations.of(context)?.addDetailedNoteHint ??
            'Thêm ghi chú chi tiết...',
      ),
    );
  }
}
