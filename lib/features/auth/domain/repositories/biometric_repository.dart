import 'package:local_auth/local_auth.dart';

abstract class BiometricRepository {
  Future<bool> checkBiometricSupport();
  Future<bool> authenticate();
  Future<List<BiometricType>> getAvailableBiometrics();
} 