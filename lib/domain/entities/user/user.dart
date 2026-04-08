import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String userId;
  final String email;
  final String password;
  final int phoneNumber;
  final String fullName;
  final int role;
  final String avatar;
  final String token;
  final String refreshToken;

  const User({
    required this.userId,
    required this.email,
    required this.password,
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
        email,
        password,
        phoneNumber,
        fullName,
        role,
        avatar,
        token,
        refreshToken,
      ];
}
