import 'package:app/l10n/app_localizations.dart';
import 'package:app/src/core/color/app_colors.dart';
import 'package:app/src/core/widget/adaptive_page.dart';
import 'package:app/src/feature/budget/budget_controller.dart';
import 'package:app/src/feature/budget/models/expense_model.dart';
import 'package:app/src/feature/main_controller/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BudgetView extends StatefulWidget {
  const BudgetView({super.key});

  @override
  State<BudgetView> createState() => _BudgetViewState();
}

class _BudgetViewState extends State<BudgetView> with AdaptivePage {
  late final BudgetController controller;
  MainController? mainController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(BudgetController());
    if (Get.isRegistered<MainController>()) {
      mainController = Get.find<MainController>();
    }
  }

  bool _isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ||
        (mainController?.isDarkMode ?? false);
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
    final isDark = _isDark(context);

    return Scaffold(
      backgroundColor: _pageBackground(isDark),
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          final hasExpenses = controller.filteredExpenses.isNotEmpty;

          return ListView(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 140.h),
            physics: const BouncingScrollPhysics(),
            children: [
              _buildHeader(isDark),
              SizedBox(height: 18.h),
              _buildFinancialSummaryHero(isDark),
              SizedBox(height: 18.h),
              _buildSpendingHistorySection(isDark, hasExpenses),
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
            onPressed: () => _openExpenseBottomSheet(context),
            elevation: 3,
            backgroundColor: AppColors.primarySecondaryColor,
            shape: const CircleBorder(),
            child: Icon(
              Icons.add_rounded,
              color: AppColors.whiteColor,
              size: 26.sp,
            ),
          ),
        ),
      ),
    );
  }

  // --- HEADER MATCHING HOME SYSTEM ---

  Widget _buildHeader(bool isDark) {
    final appLocal = AppLocalizations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appLocal?.expensesTitle ?? 'Chi tiêu',
                style: GoogleFonts.poppins(
                  color: _primaryText(isDark),
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                appLocal?.personalFinanceTracking ?? 'Theo dõi tài chính cá nhân',
                style: GoogleFonts.poppins(
                  color: _secondaryText(isDark),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        // Month Selector Pill matching Home Header Controls
        Container(
          decoration: BoxDecoration(
            color: _surfaceColor(isDark),
            borderRadius: BorderRadius.circular(20.r),
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => controller.changeMonth(-1),
                icon: Icon(
                  Icons.chevron_left_rounded,
                  color: _primaryText(isDark),
                  size: 20.sp,
                ),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.all(6.r),
                splashRadius: 16.r,
              ),
              GestureDetector(
                onTap: () => _pickMonth(context),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Obx(
                    () => Text(
                      controller.formatMonthHeader(
                        controller.selectedMonth.value,
                      ),
                      style: GoogleFonts.poppins(
                        color: _primaryText(isDark),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => controller.changeMonth(1),
                icon: Icon(
                  Icons.chevron_right_rounded,
                  color: _primaryText(isDark),
                  size: 20.sp,
                ),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.all(6.r),
                splashRadius: 16.r,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- MONTHLY FINANCIAL OVERVIEW HERO (REUSING HOME BALANCE HERO STYLE) ---

  Widget _buildFinancialSummaryHero(bool isDark) {
    return Obx(() {
      final totalSpentStr = controller.formatCurrency(controller.totalSpent);
      final budgetStr = controller.formatCurrency(
        controller.monthlyBudget.value,
      );
      final remainingStr = controller.formatCurrency(
        controller.remainingBudget,
      );
      final progressRatio = controller.budgetProgressRatio;
      final pctLabel = controller.formattedPercentageLabel;
      final isOverBudget = controller.remainingBudget < 0;

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
            // Top Amount Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)?.spent ?? 'Đã chi',
                        style: GoogleFonts.poppins(
                          color: AppColors.white70,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        totalSpentStr,
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
                // Icon Container
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

            // Stats Row: Progress bar & Budget & Remaining
            Row(
              children: [
                // Ngân sách
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)?.budget ?? 'Ngân sách',
                            style: GoogleFonts.poppins(
                              color: AppColors.white70,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          GestureDetector(
                            onTap: () => _showEditBudgetDialog(context),
                            child: Icon(
                              Icons.edit_rounded,
                              size: 13.sp,
                              color: AppColors.white70,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        budgetStr,
                        style: GoogleFonts.poppins(
                          color: AppColors.whiteColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 14.w),
                // Còn lại
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        AppLocalizations.of(context)?.remaining ?? 'Còn lại',
                        style: GoogleFonts.poppins(
                          color: AppColors.white70,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        remainingStr,
                        style: GoogleFonts.poppins(
                          color: isOverBudget
                              ? AppColors.notificationError
                              : AppColors.primarySecondaryColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Spending Progress Indicator
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)?.spendingProgress ?? 'Tiến độ chi tiêu',
                      style: GoogleFonts.poppins(
                        color: AppColors.white70,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${controller.budgetProgressPercentage.toInt()}%',
                      style: GoogleFonts.poppins(
                        color: AppColors.whiteColor,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999.r),
                  child: LinearProgressIndicator(
                    value: progressRatio,
                    minHeight: 8.h,
                    backgroundColor: AppColors.whiteColor.withValues(
                      alpha: 0.16,
                    ),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isOverBudget
                          ? AppColors.notificationError
                          : AppColors.primarySecondaryColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Status Badge Strip
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
                    isOverBudget
                        ? Icons.warning_amber_rounded
                        : Icons.check_circle_outline_rounded,
                    color: isOverBudget
                        ? AppColors.notificationError
                        : AppColors.primarySecondaryColor,
                    size: 18.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      pctLabel,
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
    });
  }

  // --- SPENDING HISTORY SECTION MATCHING HOME SCHEDULE SECTION ---

  Widget _buildSpendingHistorySection(bool isDark, bool hasExpenses) {
    final count = controller.filteredExpenses.length;

    // No wrapping card — use spacing + typography for hierarchy (anti card-in-card)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title Row — inline, no card wrapper
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)?.spendingHistory ?? 'Lịch sử chi tiêu',
                    style: GoogleFonts.poppins(
                      color: _primaryText(isDark),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    AppLocalizations.of(context)?.transactionsInMonth(count) ??
                        '$count giao dịch trong tháng',
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
                color: _softSurfaceColor(isDark),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.history_rounded,
                color: AppColors.primarySecondaryColor,
                size: 20.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),

        if (!hasExpenses)
          _buildEmptyState(isDark)
        else
          _buildDailySpendingList(isDark),
      ],
    );
  }

  // --- DAILY SPENDING LIST TIMELINE ---

  Widget _buildDailySpendingList(bool isDark) {
    final grouped = controller.groupedExpensesByDay;
    final groupsList = grouped.values.toList();

    return Column(
      children: List.generate(groupsList.length, (index) {
        final group = groupsList[index];
        final isLast = index == groupsList.length - 1;
        final isExpanded = controller.isDayExpanded(group.dateKey);
        final hasItems = group.items.isNotEmpty;

        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : 4.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Day header row: date left, total right ---
              InkWell(
                onTap: hasItems
                    ? () => controller.toggleDayExpanded(group.dateKey)
                    : null,
                borderRadius: BorderRadius.circular(12.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Row(
                    children: [
                      // Timeline dot
                      Container(
                        height: 8.r,
                        width: 8.r,
                        margin: EdgeInsets.only(right: 10.w),
                        decoration: BoxDecoration(
                          color: hasItems
                              ? AppColors.primarySecondaryColor
                              : _borderColor(isDark),
                          shape: BoxShape.circle,
                        ),
                      ),
                      // Day title
                      Expanded(
                        child: Text(
                          group.displayTitle,
                          style: GoogleFonts.poppins(
                            color: _primaryText(isDark),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      // Daily total — prominent
                      Text(
                        controller.formatCurrency(group.totalAmount),
                        style: GoogleFonts.poppins(
                          color: group.totalAmount > 0
                              ? _primaryText(isDark)
                              : _secondaryText(isDark),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (hasItems) ...[
                        SizedBox(width: 4.w),
                        Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: _secondaryText(isDark),
                          size: 18.sp,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // --- Expanded transaction rows inside a surface card ---
              if (isExpanded && hasItems)
                Container(
                  margin: EdgeInsets.only(left: 18.w, bottom: 8.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: _surfaceColor(isDark),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: _borderColor(isDark), width: 1.w),
                  ),
                  child: Column(
                    children: group.items.map((item) {
                      return _buildExpenseItemRow(item, isDark);
                    }).toList(),
                  ),
                ),

              // Subtle divider between days
              if (!isLast) Divider(height: 1, color: _borderColor(isDark)),
            ],
          ),
        );
      }),
    );
  }

  // --- SINGLE TRANSACTION ROW ---

  Widget _buildExpenseItemRow(ExpenseItem item, bool isDark) {
    final category = item.category;

    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 16.w),
        margin: EdgeInsets.symmetric(vertical: 4.h),
        decoration: BoxDecoration(
          color: AppColors.errorColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              AppLocalizations.of(context)?.delete ?? 'Xóa',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ),
            SizedBox(width: 4.w),
            Icon(
              Icons.delete_outline_rounded,
              color: Colors.white,
              size: 18.sp,
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        final appLocal = AppLocalizations.of(context);
        return await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text(
                  appLocal?.confirmDeleteTitle ?? 'Xác nhận xóa',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                content: Text(
                  appLocal?.confirmDeleteExpenseMessage(item.note) ??
                      'Bạn có chắc muốn xóa khoản chi "${item.note}"?',
                  style: GoogleFonts.poppins(),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: Text(appLocal?.cancel ?? 'Hủy'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: Text(
                      appLocal?.delete ?? 'Xóa',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ) ??
            false;
      },
      onDismissed: (_) {
        controller.deleteExpense(item.id);
        final appLocal = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              appLocal?.expenseDeletedMessage(item.note) ?? 'Đã xóa "${item.note}"',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: InkWell(
        onTap: () => _openExpenseBottomSheet(context, expenseToEdit: item),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 7.h),
          child: Row(
            children: [
              // Category Emoji Badge Container
              Container(
                width: 32.r,
                height: 32.r,
                decoration: BoxDecoration(
                  color: _softSurfaceColor(isDark),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(category.emoji, style: TextStyle(fontSize: 14.sp)),
              ),
              SizedBox(width: 10.w),

              // Title & Category Metadata
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.note.isNotEmpty ? item.note : category.name,
                      style: GoogleFonts.poppins(
                        color: _primaryText(isDark),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      '${category.name} • ${DateFormat('HH:mm').format(item.date)}',
                      style: GoogleFonts.poppins(
                        color: _secondaryText(isDark),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Amount — secondary to daily total
              Text(
                controller.formatCurrency(item.amount),
                style: GoogleFonts.poppins(
                  color: _secondaryText(isDark),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- EMPTY STATE MATCHING HOME DESIGN SYSTEM ---

  Widget _buildEmptyState(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
      decoration: BoxDecoration(
        color: _softSurfaceColor(isDark),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: _borderColor(isDark), width: 1.w),
      ),
      child: Column(
        children: [
          Container(
            height: 52.r,
            width: 52.r,
            decoration: BoxDecoration(
              color: AppColors.primarySecondaryColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text('💸', style: TextStyle(fontSize: 24.sp)),
          ),
          SizedBox(height: 14.h),
          Text(
            AppLocalizations.of(context)?.noExpensesYet ?? 'Chưa có khoản chi tiêu nào',
            style: GoogleFonts.poppins(
              color: _primaryText(isDark),
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            AppLocalizations.of(context)?.addExpensePrompt ??
                'Bắt đầu ghi lại chi tiêu để hiểu rõ\nhơn về thói quen sử dụng tiền của bạn.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: _secondaryText(isDark),
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
          SizedBox(height: 18.h),
          ElevatedButton.icon(
            onPressed: () => _openExpenseBottomSheet(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primarySecondaryColor,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 11.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
              elevation: 0,
            ),
            icon: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
            label: Text(
              AppLocalizations.of(context)?.addExpense ?? 'Thêm chi tiêu',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- DIALOGS & BOTTOM SHEETS ---

  void _pickMonth(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedMonth.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: AppLocalizations.of(context)?.selectMonth ?? 'Chọn tháng xem chi tiêu',
    );
    if (picked != null) {
      controller.setSelectedMonth(picked);
    }
  }

  void _showEditBudgetDialog(BuildContext context) {
    final isDark = _isDark(context);
    final textController = TextEditingController(
      text: controller.monthlyBudget.value.toInt().toString(),
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _surfaceColor(isDark),
        title: Text(
          AppLocalizations.of(context)?.changeMonthlyBudgetTitle ?? 'Thay đổi ngân sách tháng',
          style: GoogleFonts.poppins(
            color: _primaryText(isDark),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: textController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: GoogleFonts.poppins(color: _primaryText(isDark)),
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)?.budgetAmountLabel ?? 'Số tiền ngân sách (₫)',
            labelStyle: GoogleFonts.poppins(color: _secondaryText(isDark)),
            hintText: '15000000',
            suffixText: '₫',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              AppLocalizations.of(context)?.cancel ?? 'Hủy',
              style: GoogleFonts.poppins(color: _secondaryText(isDark)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final newVal = double.tryParse(textController.text) ?? 0;
              if (newVal > 0) {
                controller.updateBudget(newVal);
              }
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primarySecondaryColor,
            ),
            child: Text(
              AppLocalizations.of(context)?.save ?? 'Lưu',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // --- ADD / EDIT EXPENSE BOTTOM SHEET ---

  void _openExpenseBottomSheet(
    BuildContext context, {
    ExpenseItem? expenseToEdit,
  }) {
    final isEditing = expenseToEdit != null;
    final amountController = TextEditingController(
      text: isEditing ? expenseToEdit.amount.toInt().toString() : '',
    );
    final noteController = TextEditingController(
      text: isEditing ? expenseToEdit.note : '',
    );

    String selectedCategoryId = isEditing ? expenseToEdit.categoryId : 'food';
    DateTime selectedDate = isEditing ? expenseToEdit.date : DateTime.now();

    final categories = ExpenseCategory.defaultCategories;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            final isDark = _isDark(sheetContext);
            final sheetBg = _surfaceColor(isDark);
            final primaryTextColor = _primaryText(isDark);
            final secondaryTextColor = _secondaryText(isDark);
            final inputBg = _softSurfaceColor(isDark);

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                ),
                decoration: BoxDecoration(
                  color: sheetBg,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28.r),
                  ),
                ),
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Handle Pill
                      Center(
                        child: Container(
                          width: 36.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: secondaryTextColor.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Title Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isEditing
                                ? (AppLocalizations.of(sheetContext)?.editExpense ?? 'Sửa chi tiêu')
                                : (AppLocalizations.of(sheetContext)?.addExpense ?? 'Thêm chi tiêu'),
                            style: GoogleFonts.poppins(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: primaryTextColor,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(sheetContext),
                            icon: Icon(
                              Icons.close_rounded,
                              color: secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // FIELD 1: Số tiền
                      Text(
                        AppLocalizations.of(sheetContext)?.amount ?? 'Số tiền',
                        style: GoogleFonts.poppins(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: secondaryTextColor,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        decoration: BoxDecoration(
                          color: inputBg,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: _borderColor(isDark),
                            width: 1.w,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 4.h,
                        ),
                        child: TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: GoogleFonts.poppins(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primarySecondaryColor,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '150.000',
                            hintStyle: GoogleFonts.poppins(
                              color: secondaryTextColor.withValues(alpha: 0.5),
                            ),
                            suffixText: '₫',
                            suffixStyle: GoogleFonts.poppins(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primarySecondaryColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // FIELD 2: Danh mục
                      Text(
                        AppLocalizations.of(sheetContext)?.category ?? 'Danh mục',
                        style: GoogleFonts.poppins(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: secondaryTextColor,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      SizedBox(
                        height: 40.h,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: categories.length,
                          separatorBuilder: (_, __) => SizedBox(width: 8.w),
                          itemBuilder: (context, catIdx) {
                            final cat = categories[catIdx];
                            final isSelected = cat.id == selectedCategoryId;
                            return ChoiceChip(
                              label: Text('${cat.emoji} ${cat.name}'),
                              selected: isSelected,
                              selectedColor: AppColors.homeAccentOrange,
                              backgroundColor: inputBg,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.r),
                                side: BorderSide(
                                  color: isSelected
                                      ? AppColors.homeAccentOrange
                                      : _borderColor(isDark),
                                  width: 1.w,
                                ),
                              ),
                              labelStyle: GoogleFonts.poppins(
                                color: isSelected
                                    ? Colors.white
                                    : primaryTextColor,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                fontSize: 12.sp,
                              ),
                              onSelected: (selected) {
                                if (selected) {
                                  setSheetState(() {
                                    selectedCategoryId = cat.id;
                                  });
                                }
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // FIELD 3: Ngày
                      Text(
                        AppLocalizations.of(sheetContext)?.date ?? 'Ngày',
                        style: GoogleFonts.poppins(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: secondaryTextColor,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: sheetContext,
                            initialDate: selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            setSheetState(() {
                              selectedDate = DateTime(
                                picked.year,
                                picked.month,
                                picked.day,
                                selectedDate.hour,
                                selectedDate.minute,
                              );
                            });
                          }
                        },
                        borderRadius: BorderRadius.circular(16.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 14.h,
                          ),
                          decoration: BoxDecoration(
                            color: inputBg,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: _borderColor(isDark),
                              width: 1.w,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_rounded,
                                    size: 18.sp,
                                    color: AppColors.primarySecondaryColor,
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    DateFormat(
                                      'dd/MM/yyyy',
                                    ).format(selectedDate),
                                    style: GoogleFonts.poppins(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: primaryTextColor,
                                    ),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: secondaryTextColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // FIELD 4: Ghi chú
                      Text(
                        AppLocalizations.of(sheetContext)?.note ?? 'Ghi chú',
                        style: GoogleFonts.poppins(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: secondaryTextColor,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        decoration: BoxDecoration(
                          color: inputBg,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: _borderColor(isDark),
                            width: 1.w,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: TextField(
                          controller: noteController,
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            color: primaryTextColor,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: AppLocalizations.of(sheetContext)?.noteHint ??
                                'Ăn trưa, Grab, Mua sắm...',
                            hintStyle: GoogleFonts.poppins(
                              color: secondaryTextColor.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 28.h),

                      // Primary CTA Button
                      SizedBox(
                        width: double.infinity,
                        height: 52.h,
                        child: ElevatedButton(
                          onPressed: () {
                            final rawAmount = double.tryParse(
                              amountController.text,
                            );
                            if (rawAmount == null || rawAmount <= 0) {
                              ScaffoldMessenger.of(sheetContext).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppLocalizations.of(sheetContext)?.invalidAmountError ??
                                        'Vui lòng nhập số tiền hợp lệ',
                                  ),
                                ),
                              );
                              return;
                            }

                            final note = noteController.text.trim();

                            if (isEditing) {
                              controller.editExpense(
                                id: expenseToEdit.id,
                                amount: rawAmount,
                                categoryId: selectedCategoryId,
                                date: selectedDate,
                                note: note,
                              );
                            } else {
                              controller.addExpense(
                                amount: rawAmount,
                                categoryId: selectedCategoryId,
                                date: selectedDate,
                                note: note,
                              );
                            }

                            Navigator.pop(sheetContext);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primarySecondaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            AppLocalizations.of(sheetContext)?.saveExpense ?? 'Lưu chi tiêu',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
