// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setup_user_budget_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SetupUserBudgetRequestModel _$SetupUserBudgetRequestModelFromJson(
  Map<String, dynamic> json,
) => SetupUserBudgetRequestModel(
  typeCost: json['typeCost'] as String,
  nameCost: json['nameCost'] as String,
  amount: (json['amount'] as num).toInt(),
  categoriesName: json['categoriesName'] as String,
  stringIcon: json['stringIcon'] as String,
);

Map<String, dynamic> _$SetupUserBudgetRequestModelToJson(
  SetupUserBudgetRequestModel instance,
) => <String, dynamic>{
  'typeCost': instance.typeCost,
  'nameCost': instance.nameCost,
  'amount': instance.amount,
  'categoriesName': instance.categoriesName,
  'stringIcon': instance.stringIcon,
};
