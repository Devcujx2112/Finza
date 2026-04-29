import 'package:app/domain/entities/user/user.dart';

abstract class SignupRepository {
  Future<User?> register(User user);
}
