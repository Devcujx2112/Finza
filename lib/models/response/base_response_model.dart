import 'package:app/src/data/base_response/base_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'base_response_model.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class BaseResponseModel<T> {
  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'statusCode')
  final int statusCode;
  @JsonKey(name: 'data')
  final T? data;

  BaseResponseModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory BaseResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$BaseResponseModelFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(T Function(T value) toJsonT) =>
      _$BaseResponseModelToJson(this, toJsonT);

  BaseResponse<E> toEntity<E>(E Function(T? model) mapper) {
    return BaseResponse(
      message: message,
      statusCode: statusCode,
      data: mapper(data),
    );
  }
}
