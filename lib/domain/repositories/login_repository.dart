import 'package:app/domain/entities/user/user.dart';

abstract class LoginRepository {
  Future<User?> login(String email, String password);

  Future<User?> loginWithGoogle({
    required String provider,
    required String idToken,
  });

  Future<User?> loginWithFacebook({
    required String provider,
    required String accessToken,
  });

  Future<User?> loginWithApple({
    required String provider,
    required String idToken,
  });

  Future<User?> trialAccount();
}
