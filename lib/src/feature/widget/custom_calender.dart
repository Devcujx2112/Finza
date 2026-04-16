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

class _CustomCalendarState extends State<CustomCalendar> {
  late DateTime selectedDate;
  late DateTime currentDate;
  CalendarMode mode = CalendarMode.day;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    currentDate = widget.initialDate;
  }

  List<DateTime> _daysInMonth(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    final lastDay = DateTime(date.year, date.month + 1, 0);
    final days = <DateTime>[];
    for (int i = firstDay.day; i <= lastDay.day; i++) {
      days.add(DateTime(date.year, date.month, i));
    }
    return days;
  }

  List<dynamic> getItems() {
    switch (mode) {
      case CalendarMode.day:
        return _daysInMonth(currentDate);
      case CalendarMode.month:
        return List.generate(12, (i) => i + 1);
      case CalendarMode.year:
        return List.generate(100, (i) => DateTime.now().year - i);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black12)],
      ),
      child: Column(
        spacing: 5.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          Flexible(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.buttonLogin,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                if (mode == CalendarMode.day) {
                  mode = CalendarMode.month;
                } else if (mode == CalendarMode.month) {
                  mode = CalendarMode.year;
                }
              });
            },
            child: Text(
              mode == CalendarMode.day
                  ? "${DateFormat('MMM').format(currentDate)} ${currentDate.year}"
                  : mode == CalendarMode.month
                  ? DateFormat('yyyy').format(currentDate)
                  : "${currentDate.year}",
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.backgroundMenu,
              ),
            ),
          ),
          Icon(
            Icons.calendar_today_sharp,
            color: AppColors.backgroundMenu,
            size: 22.sp,
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final items = getItems();

    if (mode == CalendarMode.day) {
      return GridView.builder(
        padding: EdgeInsetsGeometry.all(10.w),
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisExtent: 40,
        ),
        itemCount: items.length,
        itemBuilder: (_, i) => _buildItem(items[i]),
      );
    }

    return GridView.builder(
      padding: EdgeInsetsGeometry.all(10.w),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisExtent: 40,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => _buildItem(items[i]),
    );
  }

  Widget _buildItem(dynamic item) {
    bool isSelected = false;

    if (mode == CalendarMode.day) {
      DateTime day = item;
      isSelected =
          selectedDate.year == day.year &&
          selectedDate.month == day.month &&
          selectedDate.day == day.day;
    }

    if (mode == CalendarMode.month) {
      isSelected =
          selectedDate.month == item && currentDate.year == selectedDate.year;
    }

    if (mode == CalendarMode.year) {
      isSelected = selectedDate.year == item;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          if (mode == CalendarMode.day) {
            selectedDate = item;
            currentDate = item;
            widget.onChanged?.call(item);
          } else if (mode == CalendarMode.month) {
            currentDate = DateTime(currentDate.year, item);
            mode = CalendarMode.day;
          } else {
            currentDate = DateTime(item, currentDate.month);
            mode = CalendarMode.month;
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.all(6),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.buttonLogin : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          mode == CalendarMode.day
              ? "${item.day}"
              : (mode == CalendarMode.month
                    ? DateFormat('MMM').format(DateTime(2000, item as int))
                    : "$item"),
          style: TextStyle(color: isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
