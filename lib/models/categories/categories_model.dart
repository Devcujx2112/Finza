import 'package:app/domain/entities/categories/categories.dart';
import 'package:json_annotation/json_annotation.dart';

part 'categories_model.g.dart';

@JsonSerializable()
class CategoriesModel {
  int? categoryId;
  int? budgetId;
  String? categoryName;
  String? categoryIcon;
  String? typeCost;

  CategoriesModel({
    this.categoryId,
    this.budgetId,
    this.categoryName,
    this.categoryIcon,
    this.typeCost,
  });

  factory CategoriesModel.fromJson(Map<String, dynamic> json) =>
      _$CategoriesModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoriesModelToJson(this);

  Categories toEntity() {
    return Categories(
      categoryId: categoryId,
      budgetId: budgetId,
      categoryName: categoryName,
      categoryIcon: categoryIcon,
      typeCost: typeCost,
    );
  }

  factory CategoriesModel.fromEntity(Categories entity) {
    return CategoriesModel(
      categoryId: entity.categoryId,
      budgetId: entity.budgetId,
      categoryName: entity.categoryName,
      categoryIcon: entity.categoryIcon,
      typeCost: entity.typeCost,
    );
  }
}
