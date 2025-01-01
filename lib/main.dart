import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Biometric Authentication',
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

class _BiometricAuthScreenState extends State<BiometricAuthScreen> with SingleTickerProviderStateMixin {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isAuthenticated = false;
  String _authStatus = 'Waiting...';
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Animation<double> _scaleAnimation;
  bool _isDarkMode = false;

  Future<void> _checkBiometricSupport() async {
    try {
      bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      setState(() {
        _authStatus = canCheckBiometrics
            ? 'This device supports biometric authentication.'
            : 'This device does not support biometric authentication.';
      });
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
      _animationController.forward(from: 0.0);
    } catch (e) {
      setState(() {
        _isAuthenticated = false;
        _authStatus = 'Error in biometric authentication: $e';
      });
      _animationController.forward(from: 0.0);
    }
  }

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  Future<void> _showExitConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: _isDarkMode ? Colors.grey[800] : Colors.white,
          title: Text(
            'Confirm Exit',
            style: TextStyle(
              color: _isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to exit the app?',
            style: TextStyle(
              color: _isDarkMode ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: _isDarkMode ? Colors.blue[300] : Colors.blue[700],
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Exit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isDarkMode ? Colors.red[700] : Colors.red[600],
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                exit(0);
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _checkBiometricSupport();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _isDarkMode ? Colors.white : Colors.black),
          onPressed: _showExitConfirmationDialog,
        ),
        title: Center(
          child: Text(
            'Auth Biometric',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: _isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode, color: _isDarkMode ? Colors.white : Colors.black),
            onPressed: _toggleDarkMode,
          ),
        ],
        backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _isDarkMode
                ? [Colors.grey[900]!, Colors.grey[800]!]
                : [Colors.white, Colors.blue.shade50],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to Auth Biometric',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: _isDarkMode ? Colors.white : Colors.blue.shade800,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Enhance your app security with cutting-edge biometric authentication technology',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: _isDarkMode ? Colors.grey[300] : Colors.blue.shade600,
                ),
              ),
              const SizedBox(height: 60),
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _isDarkMode ? Colors.grey[800] : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: (_isDarkMode ? Colors.black : Colors.blue).withOpacity(0.2),
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(30),
                      child: Icon(
                        Icons.fingerprint,
                        color: _isDarkMode ? Colors.blue.shade300 : Colors.blue.shade700,
                        size: 150,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: () {
                  _authenticate();
                  _animationController.forward(from: 0.0);
                },
                child: const Text('Authenticate', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: _isDarkMode ? Colors.blue.shade700 : Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 5,
                ),
              ),
              const SizedBox(height: 30),
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _animation.value,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: _isAuthenticated
                            ? (_isDarkMode ? Colors.green.shade900 : Colors.green.shade100)
                            : (_isDarkMode ? Colors.red.shade900 : Colors.red.shade100),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isAuthenticated ? Icons.check_circle : Icons.error,
                            color: _isAuthenticated
                                ? (_isDarkMode ? Colors.green.shade300 : Colors.green)
                                : (_isDarkMode ? Colors.red.shade300 : Colors.red),
                          ),
                          SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              _authStatus,
                              style: TextStyle(
                                fontSize: 16,
                                color: _isAuthenticated
                                    ? (_isDarkMode ? Colors.green.shade300 : Colors.green.shade800)
                                    : (_isDarkMode ? Colors.red.shade300 : Colors.red.shade800),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}