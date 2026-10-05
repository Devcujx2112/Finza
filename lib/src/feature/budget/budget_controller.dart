import 'package:app/src/feature/budget/models/expense_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BudgetController extends GetxController {
  final Rx<DateTime> selectedMonth = DateTime(2026, 9, 1).obs;
  final RxDouble monthlyBudget = 15000000.0.obs; // 15.000.000 ₫

  final RxList<ExpenseItem> expenses = <ExpenseItem>[].obs;
  final RxSet<String> expandedDays = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _seedInitialData();
  }

  void _seedInitialData() {
    final now = DateTime(2026, 9, 7);

    final initialExpenses = [
      // 07/09 (Today) - Total 150.000 ₫
      ExpenseItem(
        id: '1',
        amount: 35000,
        categoryId: 'food',
        date: DateTime(2026, 9, 7, 7, 30),
        note: 'Ăn sáng',
      ),
      ExpenseItem(
        id: '2',
        amount: 65000,
        categoryId: 'transport',
        date: DateTime(2026, 9, 7, 8, 15),
        note: 'Grab',
      ),
      ExpenseItem(
        id: '3',
        amount: 50000,
        categoryId: 'food',
        date: DateTime(2026, 9, 7, 12, 00),
        note: 'Ăn trưa',
      ),

      // 06/09 - Total 450.000 ₫
      ExpenseItem(
        id: '4',
        amount: 450000,
        categoryId: 'shopping',
        date: DateTime(2026, 9, 6, 17, 45),
        note: 'Mua sắm siêu thị',
      ),

      // 05/09 - Total 1.250.000 ₫
      ExpenseItem(
        id: '5',
        amount: 250000,
        categoryId: 'bills',
        date: DateTime(2026, 9, 5, 14, 20),
        note: 'Internet & Điện thoại',
      ),
      ExpenseItem(
        id: '6',
        amount: 1000000,
        categoryId: 'housing',
        date: DateTime(2026, 9, 5, 10, 00),
        note: 'Bảo trì thiết bị',
      ),

      // 02/09 - Total 2.700.000 ₫
      ExpenseItem(
        id: '7',
        amount: 2700000,
        categoryId: 'education',
        date: DateTime(2026, 9, 2, 9, 00),
        note: 'Khóa học & Sách vở',
      ),

      // 01/09 - Total 3.000.000 ₫
      ExpenseItem(
        id: '8',
        amount: 3000000,
        categoryId: 'housing',
        date: DateTime(2026, 9, 1, 8, 00),
        note: 'Tiền thuê nhà',
      ),
    ];

    expenses.assignAll(initialExpenses);

    // Expand today by default
    final todayKey = DateFormat('yyyy-MM-dd').format(now);
    expandedDays.add(todayKey);
  }

  // --- Filtered Data Getters ---

  List<ExpenseItem> get filteredExpenses {
    return expenses.where((item) {
      return item.date.year == selectedMonth.value.year &&
          item.date.month == selectedMonth.value.month;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  double get totalSpent {
    return filteredExpenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  double get remainingBudget {
    return monthlyBudget.value - totalSpent;
  }

  double get budgetProgressRatio {
    if (monthlyBudget.value <= 0) return 0.0;
    final ratio = totalSpent / monthlyBudget.value;
    return ratio.clamp(0.0, 1.0);
  }

  double get budgetProgressPercentage {
    return double.parse((budgetProgressRatio * 100).toStringAsFixed(1));
  }

  String get formattedPercentageLabel {
    final pct = budgetProgressPercentage;
    if (pct == pct.roundToDouble()) {
      return '${pct.toInt()}% ngân sách đã sử dụng';
    }
    return '$pct% ngân sách đã sử dụng';
  }

  double get maxDailyTotalInMonth {
    final groups = groupedExpensesByDay;
    if (groups.isEmpty) return 1.0;
    double maxVal = 0.0;
    for (final group in groups.values) {
      if (group.totalAmount > maxVal) {
        maxVal = group.totalAmount;
      }
    }
    return maxVal > 0 ? maxVal : 1.0;
  }

  Map<String, DailyExpensesGroup> get groupedExpensesByDay {
    final Map<String, List<ExpenseItem>> groups = {};

    for (final item in filteredExpenses) {
      final key = DateFormat('yyyy-MM-dd').format(item.date);
      if (!groups.containsKey(key)) {
        groups[key] = [];
      }
      groups[key]!.add(item);
    }

    // Include 04/09 if in Sept 2026 as requested in prompt example
    if (selectedMonth.value.year == 2026 && selectedMonth.value.month == 9) {
      const zeroDayKey = '2026-09-04';
      if (!groups.containsKey(zeroDayKey)) {
        groups[zeroDayKey] = [];
      }
    }

    final Map<String, DailyExpensesGroup> result = {};
    final now = DateTime.now();
    final todayKey = DateFormat('yyyy-MM-dd').format(now);
    final yesterdayKey = DateFormat('yyyy-MM-dd').format(
      now.subtract(const Duration(days: 1)),
    );

    final sortedKeys = groups.keys.toList()..sort((a, b) => b.compareTo(a));

    for (final key in sortedKeys) {
      final items = groups[key]!;
      final date = items.isNotEmpty ? items.first.date : DateTime.parse(key);
      final total = items.fold(0.0, (sum, i) => sum + i.amount);

      String displayTitle;
      if (key == todayKey) {
        displayTitle = 'Hôm nay · ${DateFormat('dd/MM').format(date)}';
      } else if (key == yesterdayKey) {
        displayTitle = 'Hôm qua · ${DateFormat('dd/MM').format(date)}';
      } else {
        displayTitle = DateFormat('dd/MM').format(date);
      }

      result[key] = DailyExpensesGroup(
        dateKey: key,
        date: date,
        displayTitle: displayTitle,
        totalAmount: total,
        items: items,
      );
    }

    return result;
  }

  // --- Actions ---

  void changeMonth(int deltaMonths) {
    final current = selectedMonth.value;
    final newMonth = DateTime(current.year, current.month + deltaMonths, 1);
    selectedMonth.value = newMonth;
  }

  void setSelectedMonth(DateTime date) {
    selectedMonth.value = DateTime(date.year, date.month, 1);
  }

  void updateBudget(double newBudget) {
    if (newBudget >= 0) {
      monthlyBudget.value = newBudget;
    }
  }

  void toggleDayExpanded(String dateKey) {
    if (expandedDays.contains(dateKey)) {
      expandedDays.remove(dateKey);
    } else {
      expandedDays.add(dateKey);
    }
  }

  bool isDayExpanded(String dateKey) {
    return expandedDays.contains(dateKey);
  }

  void addExpense({
    required double amount,
    required String categoryId,
    required DateTime date,
    required String note,
  }) {
    final newExpense = ExpenseItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      categoryId: categoryId,
      date: date,
      note: note.trim(),
    );

    expenses.add(newExpense);

    final key = DateFormat('yyyy-MM-dd').format(date);
    expandedDays.add(key);

    if (date.year != selectedMonth.value.year ||
        date.month != selectedMonth.value.month) {
      selectedMonth.value = DateTime(date.year, date.month, 1);
    }
  }

  void editExpense({
    required String id,
    required double amount,
    required String categoryId,
    required DateTime date,
    required String note,
  }) {
    final index = expenses.indexWhere((e) => e.id == id);
    if (index != -1) {
      expenses[index] = ExpenseItem(
        id: id,
        amount: amount,
        categoryId: categoryId,
        date: date,
        note: note.trim(),
      );
      expenses.refresh();
    }
  }

  void deleteExpense(String id) {
    expenses.removeWhere((e) => e.id == id);
  }

  // --- Formatting Helpers ---

  String formatCurrency(double amount) {
    if (amount == 0) return '0 ₫';
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );
    return formatter.format(amount).replaceAll('VND', '₫');
  }

  String formatMonthHeader(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    return 'Tháng $month, ${date.year}';
  }
}

class DailyExpensesGroup {
  final String dateKey;
  final DateTime date;
  final String displayTitle;
  final double totalAmount;
  final List<ExpenseItem> items;

  DailyExpensesGroup({
    required this.dateKey,
    required this.date,
    required this.displayTitle,
    required this.totalAmount,
    required this.items,
  });
}
