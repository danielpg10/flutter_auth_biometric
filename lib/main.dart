import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const BiometricAuthScreen(),
    );
  }
}

class BiometricAuthScreen extends StatefulWidget {
  const BiometricAuthScreen({super.key});

  @override
  _BiometricAuthScreenState createState() => _BiometricAuthScreenState();
}

class _BiometricAuthScreenState extends State<BiometricAuthScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isAuthenticated = false;
  String _authStatus = 'Waiting...';

  Future<void> _checkBiometricSupport() async {
    try {
      bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      if (canCheckBiometrics) {
        setState(() {
          _authStatus = 'This device supports biometric authentication.';
        });
      } else {
        setState(() {
          _authStatus = 'This device does not support biometric authentication.';
        });
      }
    } catch (e) {
      setState(() {
        _authStatus = 'Error checking biometrics: $e';
      });
    }
  }

  Future<void> _authenticate() async {
    try {
      bool isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Please authenticate using your fingerprint or Face ID.',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      setState(() {
        _isAuthenticated = isAuthenticated;
        _authStatus = isAuthenticated ? 'Authentication successful' : 'Authentication failed';
      });
    } catch (e) {
      setState(() {
        _isAuthenticated = false;
        _authStatus = 'Error in biometric authentication: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkBiometricSupport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biometric Authentication Test'),
      ),
      body: Center(
        child: _isAuthenticated
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 100,
                  ),
                  const Text(
                    'Authentication successful!',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.fingerprint,
                    color: Colors.blue,
                    size: 100,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Tap to authenticate',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _authenticate,
                    child: const Text('Authenticate'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _authStatus,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
      ),
    );
  }
}