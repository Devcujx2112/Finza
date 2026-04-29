import 'package:app/domain/entities/user/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  String? userId;
  String? userName;
  String? password;
  String? phoneNumber;
  String? fullName;
  String? dateOfBirth;
  String? role;
  String? avatar;
  String? token;
  String? refreshToken;

  UserModel({
    this.userId,
    this.userName,
    this.password,
    this.phoneNumber,
    this.fullName,
    this.dateOfBirth,
    this.role,
    this.avatar,
    this.token,
    this.refreshToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  User toEntity() {
    return User(
      userId: userId ?? "",
      userName: userName ?? "",
      password: password ?? "",
      phoneNumber: phoneNumber ?? '',
      fullName: fullName ?? "",
      role: role ?? '',
      dateOfBirth: dateOfBirth ?? "",
      avatar: avatar ?? "",
      token: token ?? "",
      refreshToken: refreshToken ?? "",
    );
  }
}
