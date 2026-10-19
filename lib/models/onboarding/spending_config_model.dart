import 'package:app/domain/entities/onboarding_setup/spending_config.dart';
import 'package:json_annotation/json_annotation.dart';

part 'spending_config_model.g.dart';

@JsonSerializable()
class SpendingConfigModel {
  int? spendingConfigId;
  int? userId;
  String? spendingMethod;
  String? dayStarted;
  bool? isLastDayOfMonth;
  int? totalInCome;
  int? monthlySaving;

  SpendingConfigModel({
    this.spendingConfigId,
    this.userId,
    this.spendingMethod,
    this.dayStarted,
    this.isLastDayOfMonth,
    this.totalInCome,
    this.monthlySaving,
  });

  factory SpendingConfigModel.fromJson(Map<String, dynamic> json) =>
      _$SpendingConfigModelFromJson(json);

  Map<String, dynamic> toJson() => _$SpendingConfigModelToJson(this);

  SpendingConfig toEntity() {
    return SpendingConfig(
      spendingConfigId: spendingConfigId,
      userId: userId,
      spendingMethod: spendingMethod,
      dayStarted: dayStarted,
      isLastDayOfMonth: isLastDayOfMonth,
      totalInCome: totalInCome,
      monthlySaving: monthlySaving,
    );
  }

  factory SpendingConfigModel.fromEntity(SpendingConfig entity) {
    return SpendingConfigModel(
      spendingConfigId: entity.spendingConfigId,
      userId: entity.userId,
      spendingMethod: entity.spendingMethod,
      dayStarted: entity.dayStarted,
      isLastDayOfMonth: entity.isLastDayOfMonth,
      totalInCome: entity.totalInCome,
      monthlySaving: entity.monthlySaving,
    );
  }
}
