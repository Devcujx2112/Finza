// base_response_data.dart
class BaseResponseData<T> {
  final String message;
  final int statusCode;
  final T? data;

  BaseResponseData({
    required this.message,
    required this.statusCode,
    this.data,
  });

  factory BaseResponseData.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return BaseResponseData(
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'],
    );
  }

  bool get isSuccess => statusCode == 200 || statusCode == 201;
}
