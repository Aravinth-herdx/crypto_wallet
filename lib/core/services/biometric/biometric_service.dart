import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _localAuth;

  BiometricService() : _localAuth = LocalAuthentication();

  Future<bool> authenticate() async {
    try {
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      if (!canCheckBiometrics) return false;

      return await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access your wallet',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }
}
