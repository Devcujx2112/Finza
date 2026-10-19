// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_expenses_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonthlyExpensesModel _$MonthlyExpensesModelFromJson(
  Map<String, dynamic> json,
) => MonthlyExpensesModel(
  monthlyExpenseId: (json['monthlyExpenseId'] as num?)?.toInt(),
  total: (json['total'] as num?)?.toInt(),
  budgetId: (json['budgetId'] as num?)?.toInt(),
  note: json['note'] as String?,
  periodStart: json['periodStart'] as String?,
);

Map<String, dynamic> _$MonthlyExpensesModelToJson(
  MonthlyExpensesModel instance,
) => <String, dynamic>{
  'monthlyExpenseId': instance.monthlyExpenseId,
  'total': instance.total,
  'budgetId': instance.budgetId,
  'note': instance.note,
  'periodStart': instance.periodStart,
};
