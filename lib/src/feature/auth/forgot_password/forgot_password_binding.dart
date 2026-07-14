import 'package:app/domain/usecases/signup_usecase.dart';
import 'package:app/src/data/repositories/signup_repository_impl.dart';
import 'package:app/src/feature/auth/forgot_password/forgot_password_controller.dart';
import 'package:get/get.dart';

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(
      () => ForgotPasswordController(SignupUsecase(SignupRepositoryImpl())),
    );
  }
}
