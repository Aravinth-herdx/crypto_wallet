import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../../providers/auth_provider.dart';
import '../../navigation/app_router.dart';

class BiometricAuthScreen extends ConsumerStatefulWidget {
  const BiometricAuthScreen({super.key});

  @override
  _BiometricAuthScreenState createState() => _BiometricAuthScreenState();
}

class _BiometricAuthScreenState extends ConsumerState<BiometricAuthScreen> {
  bool _isAuthenticating = false;
  bool _isVerified = false;

  @override
  void initState() {
    super.initState();
    _performBiometricAuth();
  }

  Future<void> _performBiometricAuth() async {
    if (_isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
    });

    final authService = ref.read(authServiceProvider);
    final result = await authService.authenticateBiometric();

    if (result == AuthResult.success) {
      setState(() {
        _isVerified = true;
      });
      await Future.delayed(const Duration(seconds: 2), _navigateToHome);
    } else {
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AppRouter())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: _isVerified
                ? _buildVerifiedView()
                : _buildAuthenticationView(),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthenticationView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isAuthenticating
              ? const Icon(
            Icons.fingerprint,
            size: 120,
            color: Colors.white,
          )
              : Column(
            children: [
              const Icon(
                Icons.lock,
                size: 80,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              Text(
                'Authentication Required',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Use Touch ID or Face ID to unlock',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _performBiometricAuth,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white12,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15
                  ),
                ),
                child: const Text('Try Again'),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVerifiedView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animation/ani.json',
            width:100,
            height:100,
            fit: BoxFit.fill,
            repeat: false,
          ),
          const SizedBox(height: 30),
          Text(
            'Identity Verified',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'You have been securely authenticated.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

}