import 'package:app/domain/entities/user/user.dart';
import 'package:app/domain/repositories/login_repository.dart';

class LoginUsecase {
  LoginUsecase(this._loginRepository);

  final LoginRepository _loginRepository;

  Future<User?> login(String email, String password) async {
    return await _loginRepository.login(email, password);
  }
}
