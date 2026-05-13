// error_handler.dart
import 'package:app/src/core/error/app_exception.dart';
import 'package:dio/dio.dart';

class ErrorHandler {
  static AppException handle(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    }
    return AppException(message: 'Đã có lỗi xảy ra, vui lòng thử lại');
  }

  static AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppException(message: 'Kết nối quá chậm, vui lòng thử lại');
      case DioExceptionType.connectionError:
        return AppException(message: 'Không có kết nối mạng');
      case DioExceptionType.cancel:
        return AppException(message: 'Yêu cầu đã bị huỷ');
      case DioExceptionType.badResponse:
        return _handleStatusCode(error.response?.statusCode);
      default:
        return AppException(message: 'Đã có lỗi xảy ra, vui lòng thử lại');
    }
  }

  static AppException _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return AppException(statusCode: 400, message: 'Dữ liệu không hợp lệ');
      case 401:
        return AppException(
          statusCode: 401,
          message: 'Phiên đăng nhập hết hạn',
        );
      case 403:
        return AppException(
          statusCode: 403,
          message: 'Bạn không có quyền thực hiện thao tác này',
        );
      case 404:
        return AppException(statusCode: 404, message: 'Không tìm thấy dữ liệu');
      case 409:
        return AppException(statusCode: 409, message: 'Dữ liệu đã tồn tại');
      case 422:
        return AppException(
          statusCode: 422,
          message: 'Dữ liệu không đúng định dạng',
        );
      case 500:
        return AppException(
          statusCode: 500,
          message: 'Lỗi máy chủ, vui lòng thử lại sau',
        );
      default:
        return AppException(
          statusCode: statusCode,
          message: 'Đã có lỗi xảy ra',
        );
    }
  }
}
