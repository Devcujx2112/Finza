import 'dart:async';

import 'package:app/src/data/local/token_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class ApiInterceptor extends Interceptor {
  static bool _isRefreshing = false;
  static final List<Completer<String>> _pendingQueue = [];

  final TokenStorage _tokenStorage;
  final Dio _refreshDio;

  ApiInterceptor({required TokenStorage tokenStorage})
    : _tokenStorage = tokenStorage,
      _refreshDio = Dio(
        BaseOptions(
          baseUrl: dotenv.env['BASE_URL'] ?? "",
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
        ),
      );

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.getAccessToken();

    debugPrint('flutter: ╔╣ Request ║ ${options.method}');
    debugPrint('flutter: ║  ${options.uri}');
    debugPrint('flutter: ╚═══════════════════════════════════════╝');
    debugPrint('flutter: ╔ Headers ║');
    options.headers.forEach((key, value) {
      debugPrint('flutter: ╟ $key: $value');
    });
    debugPrint('flutter: ╚═══════════════════════════════════════╝');
    if (options.data != null) {
      debugPrint('flutter: ╔ Body ║');
      if (options.data is Map) {
        options.data.forEach((key, value) {
          debugPrint('flutter: ╟ $key: $value');
        });
      } else {
        debugPrint('flutter: ║ ${options.data}');
      }
      debugPrint('flutter: ╚═══════════════════════════════════════╝');
    }

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
      'flutter: ╔╣ Response ║ ${response.statusCode} ║ ${response.requestOptions.path}',
    );
    debugPrint('flutter: ║  Data: ${response.data}');
    debugPrint('flutter: ╚═══════════════════════════════════════╝');

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;

    debugPrint('flutter: ╔╣ DioError ║ ${err.type}');
    debugPrint('flutter: ║  ${err.message}');
    if (err.response != null) {
      debugPrint('flutter: ║  Response Code: ${err.response?.statusCode}');
      debugPrint('flutter: ║  Response Data: ${err.response}');
    }
    debugPrint('flutter: ╚═══════════════════════════════════════╝');

    if (statusCode != 401) {
      return handler.next(err);
    }

    if (err.requestOptions.path.contains('/auth/refresh')) {
      await _onRefreshFailed();
      return handler.next(err);
    }

    final requestOptions = err.requestOptions;

    if (_isRefreshing) {
      try {
        final newToken = await _waitForNewToken();
        final response = await _retryRequest(requestOptions, newToken);
        return handler.resolve(response);
      } catch (e) {
        return handler.next(err);
      }
    }

    _isRefreshing = true;

    try {
      final newAccessToken = await _refreshToken();
      await _tokenStorage.saveAccessToken(newAccessToken);
      _resolveQueue(newAccessToken);
      final response = await _retryRequest(requestOptions, newAccessToken);
      return handler.resolve(response);
    } catch (e) {
      _rejectQueue();
      await _onRefreshFailed();
      return handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }

  Future<String> _waitForNewToken() {
    final completer = Completer<String>();
    _pendingQueue.add(completer);
    return completer.future;
  }

  void _resolveQueue(String newToken) {
    for (final completer in _pendingQueue) {
      completer.complete(newToken);
    }
    _pendingQueue.clear();
  }

  void _rejectQueue() {
    for (final completer in _pendingQueue) {
      completer.completeError('Session expired');
    }
    _pendingQueue.clear();
  }

  Future<String> _refreshToken() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null) throw Exception('No refresh token');

    final response = await _refreshDio.post(
      '/auth/refresh',
      data: {'refreshToken': refreshToken},
    );

    return response.data['access_token'] as String;
  }

  Future<Response> _retryRequest(RequestOptions options, String newToken) {
    final retryDio = Dio(BaseOptions(baseUrl: dotenv.env['BASE_URL'] ?? ""));
    return retryDio.request(
      options.path,
      data: options.data,
      queryParameters: options.queryParameters,
      options: Options(
        method: options.method,
        headers: {...options.headers, 'Authorization': 'Bearer $newToken'},
      ),
    );
  }

  Future<void> _onRefreshFailed() async {
    await _tokenStorage.clearTokens();
    Get.offAllNamed('/login');
  }
}
