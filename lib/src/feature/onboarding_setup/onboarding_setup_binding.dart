import 'package:app/domain/usecases/onboarding_setup_usecase.dart';
import 'package:app/src/data/repositories/onboarding_setup_repository_impl.dart';
import 'package:app/src/feature/onboarding_setup/onboarding_setup_controller.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class OnboardingSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingSetupController>(
      () => OnboardingSetupController(
        OnboardingSetupUsecase(const OnboardingSetupRepositoryImpl()),
      ),
    );
  }
}
