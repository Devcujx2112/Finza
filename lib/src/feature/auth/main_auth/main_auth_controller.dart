import 'package:app/domain/usecases/login_usecase.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/router/router_name.dart';
import 'package:app/src/core/error/app_exception.dart';
import 'package:app/src/feature/main_controller/main_controller.dart';
import 'package:get/get.dart';

class MainAuthController extends GetxController {
  MainAuthController(this.loginUsecase);

  final LoginUsecase loginUsecase;

  final RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  Future<void> trialAccount({required Function(String) showError}) async {
    try {
      _isLoading.value = true;
      final user = await loginUsecase.trialAccount();
      if (user != null) {
        await Get.find<MainController>().refreshLoginState();
        // Trial accounts always go to the notice screen first,
        // which then guides into analytics-only onboarding.
        Get.offAllNamed(RouterName.trialNotice);
      } else {
        final context = Get.context;
        final appLocal = context != null ? AppLocalizations.of(context) : null;
        showError(
          appLocal?.trialAccountCreationFailed ??
              'Trial account creation failed',
        );
      }
    } on AppException catch (e) {
      showError(e.message);
    } finally {
      _isLoading.value = false;
    }
  }
}
