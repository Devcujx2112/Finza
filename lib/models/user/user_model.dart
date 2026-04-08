import 'package:app/domain/entities/user/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  String? userId;
  String? email;
  String? password;
  int? phoneNumber;
  String? fullName;
  int? role;
  String? avatar;
  String? token;
  String? refreshToken;

  UserModel({
    this.userId,
    this.email,
    this.password,
    this.phoneNumber,
    this.fullName,
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
      email: email ?? "",
      password: password ?? "",
      phoneNumber: phoneNumber ?? 0,
      fullName: fullName ?? "",
      role: role ?? 0,
      avatar: avatar ?? "",
      token: token ?? "",
      refreshToken: refreshToken ?? "",
    );
  }
}
