import 'package:app/domain/entities/user/user.dart';

abstract class LoginRepository {
  Future<User?> login(String email, String password);
}
