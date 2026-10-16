// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BudgetModel _$BudgetModelFromJson(Map<String, dynamic> json) => BudgetModel(
  budgetId: (json['budgetId'] as num?)?.toInt(),
  spendingConfigId: (json['spendingConfigId'] as num?)?.toInt(),
  typeCost: json['typeCost'] as String?,
  nameCost: json['nameCost'] as String?,
  amount: (json['amount'] as num?)?.toInt(),
);

Map<String, dynamic> _$BudgetModelToJson(BudgetModel instance) =>
    <String, dynamic>{
      'budgetId': instance.budgetId,
      'spendingConfigId': instance.spendingConfigId,
      'typeCost': instance.typeCost,
      'nameCost': instance.nameCost,
      'amount': instance.amount,
    };
