// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spending_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpendingConfigModel _$SpendingConfigModelFromJson(Map<String, dynamic> json) =>
    SpendingConfigModel(
      spendingConfigId: (json['spendingConfigId'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      spendingMethod: json['spendingMethod'] as String?,
      dayStarted: json['dayStarted'] as String?,
      isLastDayOfMonth: json['isLastDayOfMonth'] as bool?,
      totalInCome: (json['totalInCome'] as num?)?.toInt(),
      monthlySaving: (json['monthlySaving'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SpendingConfigModelToJson(
  SpendingConfigModel instance,
) => <String, dynamic>{
  'spendingConfigId': instance.spendingConfigId,
  'userId': instance.userId,
  'spendingMethod': instance.spendingMethod,
  'dayStarted': instance.dayStarted,
  'isLastDayOfMonth': instance.isLastDayOfMonth,
  'totalInCome': instance.totalInCome,
  'monthlySaving': instance.monthlySaving,
};
