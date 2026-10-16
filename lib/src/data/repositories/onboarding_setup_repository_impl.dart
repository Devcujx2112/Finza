import 'dart:convert';

import 'package:app/domain/entities/onboarding_setup/onboarding_setup_config.dart';
import 'package:app/domain/entities/onboarding_setup/spending_config.dart';
import 'package:app/domain/repositories/onboarding_setup_repository.dart';
import 'package:app/models/onboarding/setup_user_budget_request_model.dart';
import 'package:app/models/onboarding/spending_config_model.dart';
import 'package:app/src/core/error/app_exception.dart';
import 'package:app/src/core/error/error_handle.dart';
import 'package:app/src/data/network/api_client.dart';
import 'package:app/src/data/network/api_path.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
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

  @override
  Future<bool> saveBudgetUser(List<SetupUserBudgetRequestModel> data) async {
    try {
      final response = await Get.find<ApiClient>().post<String>(
        path: ApiPath.saveBudget,
        body: data.map((e) => e.toJson()).toList(),
        fromJsonT: (data) => data?.toString() ?? '',
      );
      return response.isSuccess;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  @override
  Future<bool> saveSpendingConfig(SpendingConfig data) async {
    try {
      final request = SpendingConfigModel.fromEntity(data);
      final response = await Get.find<ApiClient>().post<String>(
        path: ApiPath.saveSpendingConfig,
        body: request.toJson(),
        fromJsonT: (data) => data,
      );
      return response.isSuccess;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
