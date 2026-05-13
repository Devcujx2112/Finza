// error_handler.dart
import 'package:app/l10n/app_localizations.dart';
import 'package:app/src/core/error/app_exception.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class ErrorHandler {
  static AppException handle(dynamic error) {
    final context = Get.context;
    final appLocal = context != null ? AppLocalizations.of(context) : null;

    if (error is DioException) {
      return _handleDioError(error, appLocal);
    }
    return AppException(message: appLocal?.errorOccurredPleaseTryAgain ?? '');
  }

  static AppException _handleDioError(
    DioException error,
    AppLocalizations? appLocal,
  ) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppException(
          message: appLocal?.connectionTimeoutPleaseTryAgain ?? '',
        );
      case DioExceptionType.connectionError:
        return AppException(message: appLocal?.noNetworkConnection ?? '');
      case DioExceptionType.cancel:
        return AppException(message: appLocal?.requestCancelled ?? '');
      case DioExceptionType.badResponse:
        return _handleStatusCode(error.response?.statusCode, appLocal);
      default:
        return AppException(
          message: appLocal?.errorOccurredPleaseTryAgain ?? '',
        );
    }
  }

  static AppException _handleStatusCode(
    int? statusCode,
    AppLocalizations? appLocal,
  ) {
    switch (statusCode) {
      case 400:
        return AppException(
          statusCode: 400,
          message: appLocal?.invalidData ?? '',
        );
      case 401:
        return AppException(
          statusCode: 401,
          message: appLocal?.sessionExpired ?? '',
        );
      case 403:
        return AppException(
          statusCode: 403,
          message: appLocal?.unauthorizedAction ?? '',
        );
      case 404:
        return AppException(
          statusCode: 404,
          message: appLocal?.dataNotFound ?? '',
        );
      case 409:
        return AppException(
          statusCode: 409,
          message: appLocal?.emailAlreadyExists ?? '',
        );
      case 422:
        return AppException(
          statusCode: 422,
          message: appLocal?.invalidDataFormat ?? '',
        );
      case 500:
        return AppException(
          statusCode: 500,
          message: appLocal?.serverErrorPleaseTryAgainLater ?? '',
        );
      default:
        return AppException(
          statusCode: statusCode,
          message: appLocal?.anErrorOccurred ?? '',
        );
    }
  }
}
