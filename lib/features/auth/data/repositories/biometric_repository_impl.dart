import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import '../../domain/repositories/biometric_repository.dart';

class BiometricRepositoryImpl implements BiometricRepository {
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  Future<bool> checkBiometricSupport() async {
    try {
      if (kIsWeb) {
        return false;
      }
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> authenticate() async {
    try {
      if (kIsWeb) {
        throw Exception('Biometric authentication is not available on web');
      }
      return await _localAuth.authenticate(
        localizedReason: 'Please authenticate using your fingerprint or Face ID.',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      throw Exception('Authentication error: ${e.toString()}');
    }
  }

  @override
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      if (kIsWeb) {
        return [];
      }
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }
} 