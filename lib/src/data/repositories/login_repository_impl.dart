import 'package:app/domain/entities/user/user.dart';
import 'package:app/domain/repositories/login_repository.dart';
import 'package:app/models/user/user_model.dart';
import 'package:app/src/core/error/app_exception.dart';
import 'package:app/src/core/error/error_handle.dart';
import 'package:app/src/data/local/token_storage.dart';
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
        await SecureTokenStorage.instance.saveAccessToken(
          response.data?.accessToken ?? "",
        );
        await SecureTokenStorage.instance.saveRefreshToken(
          response.data?.refreshToken ?? "",
        );
        // final accessToken = await SecureTokenStorage.instance.getAccessToken();
        // final refreshToken = await SecureTokenStorage.instance
        //     .getRefreshToken();
        // debugPrint('flutter: ╔ Token Storage ║');
        // debugPrint('flutter: ╟ accessToken: $accessToken');
        // debugPrint('flutter: ╟ refreshToken: $refreshToken');
        // debugPrint('flutter: ╚═══════════════════════════════════════╝');
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

  @override
  Future<User?> loginWithGoogle({
    required String provider,
    required String idToken,
  }) async {
    try {
      final request = {'provider': provider, 'idToken': idToken};

      final response = await Get.find<ApiClient>().post<UserModel>(
        path: ApiPath.loginSocialMedia,
        body: request,
        fromJsonT: (data) => UserModel.fromJson(data),
      );

      if (response.isSuccess) {
        await SecureTokenStorage.instance.saveAccessToken(
          response.data?.accessToken ?? "",
        );
        await SecureTokenStorage.instance.saveRefreshToken(
          response.data?.refreshToken ?? "",
        );
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

  @override
  Future<User?> loginWithFacebook({
    required String provider,
    required String accessToken,
  }) async {
    try {
      final request = {'provider': provider, 'accessToken': accessToken};

      final response = await Get.find<ApiClient>().post<UserModel>(
        path: ApiPath.loginSocialMedia,
        body: request,
        fromJsonT: (data) => UserModel.fromJson(data),
      );

      if (response.isSuccess) {
        await SecureTokenStorage.instance.saveAccessToken(
          response.data?.accessToken ?? "",
        );
        await SecureTokenStorage.instance.saveRefreshToken(
          response.data?.refreshToken ?? "",
        );
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

  @override
  Future<User?> loginWithApple({
    required String provider,
    required String idToken,
  }) async {
    try {
      final request = {'provider': provider, 'idToken': idToken};

      final response = await Get.find<ApiClient>().post<UserModel>(
        path: ApiPath.loginSocialMedia,
        body: request,
        fromJsonT: (data) => UserModel.fromJson(data),
      );

      if (response.isSuccess) {
        await SecureTokenStorage.instance.saveAccessToken(
          response.data?.accessToken ?? "",
        );
        await SecureTokenStorage.instance.saveRefreshToken(
          response.data?.refreshToken ?? "",
        );
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

  @override
  Future<User?> trialAccount() async {
    final response = await Get.find<ApiClient>().post<UserModel>(
      path: ApiPath.trialAccount,
      fromJsonT: (data) => UserModel.fromJson(data),
    );

    if (response.isSuccess) {
      await SecureTokenStorage.instance.saveAccessToken(
        response.data?.accessToken ?? "",
      );
      await SecureTokenStorage.instance.saveRefreshToken(
        response.data?.refreshToken ?? "",
      );
      return response.data?.toEntity();
    }

    throw AppException(
      statusCode: response.statusCode,
      message: response.message,
    );
  }
}
