import 'package:app/domain/entities/onboarding_setup/budget.dart';
import 'package:json_annotation/json_annotation.dart';

part 'budget_model.g.dart';

@JsonSerializable()
class BudgetModel {
  int? budgetId;
  int? spendingConfigId;
  String? typeCost;
  String? nameCost;
  int? amount;

  BudgetModel({
    this.budgetId,
    this.spendingConfigId,
    this.typeCost,
    this.nameCost,
    this.amount,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) =>
      _$BudgetModelFromJson(json);

  Map<String, dynamic> toJson() => _$BudgetModelToJson(this);

  Budget toEntity() {
    return Budget(
      budgetId: budgetId,
      spendingConfigId: spendingConfigId,
      typeCost: typeCost,
      nameCost: nameCost,
      amount: amount,
    );
  }

  factory BudgetModel.fromEntity(Budget entity) {
    return BudgetModel(
      budgetId: entity.budgetId,
      spendingConfigId: entity.spendingConfigId,
      typeCost: entity.typeCost,
      nameCost: entity.nameCost,
      amount: entity.amount,
    );
  }
}
