import 'package:flutter/foundation.dart';

/// A spending category the user adds during allocation, alongside the
/// built-in ones. It replaces a fixed "other" bucket: the user names it,
/// picks its icon and sets its monthly budget.
///
/// The icon is stored as a key rather than an icon object so the domain stays
/// free of UI types and the payload stays plain JSON. The setup UI owns the
/// key to icon catalog.
@immutable
class CustomCategory {
  const CustomCategory({
    required this.id,
    required this.name,
    required this.iconKey,
    required this.amount,
  });

  final String id;
  final String name;
  final String iconKey;
  final double amount;

  CustomCategory copyWith({String? name, String? iconKey, double? amount}) =>
      CustomCategory(
        id: id,
        name: name ?? this.name,
        iconKey: iconKey ?? this.iconKey,
        amount: amount ?? this.amount,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'icon': iconKey,
    'amount': amount,
  };

  static CustomCategory fromJson(Map<String, dynamic> json) => CustomCategory(
    id: json['id'] as String,
    name: json['name'] as String,
    iconKey: json['icon'] as String? ?? '',
    amount: (json['amount'] as num?)?.toDouble() ?? 0,
  );

  @override
  bool operator ==(Object other) =>
      other is CustomCategory &&
      other.id == id &&
      other.name == name &&
      other.iconKey == iconKey &&
      other.amount == amount;

  @override
  int get hashCode => Object.hash(id, name, iconKey, amount);
}
