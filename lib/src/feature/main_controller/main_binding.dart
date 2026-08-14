import 'package:app/src/data/local/token_storage.dart';
import 'package:app/src/feature/main_controller/main_controller.dart';
import 'package:get/get.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<MainController>()) {
      Get.put(
        MainController(SecureTokenStorage.instance),
        permanent: true,
      );
    }
  }
}
