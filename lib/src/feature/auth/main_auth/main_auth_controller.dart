import 'package:app/domain/usecases/login_usecase.dart';
import 'package:app/router/router_name.dart';
import 'package:app/src/core/error/app_exception.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class MainAuthController extends GetxController {
  MainAuthController(this.loginUsecase);

  final LoginUsecase loginUsecase;

  final RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  Future<void> trialAccount({
    required Function(String) showError,
    required Function() onSuccess,
  }) async {
    try {
      _isLoading.value = true;
      final isSuccess = await loginUsecase.trialAccount();
      if (isSuccess != null) {
        onSuccess();
        Get.offAllNamed(RouterName.home);
      } else {
        showError('Trial account creation failed');
      }
      onSuccess();
    } on AppException catch (e) {
      showError(e.message);
    } finally {
      _isLoading.value = false;
    }
  }
}
