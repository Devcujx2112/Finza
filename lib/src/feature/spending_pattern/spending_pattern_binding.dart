import 'package:app/domain/usecases/spending_pattern_usecase.dart';
import 'package:app/src/data/repositories/onboarding_setup_repository_impl.dart';
import 'package:app/src/data/repositories/spending_pattern_repository_impl.dart';
import 'package:app/src/feature/spending_pattern/spending_pattern_edit_controller.dart';
import 'package:get/get.dart';

/// The spending plan use case wired to local storage. Shared by the edit
/// screen and the budget screen, which shows the plan of the viewed month.
SpendingPatternUsecase buildSpendingPatternUsecase() => SpendingPatternUsecase(
  const SpendingPatternRepositoryImpl(),
  const OnboardingSetupRepositoryImpl(),
);

class SpendingPatternEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SpendingPatternEditController>(
      () => SpendingPatternEditController(buildSpendingPatternUsecase()),
    );
  }
}
