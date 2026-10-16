import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
class Budget extends Equatable {
  final int? budgetId;
  final int? spendingConfigId;
  final String? typeCost;
  final String? nameCost;
  final int? amount;

  const Budget({
    required this.budgetId,
    required this.spendingConfigId,
    required this.typeCost,
    required this.nameCost,
    required this.amount,
  });

  @override
  List<Object?> get props => [
    budgetId,
    spendingConfigId,
    typeCost,
    nameCost,
    amount,
  ];
}
