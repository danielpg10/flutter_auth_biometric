import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/repositories/biometric_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final BiometricRepository _repository;

  AuthBloc({required BiometricRepository repository})
      : _repository = repository,
        super(const AuthInitial()) {
    on<CheckBiometricSupport>(_onCheckBiometricSupport);
    on<Authenticate>(_onAuthenticate);
    on<ResetAuthState>(_onResetAuthState);
  }

  Future<void> _onCheckBiometricSupport(
    CheckBiometricSupport event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final isSupported = await _repository.checkBiometricSupport();
      emit(AuthBiometricChecked(isSupported: isSupported));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onAuthenticate(
    Authenticate event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final isAuthenticated = await _repository.authenticate();
      if (isAuthenticated) {
        emit(AuthAuthenticated(isAuthenticated: true));
      } else {
        // Si el usuario cancela la autenticación, regresar al estado inicial
        emit(const AuthInitial());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  void _onResetAuthState(
    ResetAuthState event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthInitial());
  }
} 