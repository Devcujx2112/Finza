import 'package:flutter/material.dart';

class ExpenseCategory {
  final String id;
  final String name;
  final String emoji;
  final Color color;

  const ExpenseCategory({
    required this.id,
    required this.name,
    required this.emoji,
    required this.color,
  });

  static const List<ExpenseCategory> defaultCategories = [
    ExpenseCategory(
      id: 'food',
      name: 'Ăn uống',
      emoji: '🍜',
      color: Color(0xFFFF6B6B),
    ),
    ExpenseCategory(
      id: 'transport',
      name: 'Di chuyển',
      emoji: '🚕',
      color: Color(0xFF4D96FF),
    ),
    ExpenseCategory(
      id: 'shopping',
      name: 'Mua sắm',
      emoji: '🛍️',
      color: Color(0xFFFFB534),
    ),
    ExpenseCategory(
      id: 'housing',
      name: 'Nhà cửa',
      emoji: '🏠',
      color: Color(0xFF6BCB77),
    ),
    ExpenseCategory(
      id: 'entertainment',
      name: 'Giải trí',
      emoji: '☕',
      color: Color(0xFF9D4EDD),
    ),
    ExpenseCategory(
      id: 'health',
      name: 'Sức khỏe',
      emoji: '💊',
      color: Color(0xFFFF758F),
    ),
    ExpenseCategory(
      id: 'education',
      name: 'Giáo dục',
      emoji: '📚',
      color: Color(0xFF3A86FF),
    ),
    ExpenseCategory(
      id: 'bills',
      name: 'Hóa đơn',
      emoji: '💡',
      color: Color(0xFFFB5607),
    ),
    ExpenseCategory(
      id: 'other',
      name: 'Khác',
      emoji: '📦',
      color: Color(0xFF8D99AE),
    ),
  ];

  static ExpenseCategory getById(String id) {
    return defaultCategories.firstWhere(
      (cat) => cat.id == id,
      orElse: () => defaultCategories.last,
    );
  }
}

class ExpenseItem {
  final String id;
  final double amount;
  final String categoryId;
  final DateTime date;
  final String note;

  ExpenseItem({
    required this.id,
    required this.amount,
    required this.categoryId,
    required this.date,
    required this.note,
  });

  ExpenseCategory get category => ExpenseCategory.getById(categoryId);

  ExpenseItem copyWith({
    String? id,
    double? amount,
    String? categoryId,
    DateTime? date,
    String? note,
  }) {
    return ExpenseItem(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      note: note ?? this.note,
    );
  }
}
