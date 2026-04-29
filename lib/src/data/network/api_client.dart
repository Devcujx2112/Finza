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
    _dio.interceptors.add(ApiInterceptor());
  }

  Future<Response> get({
    required String path,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post({required String path, dynamic body}) async {
    return await _dio.post(path, data: body);
  }

  Future<Response> put({required String path, dynamic body}) async {
    return await _dio.put(path, data: body);
  }

  Future<Response> delete({required String path, dynamic body}) async {
    return await _dio.delete(path, data: body);
  }
}
