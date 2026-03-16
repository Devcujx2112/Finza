import 'package:app/src/data/network/api_interceptor.dart';
import 'package:dio/dio.dart';

class ApiClient {
  late Dio _dio;

  ApiClient() {
    _dio = Dio(BaseOptions(
        baseUrl: "",
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          "Content-Type": "application/json",
        }));
    _dio.interceptors.add(ApiInterceptor());
  }

  Future<Response> get(
      String path, Map<String, dynamic>? queryParameters) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, dynamic data) async {
    return await _dio.post(path, data: data);
  }

  Future<Response> put(String path, dynamic data) async {
    return await _dio.put(path, data: data);
  }

  Future<Response> delete(String path, dynamic data) async {
    return await _dio.delete(path, data: data);
  }
}
