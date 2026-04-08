import 'package:shared_preferences/shared_preferences.dart';

class SplashPageController {
  static const _seenKey = "seen_onboarding";

  void init() {
    checkOnboarding();
  }

  Future<void> setOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_seenKey, true);
  }

  Future<bool> checkOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_seenKey) ?? false;
  }
}
