import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';

class FingerprintIcon extends StatelessWidget {
  const FingerprintIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Icon(
        Icons.fingerprint,
        color: Theme.of(context).colorScheme.primary,
        size: 150,
      ),
    );
  }
}

class AuthStatusText extends StatelessWidget {
  const AuthStatusText({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const CircularProgressIndicator();
        }
        if (state is AuthError) {
          return Column(
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                state.message,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          );
        }
        if (state is AuthBiometricChecked) {
          return Column(
            children: [
              Icon(
                state.isSupported ? Icons.check_circle : Icons.info_outline,
                color: state.isSupported 
                    ? Theme.of(context).colorScheme.primary 
                    : Theme.of(context).colorScheme.secondary,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                state.isSupported
                    ? 'This device supports biometric authentication.'
                    : 'Biometric authentication is not available on this platform.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          );
        }
        if (state is AuthAuthenticated) {
          return Column(
            children: [
              Icon(
                state.isAuthenticated ? Icons.lock_open : Icons.lock,
                color: state.isAuthenticated
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.error,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                state.isAuthenticated
                    ? 'Authentication successful'
                    : 'Authentication failed',
                style: TextStyle(
                  color: state.isAuthenticated
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class AuthButton extends StatelessWidget {
  const AuthButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isSupported = state is AuthBiometricChecked && state.isSupported;
        final isLoading = state is AuthLoading;
        final canRetry = state is AuthInitial || state is AuthError;
        
        return ElevatedButton(
          onPressed: (isSupported && !isLoading) || canRetry
              ? () {
                  if (canRetry) {
                    context.read<AuthBloc>().add(ResetAuthState());
                  }
                  context.read<AuthBloc>().add(Authenticate());
                }
              : null,
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : Text(canRetry ? 'Try Again' : 'Authenticate'),
        );
      },
    );
  }
} 