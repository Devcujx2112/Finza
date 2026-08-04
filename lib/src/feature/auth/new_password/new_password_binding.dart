import 'package:app/domain/usecases/signup_usecase.dart';
import 'package:app/src/data/repositories/signup_repository_impl.dart';
import 'package:app/src/feature/auth/new_password/new_password_controller.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class NewPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewPasswordController>(
      () => NewPasswordController(SignupUsecase(SignupRepositoryImpl())),
    );
  }
}
