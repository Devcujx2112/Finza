import 'package:app/domain/entities/user/user.dart';
import 'package:app/domain/repositories/signup_repository.dart';
import 'package:app/models/user/user_model.dart';
import 'package:app/src/core/error/app_exception.dart';
import 'package:app/src/core/error/error_handle.dart';
import 'package:app/src/data/network/api_client.dart';
import 'package:app/src/data/network/api_path.dart';
import 'package:get/get.dart';

class SignupRepositoryImpl extends SignupRepository {
  @override
  Future<User?> register(User user) async {
    try {
      final request = UserModel(
        role: user.role,
        userId: user.userId,
        avatar: user.avatar,
        refreshToken: user.refreshToken,
        token: user.token,
        email: user.email,
        password: user.password,
        phoneNumber: user.phoneNumber,
        fullName: user.fullName,
        dateOfBirth: user.dateOfBirth,
      );

      final response = await Get.find<ApiClient>().post<UserModel>(
        path: ApiPath.register,
        body: request.toJson(),
        fromJsonT: (data) => UserModel.fromJson(data),
      );

      if (response.isSuccess) {
        return response.data?.toEntity();
      }

      throw AppException(
        statusCode: response.statusCode,
        message: response.message,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
