import 'package:app/domain/usecases/login_usecase.dart';
import 'package:app/router/router_name.dart';
import 'package:app/src/core/error/app_exception.dart';
import 'package:app/src/feature/main_controller/main_controller.dart';
import 'package:get/get.dart';

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
        await Get.find<MainController>().refreshLoginState();
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
