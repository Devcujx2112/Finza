class BaseResponse<T> {
  final String message;
  final int statusCode;
  final T data;

  const BaseResponse({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      message: json['message'],
      statusCode: json['statusCode'],
      data: json['data'],
    );
  }
}
