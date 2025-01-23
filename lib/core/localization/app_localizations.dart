import 'package:flutter/material.dart';


class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    final instance = Localizations.of<AppLocalizations>(context, AppLocalizations);
    if (instance == null) {
      throw FlutterError('AppLocalizations not found in context');
    }
    return instance;
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'wallet': 'Wallet',
      'createWallet': 'Create New Wallet',
      'importWallet': 'Import Wallet',
      'address': 'Wallet Address',
      'securityWarning': 'Never share your private key or mnemonic phrase with anyone!',
      'error': 'Error',
      'scanQrCode': 'Scan QR Code',
      'copied': 'Copied to clipboard',
      'scanInstructions': 'Point the camera at a QR code',
      'shareAddress': 'Share Address',
      'addressCopied': 'Address copied to clipboard',
      'shareAddressMessage': 'Here is my wallet address:',
    },
    'es': {
      'wallet': 'Billetera',
      'createWallet': 'Crear Nueva Billetera',
      'importWallet': 'Importar Billetera',
      'address': 'Dirección de Billetera',
      'securityWarning': '¡Nunca compartas tu clave privada o frase mnemotécnica con nadie!',
      'error': 'Error',
      'invalidMnemonic': 'Frase mnemotécnica inválida',
      'scanQrCode': 'Escanear Código QR',
      'copied': 'Copiado al portapapeles',
      'scanInstructions': 'Apunta la cámara al código QR',
      'shareAddress': 'Compartir Dirección',
      'addressCopied': 'Dirección copiada al portapapeles',
      'shareAddressMessage': 'Aquí está mi dirección de billetera:',
    },
  };

  String get wallet => _localizedValues[locale.languageCode]?['wallet'] ?? 'Wallet';
  String get createWallet => _localizedValues[locale.languageCode]?['createWallet'] ?? 'Create New Wallet';
  String get importWallet => _localizedValues[locale.languageCode]?['importWallet'] ?? 'Import Wallet';
  String get address => _localizedValues[locale.languageCode]?['address'] ?? 'Wallet Address';
  String get securityWarning => _localizedValues[locale.languageCode]?['securityWarning'] ?? 'Never share your private key or mnemonic phrase with anyone!';
  String get error => _localizedValues[locale.languageCode]?['error'] ?? 'Error';
  String get invalidMnemonic => _localizedValues[locale.languageCode]?['invalidMnemonic'] ?? 'Invalid mnemonic phrase';
  String get scanQrCode => _localizedValues[locale.languageCode]?['scanQrCode'] ?? 'Scan QR Code';
  String get scanInstructions => _localizedValues[locale.languageCode]?['scanInstructions'] ?? 'Point the camera at a QR code';
  String get shareAddress => _localizedValues[locale.languageCode]?['shareAddress'] ?? 'Share Address';
  String get addressCopied => _localizedValues[locale.languageCode]?['addressCopied'] ?? 'Address copied to clipboard';
  String get shareAddressMessage => _localizedValues[locale.languageCode]?['shareAddressMessage'] ?? 'Here is my wallet address:';
  String get copied => _localizedValues[locale.languageCode]?['copied'] ?? 'Copied to clipboard';
}
