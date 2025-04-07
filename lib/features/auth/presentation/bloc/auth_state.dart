part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthBiometricChecked extends AuthState {
  final bool isSupported;
  const AuthBiometricChecked({required this.isSupported});

  @override
  List<Object> get props => [isSupported];
}

class AuthAuthenticated extends AuthState {
  final bool isAuthenticated;
  const AuthAuthenticated({required this.isAuthenticated});

  @override
  List<Object> get props => [isAuthenticated];
}

class AuthError extends AuthState {
  final String message;
  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
} 