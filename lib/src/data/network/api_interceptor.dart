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

  /// Log full content without truncation.
  /// Uses print() instead of debugPrint to avoid char limits and line breaks.
  void _logFull(String message) {
    if (kDebugMode) {
      print(message);
    }
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.getAccessToken();

    _logFull('flutter: ╔╣ Request ║ ${options.method}');
    _logFull('flutter: ║  ${options.uri}');
    _logFull('flutter: ╚═══════════════════════════════════════╝');
    _logFull('flutter: ╔ Headers ║');
    options.headers.forEach((key, value) {
      _logFull('flutter: ╟ $key: $value');
    });
    _logFull('flutter: ╚═══════════════════════════════════════╝');
    if (options.data != null) {
      _logFull('flutter: ╔ Body ║');
      if (options.data is Map) {
        options.data.forEach((key, value) {
          _logFull('flutter: ╟ $key: $value');
        });
      } else {
        _logFull('flutter: ║ ${options.data}');
      }
      _logFull('flutter: ╚═══════════════════════════════════════╝');
    }

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logFull(
      'flutter: ╔╣ Response ║ ${response.statusCode} ║ ${response.requestOptions.path}',
    );
    _logFull('flutter: ║  Data: ${response.data}');
    _logFull('flutter: ╚═══════════════════════════════════════╝');

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;

    _logFull('flutter: ╔╣ DioError ║ ${err.type}');
    _logFull('flutter: ║  ${err.message}');
    if (err.response != null) {
      _logFull('flutter: ║  Response Code: ${err.response?.statusCode}');
      _logFull('flutter: ║  Response Data: ${err.response}');
    }
    _logFull('flutter: ╚═══════════════════════════════════════╝');

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
