import 'package:app/domain/entities/monthly_expenses/monthly_expenses.dart';
import 'package:json_annotation/json_annotation.dart';

part 'monthly_expenses_model.g.dart';

@JsonSerializable()
class MonthlyExpensesModel {
  int? monthlyExpenseId;
  int? total;
  int? budgetId;
  String? note;
  String? periodStart;

  MonthlyExpensesModel({
    this.monthlyExpenseId,
    this.total,
    this.budgetId,
    this.note,
    this.periodStart,
  });

  factory MonthlyExpensesModel.fromJson(Map<String, dynamic> json) =>
      _$MonthlyExpensesModelFromJson(json);

  Map<String, dynamic> toJson() => _$MonthlyExpensesModelToJson(this);

  MonthlyExpenses toEntity() {
    return MonthlyExpenses(
      monthlyExpenseId: monthlyExpenseId,
      total: total,
      budgetId: budgetId,
      note: note,
      periodStart: periodStart,
    );
  }

  factory MonthlyExpensesModel.fromEntity(MonthlyExpenses entity) {
    return MonthlyExpensesModel(
      monthlyExpenseId: entity.monthlyExpenseId,
      total: entity.total,
      budgetId: entity.budgetId,
      note: entity.note,
      periodStart: entity.periodStart,
    );
  }
}
