import 'package:app/src/core/color/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

enum CalendarMode { day, month, year }

class CustomCalendar extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime)? onChanged;

  const CustomCalendar({super.key, required this.initialDate, this.onChanged});

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar>
    with SingleTickerProviderStateMixin {
  late DateTime selectedDate;
  late DateTime viewDate;
  CalendarMode mode = CalendarMode.day;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    viewDate = widget.initialDate;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _changeMode(CalendarMode newMode) {
    setState(() {
      mode = newMode;
      _animationController.reset();
      _animationController.forward();
    });
  }

  List<DateTime?> _daysInMonth(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    final lastDay = DateTime(date.year, date.month + 1, 0);
    final days = <DateTime?>[];

    // Calculate padding (0 for Sunday, 1 for Monday, etc.)
    int weekdayPadding = firstDay.weekday % 7;
    for (int i = 0; i < weekdayPadding; i++) {
      days.add(null);
    }

    for (int i = 1; i <= lastDay.day; i++) {
      days.add(DateTime(date.year, date.month, i));
    }
    return days;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 16.h),
            child: FadeTransition(opacity: _fadeAnimation, child: _buildBody()),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.buttonLogin.withOpacity(0.1),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _onPrevious,
            icon: Icon(
              Icons.chevron_left_rounded,
              color: AppColors.buttonLogin,
              size: 28.sp,
            ),
            visualDensity: VisualDensity.compact,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (mode == CalendarMode.day) {
                  _changeMode(CalendarMode.month);
                } else if (mode == CalendarMode.month) {
                  _changeMode(CalendarMode.year);
                }
              },
              child: Text(
                _getHeaderText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.buttonLogin,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: _onNext,
            icon: Icon(
              Icons.chevron_right_rounded,
              color: AppColors.buttonLogin,
              size: 28.sp,
            ),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  String _getHeaderText() {
    if (mode == CalendarMode.day) {
      return DateFormat('MMMM yyyy').format(viewDate);
    } else if (mode == CalendarMode.month) {
      return DateFormat('yyyy').format(viewDate);
    } else {
      int startYear = (viewDate.year ~/ 12) * 12;
      return "$startYear - ${startYear + 11}";
    }
  }

  void _onPrevious() {
    setState(() {
      if (mode == CalendarMode.day) {
        viewDate = DateTime(viewDate.year, viewDate.month - 1);
      } else if (mode == CalendarMode.month) {
        viewDate = DateTime(viewDate.year - 1, viewDate.month);
      } else {
        viewDate = DateTime(viewDate.year - 12, viewDate.month);
      }
    });
  }

  void _onNext() {
    setState(() {
      if (mode == CalendarMode.day) {
        viewDate = DateTime(viewDate.year, viewDate.month + 1);
      } else if (mode == CalendarMode.month) {
        viewDate = DateTime(viewDate.year + 1, viewDate.month);
      } else {
        viewDate = DateTime(viewDate.year + 12, viewDate.month);
      }
    });
  }

  Widget _buildBody() {
    if (mode == CalendarMode.day) return _buildDayView();
    if (mode == CalendarMode.month) return _buildMonthView();
    return _buildYearView();
  }

  Widget _buildDayView() {
    final days = _daysInMonth(viewDate);
    final weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weekDays
              .map(
                (day) => Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.h, bottom: 2.h),
                      child: Text(
                        day,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        SizedBox(height: 2.h),
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: days.length,
          itemBuilder: (context, index) {
            final date = days[index];
            if (date == null) return const SizedBox.shrink();

            final bool isSelected = _isSameDay(date, selectedDate);
            final bool isToday = _isSameDay(date, DateTime.now());

            return _buildCircleItem(
              text: date.day.toString(),
              isSelected: isSelected,
              isToday: isToday,
              onTap: () {
                setState(() {
                  selectedDate = date;
                  viewDate = date;
                });
                widget.onChanged?.call(date);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildMonthView() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.2,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        final month = index + 1;
        final bool isSelected =
            selectedDate.month == month && selectedDate.year == viewDate.year;

        return _buildRectItem(
          text: DateFormat('MMMM').format(DateTime(2024, month)),
          isSelected: isSelected,
          onTap: () {
            setState(() {
              viewDate = DateTime(viewDate.year, month);
              mode = CalendarMode.day;
            });
          },
        );
      },
    );
  }

  Widget _buildYearView() {
    int startYear = (viewDate.year ~/ 12) * 12;
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.2,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        final year = startYear + index;
        final bool isSelected = selectedDate.year == year;

        return _buildRectItem(
          text: year.toString(),
          isSelected: isSelected,
          onTap: () {
            setState(() {
              viewDate = DateTime(year, viewDate.month);
              mode = CalendarMode.month;
            });
          },
        );
      },
    );
  }

  Widget _buildCircleItem({
    required String text,
    required bool isSelected,
    required bool isToday,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? AppColors.buttonLogin : Colors.transparent,
          border: isToday && !isSelected
              ? Border.all(color: AppColors.buttonLogin, width: 1.5)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.buttonLogin.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: isSelected || isToday
                  ? FontWeight.bold
                  : FontWeight.w500,
              color: isSelected
                  ? Colors.white
                  : (isToday ? AppColors.buttonLogin : Colors.black87),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRectItem({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: isSelected
              ? AppColors.buttonLogin
              : AppColors.buttonLogin.withOpacity(0.05),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.buttonLogin.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.buttonLogin,
            ),
          ),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
