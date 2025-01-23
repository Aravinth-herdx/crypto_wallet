// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'dart:convert';
//
// import '../../models/wallet_credentials.dart';
//
// class SecureStorageService {
//   final _storage = const FlutterSecureStorage();
//
//   Future<void> saveWalletCredentials(WalletCredentials credentials) async {
//     await _storage.write(
//       key: 'wallet_credentials',
//       value: jsonEncode(credentials.toJson()),
//     );
//   }
//
//   Future<WalletCredentials?> getWalletCredentials() async {
//     final data = await _storage.read(key: 'wallet_credentials');
//     if (data == null) return null;
//     return WalletCredentials.fromJson(jsonDecode(data));
//   }
// }
//

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();
  static const _walletKey = 'wallet_data';

  Future<void> saveWalletData({
    required String privateKey,
    required String address,
    required String mnemonic,
    String? passphrase,
  }) async {
    try {
      print("Reading existing wallet data from secure storage...");
      final existingData = await _storage.read(key: _walletKey);
      List<Map<String, dynamic>> walletList = [];

      if (existingData != null && existingData.isNotEmpty) {
        print("Existing wallet data found. Parsing data...");
        try {
          walletList = List<Map<String, dynamic>>.from(jsonDecode(existingData));
          print("Existing wallet data parsed successfully.");
        } catch (e) {
          print("Failed to parse existing wallet data: $e");
        }
      } else {
        print("No existing wallet data found. Initializing a new list.");
      }

      print("Adding new wallet data to the list...");
      walletList.add({
        'privateKey': privateKey,
        'address': address,
        'mnemonic': mnemonic,
        'passphrase': passphrase ?? '',
      });

      print("Storing updated wallet list in secure storage...");
      await _storage.write(
        key: _walletKey,
        value: jsonEncode(walletList),
      );
      print("Updated wallet list stored successfully.");
    } catch (e) {
      print("Failed to save wallet data: $e");
      rethrow; // Optional: rethrow the error for higher-level handling
    }
  }



  Future<Map<String, dynamic>?> getWalletData() async {
    final data = await _storage.read(key: _walletKey);
    if (data == null) return null;
    return json.decode(data) as Map<String, dynamic>;
  }

  Future<void> deleteWalletData() async {
    await _storage.delete(key: _walletKey);
  }

  Future<bool> hasWallet() async {
    return await _storage.containsKey(key: _walletKey);
  }
}