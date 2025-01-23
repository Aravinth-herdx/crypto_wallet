import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/auth/auth_service.dart';



enum AuthMethod {
  biometric,
  pin
}


enum AuthResult {
  success,
  failed,
  canceled,
  unavailable
}


// Providers
final authServiceProvider = Provider((ref) => AuthService());
final pinAuthServiceProvider = Provider((ref) => PinAuthService());

class AuthenticationProvider extends StateNotifier<AuthMethod> {
  final AuthService authService;
  final PinAuthService pinAuthService;

  AuthenticationProvider(this.authService, this.pinAuthService)
      : super(AuthMethod.biometric);

  Future<Enum> authenticate() async {
    // Try biometric first
    final biometricResult = await authService.authenticateBiometric();

    if (biometricResult == AuthResult.success) {
      return biometricResult;
    }

    // Fallback to PIN if biometric fails
    return AuthMethod.pin;
  }
}