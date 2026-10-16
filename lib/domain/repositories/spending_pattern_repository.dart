import 'package:app/domain/entities/spending_pattern/spending_pattern.dart';

/// Storage for the versions of the spending plan. It only stores; which
/// version applies to which month is decided by the use case.
abstract class SpendingPatternRepository {
  /// Every stored version, oldest first.
  Future<List<SpendingPattern>> readAll();

  /// Stores [pattern], replacing the version that starts in the same month.
  Future<void> upsert(SpendingPattern pattern);

  /// Removes the version that starts in the month of [effectiveFrom].
  Future<void> remove(DateTime effectiveFrom);
}
