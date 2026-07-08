import 'package:app/domain/entities/user/user.dart';
import 'package:app/domain/repositories/login_repository.dart';

class LoginUsecase {
  LoginUsecase(this._loginRepository);

  final LoginRepository _loginRepository;

  Future<User?> login(String email, String password) async {
    return await _loginRepository.login(email, password);
  }

  Future<User?> loginWithGoogle({
    required String provider,
    required String idToken,
  }) async {
    return await _loginRepository.loginWithGoogle(
      provider: provider,
      idToken: idToken,
    );
  }

  Future<User?> loginWithFacebook({
    required String provider,
    required String accessToken,
  }) async {
    return await _loginRepository.loginWithFacebook(
      provider: provider,
      accessToken: accessToken,
    );
  }

  Future<User?> loginWithApple({
    required String provider,
    required String idToken,
  }) async {
    return await _loginRepository.loginWithApple(
      provider: provider,
      idToken: idToken,
    );
  }

  Future<User?> trialAccount() async {
    return await _loginRepository.trialAccount();
  }
}
