// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  userId: json['userId'] as String?,
  userName: json['userName'] as String?,
  password: json['password'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  fullName: json['fullName'] as String?,
  dateOfBirth: json['dateOfBirth'] as String?,
  role: json['role'] as String?,
  avatar: json['avatar'] as String?,
  token: json['token'] as String?,
  refreshToken: json['refreshToken'] as String?,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'userId': instance.userId,
  'userName': instance.userName,
  'password': instance.password,
  'phoneNumber': instance.phoneNumber,
  'fullName': instance.fullName,
  'dateOfBirth': instance.dateOfBirth,
  'role': instance.role,
  'avatar': instance.avatar,
  'token': instance.token,
  'refreshToken': instance.refreshToken,
};
