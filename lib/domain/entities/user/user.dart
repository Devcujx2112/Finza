import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String userId;
  final String userName;
  final String password;
  final String dateOfBirth;
  final String phoneNumber;
  final String fullName;
  final String role;
  final String avatar;
  final String token;
  final String refreshToken;

  const User({
    required this.userId,
    required this.userName,
    required this.password,
    required this.dateOfBirth,
    required this.phoneNumber,
    required this.fullName,
    required this.role,
    required this.avatar,
    required this.token,
    required this.refreshToken,
  });

  @override
  List<Object?> get props => [
    userId,
    userName,
    password,
    phoneNumber,
    fullName,
    role,
    avatar,
    token,
    refreshToken,
  ];
}
