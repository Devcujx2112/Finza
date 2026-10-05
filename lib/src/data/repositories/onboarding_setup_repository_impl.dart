import 'dart:convert';

import 'package:app/domain/entities/onboarding_setup/onboarding_setup_config.dart';
import 'package:app/domain/repositories/onboarding_setup_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local persistence for the setup questionnaire. The stored payload is the
/// same JSON shape a backend would receive, so moving it server side later is
/// a transport change rather than a model change.
class OnboardingSetupRepositoryImpl implements OnboardingSetupRepository {
  const OnboardingSetupRepositoryImpl();

  static const String _configKey = 'onboarding_setup_config';

  @override
  Future<void> save(OnboardingSetupConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_configKey, jsonEncode(config.toJson()));
  }

  @override
  Future<OnboardingSetupConfig?> read() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_configKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      return OnboardingSetupConfig.fromJson(
        (jsonDecode(raw) as Map).cast<String, dynamic>(),
      );
    } on FormatException {
      await prefs.remove(_configKey);
      return null;
    }
  }

  @override
  Future<bool> hasCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getString(_configKey) ?? '').isNotEmpty;
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_configKey);
  }
}
