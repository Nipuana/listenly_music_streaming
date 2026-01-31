import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable{
  final String? userId;
  final String username;
  final String email;
  final String userType;
  final String? password;
  final String? confirmPassword;
  final String? profilePicture;
  final String? token;

  const AuthEntity({
    this.userId,
    required this.username,
    required this.email,
    required this.userType,
    this.password,
    this.confirmPassword,
    this.profilePicture,
    this.token,
  });

  @override
  List<Object?> get props =>[
    userId,
    username,
    email,
    userType,
    password,
    confirmPassword,
    profilePicture,
    token
  ];
}