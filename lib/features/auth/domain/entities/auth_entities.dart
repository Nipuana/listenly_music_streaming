import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable{
  final String? userId;
  final String username;
  final String email;
  final String userType;
  final String? password;
  final String? profilePicture;

  const AuthEntity({
    this.userId,
    required this.username,
    required this.email,
    required this.userType,
    this.password,
    this.profilePicture,
  });

  @override

  List<Object?> get props =>[
    userId,
    username,
    email,
    userType,
    password,
    profilePicture
  ];
}