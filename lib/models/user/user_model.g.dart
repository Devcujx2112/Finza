// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  userId: json['userId'] as String?,
  email: json['email'] as String?,
  password: json['password'] as String?,
  phoneNumber: (json['phoneNumber'] as num?)?.toInt(),
  fullName: json['fullName'] as String?,
  role: (json['role'] as num?)?.toInt(),
  avatar: json['avatar'] as String?,
  token: json['token'] as String?,
  refreshToken: json['refreshToken'] as String?,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'userId': instance.userId,
  'email': instance.email,
  'password': instance.password,
  'phoneNumber': instance.phoneNumber,
  'fullName': instance.fullName,
  'role': instance.role,
  'avatar': instance.avatar,
  'token': instance.token,
  'refreshToken': instance.refreshToken,
};
