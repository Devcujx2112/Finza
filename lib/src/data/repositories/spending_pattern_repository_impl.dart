import 'dart:convert';

import 'package:app/domain/entities/spending_pattern/spending_pattern.dart';
import 'package:app/domain/repositories/spending_pattern_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local persistence for the spending plan versions, stored as one JSON list
/// in the same shape a backend would receive.
class SpendingPatternRepositoryImpl implements SpendingPatternRepository {
  const SpendingPatternRepositoryImpl();

  static const String _versionsKey = 'spending_pattern_versions';

  @override
  Future<List<SpendingPattern>> readAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_versionsKey);
    if (raw == null || raw.isEmpty) return <SpendingPattern>[];
    // A payload that does not parse is reported rather than treated as
    // empty: an empty read would let the next save overwrite the history.
    return (jsonDecode(raw) as List)
        .map(
          (item) =>
              SpendingPattern.fromJson((item as Map).cast<String, dynamic>()),
        )
        .toList()
      ..sort((a, b) => a.effectiveFrom.compareTo(b.effectiveFrom));
  }

  @override
  Future<void> upsert(SpendingPattern pattern) async {
    final versions = await readAll()
      ..removeWhere(
        (item) => _sameMonth(item.effectiveFrom, pattern.effectiveFrom),
      )
      ..add(pattern)
      ..sort((a, b) => a.effectiveFrom.compareTo(b.effectiveFrom));
    await _write(versions);
  }

  @override
  Future<void> remove(DateTime effectiveFrom) async {
    final versions = await readAll()
      ..removeWhere((item) => _sameMonth(item.effectiveFrom, effectiveFrom));
    await _write(versions);
  }

  Future<void> _write(List<SpendingPattern> versions) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _versionsKey,
      jsonEncode(versions.map((item) => item.toJson()).toList()),
    );
  }

  static bool _sameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;
}
