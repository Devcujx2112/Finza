import 'package:json_annotation/json_annotation.dart';

part 'setup_user_budget_request_model.g.dart';

@JsonSerializable()
class SetupUserBudgetRequestModel {
  final String typeCost;
  final String nameCost;
  final int amount;
  final String categoriesName;
  final String stringIcon;

  const SetupUserBudgetRequestModel({
    required this.typeCost,
    required this.nameCost,
    required this.amount,
    required this.categoriesName,
    required this.stringIcon,
  });

  factory SetupUserBudgetRequestModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$SetupUserBudgetRequestModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SetupUserBudgetRequestModelToJson(this);
}
