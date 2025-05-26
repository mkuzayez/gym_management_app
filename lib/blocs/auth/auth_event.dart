import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String phoneNumber;
  final String password;

  const LoginRequested({required this.phoneNumber, required this.password});

  @override
  List<Object> get props => [phoneNumber, password];
}

class RegisterRequested extends AuthEvent {
  final String phoneNumber;
  final String password;
  final String name;
  final String email;

  const RegisterRequested({
    required this.phoneNumber,
    required this.password,
    required this.name,
    required this.email,
  });

  @override
  List<Object> get props => [phoneNumber, password, name, email];
}

class LogoutRequested extends AuthEvent {}