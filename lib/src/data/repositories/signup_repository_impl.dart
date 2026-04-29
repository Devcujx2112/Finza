import 'package:app/domain/entities/user/user.dart';
import 'package:app/domain/repositories/signup_repository.dart';
import 'package:app/models/user/user_model.dart';
import 'package:app/src/data/network/api_client.dart';
import 'package:app/src/data/network/api_path.dart';

class SignupRepositoryImpl extends SignupRepository {
  @override
  Future<User?> register(User user) async {
    final request = UserModel(
      role: user.role,
      userId: '',
      avatar: user.avatar,
      refreshToken: '',
      token: '',
      userName: user.userName,
      password: user.password,
      phoneNumber: user.phoneNumber,
      fullName: user.fullName,
      dateOfBirth: user.dateOfBirth,
    );
    final response = await ApiClient().post(
      path: ApiPath.register,
      body: request.toJson(),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return UserModel.fromJson(response.data).toEntity();
    } else {
      throw Exception('Failed to register');
    }
  }
}
