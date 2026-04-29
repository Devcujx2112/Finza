import 'package:app/domain/entities/user/user.dart';
import 'package:app/domain/repositories/signup_repository.dart';

class SignupUsecase {
  SignupUsecase(this._signupRepository);

  final SignupRepository _signupRepository;

  Future<User?> register(User user) async {
    return await _signupRepository.register(user);
  }
}
