import 'package:app/domain/usecases/login_usecase.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/src/feature/onboarding_setup/onboarding_setup_gate.dart';
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
        await OnboardingSetupGate.enterApp();
      } else {
        final context = Get.context;
        final appLocal = context != null ? AppLocalizations.of(context) : null;
        showError(
          appLocal?.trialAccountCreationFailed ??
              'Trial account creation failed',
        );
        onSuccess();
      }
    } on AppException catch (e) {
      showError(e.message);
    } finally {
      _isLoading.value = false;
    }
  }
}
