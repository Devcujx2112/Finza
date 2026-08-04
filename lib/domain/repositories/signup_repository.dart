import 'package:app/domain/entities/user/user.dart';

abstract class SignupRepository {
  Future<User?> register(User user);
  Future<bool?> forgotPassword(String? email);
  Future<bool?> verifyOtp(String? email, String? otp);
  Future<bool> changePassword(String? email, String? password);
}
