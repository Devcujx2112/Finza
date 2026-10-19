import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
class Categories extends Equatable {
  final int? categoryId;
  final int? budgetId;
  final String? categoryName;
  final String? categoryIcon;
  final String? typeCost;

  const Categories({
    required this.categoryId,
    required this.budgetId,
    required this.categoryName,
    required this.categoryIcon,
    required this.typeCost,
  });

  @override
  List<Object?> get props => [
    categoryId,
    budgetId,
    categoryName,
    categoryIcon,
    typeCost,
  ];
}