import 'package:app/domain/usecases/login_usecase.dart';
import 'package:app/src/data/repositories/login_repository_impl.dart';
import 'package:app/src/feature/auth/login/login_controller.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(LoginUsecase(LoginRepositoryImpl())),
    );
  }
}
