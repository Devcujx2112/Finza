import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String userId;
  final String email;
  final String password;
  final String dateOfBirth;
  final String phoneNumber;
  final String fullName;
  final String role;
  final String avatar;
  final String accessToken;
  final String refreshToken;

  const User({
    required this.userId,
    required this.email,
    required this.password,
    required this.dateOfBirth,
    required this.phoneNumber,
    required this.fullName,
    required this.role,
    required this.avatar,
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  List<Object?> get props => [
    userId,
    email,
    password,
    phoneNumber,
    fullName,
    role,
    avatar,
    accessToken,
    refreshToken,
  ];
}
