import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
class SpendingConfig extends Equatable {
  final int? spendingConfigId;
  final int? userId;
  final String? spendingMethod;
  final String? dayStarted;
  final bool? isLastDayOfMonth;
  final int? totalInCome;
  final int? monthlySaving;

  const SpendingConfig({
    required this.spendingConfigId,
    required this.userId,
    required this.spendingMethod,
    required this.dayStarted,
    required this.isLastDayOfMonth,
    required this.totalInCome,
    required this.monthlySaving,
  });

  @override
  List<Object?> get props => [
    spendingConfigId,
    userId,
    spendingMethod,
    dayStarted,
    isLastDayOfMonth,
    totalInCome,
    monthlySaving,
  ];
}