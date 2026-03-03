import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingController extends GetxController {
  static const _seenKey = "seen_onboarding";
  Rx<bool> isOnboarding = false.obs;

  void init() {
    checkOnboarding();
  }

  void setOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_seenKey, true);
    isOnboarding.value = true;
  }

  void checkOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    isOnboarding.value = prefs.getBool(_seenKey) ?? false;
  }
}
