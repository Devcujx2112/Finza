import 'package:app/domain/entities/user/user.dart';
import 'package:app/domain/repositories/login_repository.dart';
import 'package:app/models/user/user_model.dart';
import 'package:app/src/core/error/app_exception.dart';
import 'package:app/src/core/error/error_handle.dart';
import 'package:app/src/data/network/api_client.dart';
import 'package:app/src/data/network/api_path.dart';
import 'package:get/get.dart';

class LoginRepositoryImpl extends LoginRepository {
  @override
  Future<User?> login(String email, String password) async {
    try {
      final request = {'email': email, 'password': password};

      final response = await Get.find<ApiClient>().post<UserModel>(
        path: ApiPath.login,
        body: request,
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
