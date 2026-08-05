import 'package:app/src/feature/bottom_bar/bottom_bar_controller.dart';
import 'package:get/get.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<BottomBarController>()) {
      Get.lazyPut<BottomBarController>(() => BottomBarController());
    }
  }
}
