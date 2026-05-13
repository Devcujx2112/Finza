import 'package:app/src/data/base_response/base_response_data.dart';
import 'package:app/src/data/local/token_storage.dart';
import 'package:app/src/data/network/api_interceptor.dart';
import 'package:dio/dio.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  late Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['BASE_URL'] ?? "",
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "User-Agent": "Flutter-App",
        },
      ),
    );
    _dio.interceptors.add(
      ApiInterceptor(tokenStorage: SecureTokenStorage.instance),
    );
  }

  // api_client.dart
  Future<BaseResponseData<T>> get<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJsonT,
  }) async {
    Response response = await _dio.get(path, queryParameters: queryParameters);
    return BaseResponseData.fromJson(response.data, fromJsonT);
  }

  Future<BaseResponseData<T>> post<T>({
    required String path,
    dynamic body,
    T Function(dynamic)? fromJsonT,
  }) async {
    Response response = await _dio.post(path, data: body);
    return BaseResponseData.fromJson(response.data, fromJsonT);
  }

  Future<BaseResponseData<T>> put<T>({
    required String path,
    dynamic body,
    T Function(dynamic)? fromJsonT,
  }) async {
    Response response = await _dio.put(path, data: body);
    return BaseResponseData.fromJson(response.data, fromJsonT);
  }

  Future<BaseResponseData<T>> delete<T>({
    required String path,
    dynamic body,
    T Function(dynamic)? fromJsonT,
  }) async {
    Response response = await _dio.delete(path, data: body);
    return BaseResponseData.fromJson(response.data, fromJsonT);
  }
}
