// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoriesModel _$CategoriesModelFromJson(Map<String, dynamic> json) =>
    CategoriesModel(
      categoryId: (json['categoryId'] as num?)?.toInt(),
      budgetId: (json['budgetId'] as num?)?.toInt(),
      categoryName: json['categoryName'] as String?,
      categoryIcon: json['categoryIcon'] as String?,
      typeCost: json['typeCost'] as String?,
    );

Map<String, dynamic> _$CategoriesModelToJson(CategoriesModel instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'budgetId': instance.budgetId,
      'categoryName': instance.categoryName,
      'categoryIcon': instance.categoryIcon,
      'typeCost': instance.typeCost,
    };
