import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

import '../../../utils/logger.dart';

enum AuthResult {
  success,
  canceled,
  notAvailable,
  notConfigured,
  permanentlyDisabled,
  unknown
}

class AuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  /// Check if biometric authentication is available on the device
  Future<bool> checkBiometrics() async {
    try {
      Logger.info('Checking device biometric capabilities', tag: 'AuthService');

      // Check if device supports biometric authentication
      bool canCheckBiometrics = await _localAuth.canCheckBiometrics;

      // Additional check for available authenticators
      List<BiometricType> availableBiometrics =
      await _localAuth.getAvailableBiometrics();

      Logger.info('Biometrics available: $canCheckBiometrics', tag: 'AuthService');
      Logger.info('Available biometric types: $availableBiometrics', tag: 'AuthService');

      return canCheckBiometrics && availableBiometrics.isNotEmpty;
    } catch (e) {
      Logger.error('Error checking biometrics: $e', tag: 'AuthService');
      return false;
    }
  }

  /// Comprehensive authentication method with detailed error handling
  Future<AuthResult> authenticate({
    String reason = 'For your security, please authenticate to continue.',
    bool biometricOnly = true,
  }) async {
    try {
      Logger.info('Attempting authentication', tag: 'AuthService');

      // Pre-authentication checks
      bool biometricsAvailable = await checkBiometrics();
      if (!biometricsAvailable) {
        Logger.error('Biometrics not available', tag: 'AuthService');
        return AuthResult.notAvailable;
      }

      // Perform authentication
      bool authenticated = await _localAuth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          biometricOnly: biometricOnly,
          stickyAuth: true,
          sensitiveTransaction: true,
        ),
      );

      if (authenticated) {
        Logger.info('Authentication successful', tag: 'AuthService');
        return AuthResult.success;
      } else {
        Logger.info('Authentication failed or canceled', tag: 'AuthService');
        return AuthResult.canceled;
      }
    } catch (e) {
      // Detailed error handling
      // if (e is AuthenticationException) {
      //   switch (e.code) {
      //     case auth_error.notAvailable:
      //       Logger.error('Biometric auth not available', tag: 'AuthService');
      //       return AuthResult.notAvailable;
      //     case auth_error.notConfigured:
      //       Logger.error('Biometric not configured', tag: 'AuthService');
      //       return AuthResult.notConfigured;
      //     case auth_error.permanentlyDisabled:
      //       Logger.error('Biometric permanently disabled', tag: 'AuthService');
      //       return AuthResult.permanentlyDisabled;
      //     default:
      //       Logger.error('Authentication error: $e', tag: 'AuthService');
      //       return AuthResult.unknown;
      //   }
      // }

      Logger.error('Unexpected authentication error: $e', tag: 'AuthService');
      return AuthResult.unknown;
    }
  }
}
