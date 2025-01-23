import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../providers/auth_provider.dart';

class AuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<bool> checkBiometrics() async {
    try {
      bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      List<BiometricType> availableBiometrics =
      await _localAuth.getAvailableBiometrics();

      return canCheckBiometrics && availableBiometrics.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<AuthResult> authenticateBiometric() async {
    try {
      bool biometricsAvailable = await checkBiometrics();
      if (!biometricsAvailable) {
        return AuthResult.unavailable;
      }

      bool authenticated = await _localAuth.authenticate(
        localizedReason: 'For your security, please authenticate to continue.',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      return authenticated ? AuthResult.success : AuthResult.failed;
    } catch (e) {
      return AuthResult.failed;
    }
  }
}

class PinAuthService {
  static const _pinKey = 'app_pin';

  Future<bool> hasSetPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_pinKey) != null;
  }

  Future<void> setPin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pinKey, pin);
  }

  Future<bool> validatePin(String inputPin) async {
    final prefs = await SharedPreferences.getInstance();
    final storedPin = prefs.getString(_pinKey);
    return storedPin == inputPin;
  }
}