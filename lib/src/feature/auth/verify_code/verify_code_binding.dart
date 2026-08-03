import 'package:app/domain/usecases/signup_usecase.dart';
import 'package:app/src/data/repositories/signup_repository_impl.dart';
import 'package:app/src/feature/auth/verify_code/verify_code_controller.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class VerifyCodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyCodeController>(
      () => VerifyCodeController(SignupUsecase(SignupRepositoryImpl())),
    );
  }
}
