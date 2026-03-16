import 'dart:developer';

import 'package:dio/dio.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log("||====1.METHOD: ${options.method}:  ");
    log("|| ====2.REQUEST: ${options.path}:  ");
    log("|| ===3.PARAMS: ${options.queryParameters}:  ");
    log("|| ===4.HEADERS: ${options.headers}:  ");

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log("|| ===5.RESPONSE: ${response.statusCode} === ${response.data}:  ");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log("||===6.ERROR: ${err.response?.statusCode} === ${err.response?.data}:  ");
    super.onError(err, handler);
  }
}
