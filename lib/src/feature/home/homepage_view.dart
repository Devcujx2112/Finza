import 'package:app/gen/assets.gen.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/router/router_name.dart';
import 'package:app/src/core/color/app_colors.dart';
import 'package:app/src/core/widget/adaptive_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomepageView extends StatefulWidget {
  const HomepageView({super.key});

  @override
  State<HomepageView> createState() => _HomepageViewState();
}

class _HomepageViewState extends State<HomepageView> with AdaptivePage {
  static const double _budgetProgress = 0.3;

  int _selectedDateIndex = 3;

  final List<_DateItem> _dateItems = const [
    _DateItem(day: 'Sun', date: '21'),
    _DateItem(day: 'Mon', date: '22'),
    _DateItem(day: 'Tue', date: '23'),
    _DateItem(day: 'Wed', date: '24'),
    _DateItem(day: 'Thu', date: '25'),
    _DateItem(day: 'Fri', date: '26'),
    _DateItem(day: 'Sat', date: '27'),
  ];

  final List<_ScheduleItem> _scheduleItems = const [
    _ScheduleItem(
      startTime: '11:35',
      endTime: '13:05',
      title: 'Mathematics',
      description: 'Chapter 1: Introduction',
      location: 'Room 6-205',
      person: 'Brooklyn Williamson',
      isPrimary: true,
    ),
    _ScheduleItem(
      startTime: '13:15',
      endTime: '14:45',
      title: 'Biology',
      description: 'Chapter 3: Animal Kingdom',
      location: 'Room 2-168',
      person: 'Julie Watson',
      isPrimary: false,
    ),
    _ScheduleItem(
      startTime: '15:10',
      endTime: '16:40',
      title: 'Geography',
      description: 'Chapter 2: Economy USA',
      location: 'Room 1-403',
      person: 'Jenny Alexander',
      isPrimary: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return adaptiveBody(context);
  }

  @override
  Widget mobileLandscapeBody(BuildContext context, Size size) =>
      _buildScreen(context);

  @override
  Widget mobilePortraitBody(BuildContext context, Size size) =>
      _buildScreen(context);

  @override
  Widget tabletLandscapeBody(BuildContext context, Size size) =>
      _buildScreen(context);

  @override
  Widget tabletPortraitBody(BuildContext context, Size size) =>
      _buildScreen(context);

  Widget _buildScreen(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: _pageBackground(isDark),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 128.h),
          physics: const BouncingScrollPhysics(),
          children: [
            _buildHeader(isDark),
            SizedBox(height: 18.h),
            _buildFinancialOverview(isDark),
            SizedBox(height: 18.h),
            _buildScheduleSection(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    final appLocal = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi Duong',
                style: GoogleFonts.poppins(
                  color: _primaryText(isDark),
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                appLocal?.goodMorning ?? 'Good Morning',
                style: GoogleFonts.poppins(
                  color: _secondaryText(isDark),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        _buildNotificationButton(isDark),
      ],
    );
  }

  Widget _buildNotificationButton(bool isDark) {
    return GestureDetector(
      onTap: () => Get.toNamed(RouterName.notification),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 44.r,
        width: 44.r,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _surfaceColor(isDark),
          shape: BoxShape.circle,
          border: Border.all(color: _borderColor(isDark), width: 1.w),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withValues(
                alpha: isDark ? 0.18 : 0.05,
              ),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Assets.images.icNotification.svg(width: 22.r, height: 22.r),
      ),
    );
  }

  Widget _buildFinancialOverview(bool isDark) {
    final appLocal = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBalanceHero(isDark),
        SizedBox(height: 18.h),
        Row(
          children: [
            Expanded(
              child: _buildFinanceStatCard(
                isDark: isDark,
                label: appLocal?.totalBalance ?? 'Total Balance',
                value: '\$7,783.00',
                icon: Icons.trending_up_rounded,
                iconColor: AppColors.primarySecondaryColor,
                accentColor: AppColors.homeBalanceSoft,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildFinanceStatCard(
                isDark: isDark,
                label: appLocal?.totalExpense ?? 'Total Expense',
                value: '-\$1,187.40',
                icon: Icons.trending_down_rounded,
                iconColor: AppColors.homeAccentBlue,
                accentColor: AppColors.homeExpenseSoft,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBalanceHero(bool isDark) {
    final appLocal = AppLocalizations.of(context);
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.homeHeroStart, AppColors.homeHeroEnd],
        ),
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.homeHeroEnd.withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appLocal?.totalBalance ?? 'Total Balance',
                      style: GoogleFonts.poppins(
                        color: AppColors.white70,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      '\$7,783.00',
                      style: GoogleFonts.poppins(
                        color: AppColors.whiteColor,
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 42.r,
                width: 42.r,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: AppColors.whiteColor.withValues(alpha: 0.16),
                    width: 1.w,
                  ),
                ),
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  color: AppColors.whiteColor,
                  size: 22.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 22.h),
          Row(
            children: [
              Expanded(child: _buildBudgetProgress()),
              SizedBox(width: 14.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    appLocal?.budget ?? 'Budget',
                    style: GoogleFonts.poppins(
                      color: AppColors.white70,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '\$20,000.00',
                    style: GoogleFonts.poppins(
                      color: AppColors.whiteColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
            decoration: BoxDecoration(
              color: AppColors.whiteColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: AppColors.whiteColor.withValues(alpha: 0.12),
                width: 1.w,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  color: AppColors.primarySecondaryColor,
                  size: 18.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    appLocal?.spendingProgressNotice(30) ??
                        '30% of your expenses. Looks good.',
                    style: GoogleFonts.poppins(
                      color: AppColors.whiteColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
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

  Widget _buildBudgetProgress() {
    final appLocal = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              appLocal?.spendingProgress ?? 'Spending progress',
              style: GoogleFonts.poppins(
                color: AppColors.white70,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              '30%',
              style: GoogleFonts.poppins(
                color: AppColors.whiteColor,
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: 9.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(999.r),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: _budgetProgress),
            duration: const Duration(milliseconds: 520),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return LinearProgressIndicator(
                value: value,
                minHeight: 8.h,
                backgroundColor: AppColors.whiteColor.withValues(alpha: 0.16),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primarySecondaryColor,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFinanceStatCard({
    required bool isDark,
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color accentColor,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: _surfaceColor(isDark),
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: _borderColor(isDark), width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 34.r,
            width: 34.r,
            decoration: BoxDecoration(
              color: isDark ? AppColors.homeDarkSoftSurface : accentColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: iconColor, size: 18.sp),
          ),
          SizedBox(height: 12.h),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              color: _secondaryText(isDark),
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: GoogleFonts.poppins(
                color: _primaryText(isDark),
                fontSize: 19.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleSection(bool isDark) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: _surfaceColor(isDark),
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: _borderColor(isDark), width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Builder(
            builder: (context) {
              final appLocal = AppLocalizations.of(context);
              return Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appLocal?.schedule ?? 'Schedule',
                          style: GoogleFonts.poppins(
                            color: _primaryText(isDark),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.1,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          appLocal?.itemsPlannedToday(_scheduleItems.length) ??
                              '${_scheduleItems.length} items planned today',
                          style: GoogleFonts.poppins(
                            color: _secondaryText(isDark),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 36.r,
                    width: 36.r,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.homeDarkSoftSurface
                          : AppColors.homeSoftSurface,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.tune_rounded,
                      color: AppColors.primarySecondaryColor,
                      size: 20.sp,
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 16.h),
          _buildDateSelector(isDark),
          SizedBox(height: 18.h),
          Builder(
            builder: (context) {
              final appLocal = AppLocalizations.of(context);
              return Row(
                children: [
                  SizedBox(
                    width: 58.w,
                    child: Text(
                      appLocal?.time ?? 'Time',
                      style: GoogleFonts.poppins(
                        color: _secondaryText(isDark),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    appLocal?.agenda ?? 'Agenda',
                    style: GoogleFonts.poppins(
                      color: _secondaryText(isDark),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 6.h),
          ...List.generate(_scheduleItems.length, (index) {
            return _buildScheduleItem(
              item: _scheduleItems[index],
              isDark: isDark,
              isLast: index == _scheduleItems.length - 1,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDateSelector(bool isDark) {
    return SizedBox(
      height: 72.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _dateItems.length,
        separatorBuilder: (_, __) => SizedBox(width: 10.w),
        itemBuilder: (context, index) {
          final item = _dateItems[index];
          final isSelected = _selectedDateIndex == index;

          return GestureDetector(
            onTap: () => setState(() => _selectedDateIndex = index),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              width: 48.w,
              padding: EdgeInsets.symmetric(vertical: 9.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.homeAccentOrange
                    : _softSurfaceColor(isDark),
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(
                  color: isSelected
                      ? AppColors.homeAccentOrange
                      : _borderColor(isDark),
                  width: 1.w,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.day,
                    style: GoogleFonts.poppins(
                      color: isSelected
                          ? AppColors.whiteColor
                          : _secondaryText(isDark),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    item.date,
                    style: GoogleFonts.poppins(
                      color: isSelected
                          ? AppColors.whiteColor
                          : _primaryText(isDark),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScheduleItem({
    required _ScheduleItem item,
    required bool isDark,
    required bool isLast,
  }) {
    final itemColor = item.isPrimary
        ? AppColors.primarySecondaryColor
        : _softSurfaceColor(isDark);
    final titleColor = item.isPrimary
        ? AppColors.whiteColor
        : _primaryText(isDark);
    final metaColor = item.isPrimary
        ? AppColors.whiteColor
        : _secondaryText(isDark);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 58.w,
            child: Padding(
              padding: EdgeInsets.only(top: 18.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.startTime,
                    style: GoogleFonts.poppins(
                      color: _primaryText(isDark),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    item.endTime,
                    style: GoogleFonts.poppins(
                      color: _secondaryText(isDark),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 18.w,
            child: Column(
              children: [
                SizedBox(height: 21.h),
                Container(
                  height: 10.r,
                  width: 10.r,
                  decoration: BoxDecoration(
                    color: item.isPrimary
                        ? AppColors.primarySecondaryColor
                        : AppColors.homeTimelineTrack,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.w,
                      margin: EdgeInsets.symmetric(vertical: 5.h),
                      color: isDark
                          ? AppColors.white10
                          : AppColors.homeTimelineTrack,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 12.h),
              child: Container(
                padding: EdgeInsets.all(15.w),
                decoration: BoxDecoration(
                  color: itemColor,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: item.isPrimary
                        ? AppColors.transparentColor
                        : _borderColor(isDark),
                    width: 1.w,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: titleColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.more_horiz_rounded,
                          color: metaColor,
                          size: 20.sp,
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: metaColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.35,
                      ),
                    ),
                    SizedBox(height: 13.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        _buildScheduleMeta(
                          icon: Icons.location_on_outlined,
                          text: item.location,
                          foregroundColor: metaColor,
                          backgroundColor: item.isPrimary
                              ? AppColors.whiteColor.withValues(alpha: 0.12)
                              : _surfaceColor(isDark),
                        ),
                        _buildScheduleMeta(
                          icon: Icons.person_outline_rounded,
                          text: item.person,
                          foregroundColor: metaColor,
                          backgroundColor: item.isPrimary
                              ? AppColors.whiteColor.withValues(alpha: 0.12)
                              : _surfaceColor(isDark),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleMeta({
    required IconData icon,
    required String text,
    required Color foregroundColor,
    required Color backgroundColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(
          color: Colors.white, // Màu viền trắng
          width: 1.w, // Độ dày viền (có thể chỉnh theo ý bạn)
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: foregroundColor, size: 14.sp),
          SizedBox(width: 5.w),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 146.w),
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: foregroundColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _pageBackground(bool isDark) =>
      isDark ? AppColors.homeDarkBackground : AppColors.homeLightBackground;

  Color _surfaceColor(bool isDark) =>
      isDark ? AppColors.homeDarkSurface : AppColors.homeSurface;

  Color _softSurfaceColor(bool isDark) =>
      isDark ? AppColors.homeDarkSoftSurface : AppColors.homeSoftSurface;

  Color _primaryText(bool isDark) =>
      isDark ? AppColors.primaryColor : AppColors.colorMenuBar;

  Color _secondaryText(bool isDark) =>
      isDark ? AppColors.homeDarkMutedText : AppColors.homeMutedText;

  Color _borderColor(bool isDark) =>
      isDark ? AppColors.white10 : AppColors.homeTimelineTrack;
}

class _DateItem {
  const _DateItem({required this.day, required this.date});

  final String day;
  final String date;
}

class _ScheduleItem {
  const _ScheduleItem({
    required this.startTime,
    required this.endTime,
    required this.title,
    required this.description,
    required this.location,
    required this.person,
    required this.isPrimary,
  });

  final String startTime;
  final String endTime;
  final String title;
  final String description;
  final String location;
  final String person;
  final bool isPrimary;
}
