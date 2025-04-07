part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class CheckBiometricSupport extends AuthEvent {}

class Authenticate extends AuthEvent {}

class ResetAuthState extends AuthEvent {} 