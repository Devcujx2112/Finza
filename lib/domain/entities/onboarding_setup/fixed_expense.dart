import 'package:flutter/foundation.dart';

/// A recurring monthly commitment such as rent, utilities or an installment.
@immutable
class FixedExpense {
  const FixedExpense({
    required this.id,
    required this.name,
    required this.amount,
  });

  final String id;
  final String name;
  final double amount;

  FixedExpense copyWith({String? name, double? amount}) => FixedExpense(
    id: id,
    name: name ?? this.name,
    amount: amount ?? this.amount,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'amount': amount,
  };

  static FixedExpense fromJson(Map<String, dynamic> json) => FixedExpense(
    id: json['id'] as String,
    name: json['name'] as String,
    amount: (json['amount'] as num).toDouble(),
  );

  @override
  bool operator ==(Object other) =>
      other is FixedExpense &&
      other.id == id &&
      other.name == name &&
      other.amount == amount;

  @override
  int get hashCode => Object.hash(id, name, amount);
}
