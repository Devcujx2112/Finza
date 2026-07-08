import 'dart:convert';
import 'dart:developer';

class AppLogger {
  static void request(String method, Uri uri, Map headers, dynamic body) {
    log(
      '╔╣ ============================= Request ║ $method ================================',
    );
    log('║  $uri');

    log(
      '╔ ================================ Headers ║'
      ' ======================================',
    );
    headers.forEach((key, value) {
      log('╟ $key: $value');
    });

    log(
      '╔ ============================== Params ║ ==========================================',
    );
    _logData(body);
  }

  static void response(int? statusCode, String path, dynamic data) {
    log(
      '╔╣ ============================= Response ║ $statusCode ║ $path ===================',
    );
    _logData(data);
  }

  static void error(String type, String? message, dynamic data) {
    log(
      '╔╣ ============================= DioError ║ $type ================================',
    );
    log('║  $message');

    if (data != null) {
      log(
        '╔ ============================== Response ║ =====================================',
      );
      _logData(data);
    }
  }

  static void _logData(dynamic data) {
    try {
      final pretty = const JsonEncoder.withIndent('  ').convert(data);

      for (final line in pretty.split('\n')) {
        log('║ $line');
      }
    } catch (_) {
      final text = data.toString();
      for (final line in text.split('\n')) {
        log('║ $line');
      }
    }
  }
}
