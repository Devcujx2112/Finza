class AppException implements Exception {
  final int? statusCode;
  final String message;

  AppException({this.statusCode, required this.message});

  @override
  String toString() => 'AppException($statusCode): $message';
}
