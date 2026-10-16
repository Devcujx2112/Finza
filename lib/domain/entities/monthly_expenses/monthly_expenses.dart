import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
class MonthlyExpenses extends Equatable {
  final int? monthlyExpenseId;
  final int? total;
  final int? budgetId;
  final String? note;
  final String? periodStart;

  const MonthlyExpenses({
    required this.monthlyExpenseId,
    required this.total,
    required this.budgetId,
    required this.note,
    required this.periodStart,
  });

  @override
  List<Object?> get props => [
    monthlyExpenseId,
    total,
    budgetId,
    note,
    periodStart,
  ];
}
