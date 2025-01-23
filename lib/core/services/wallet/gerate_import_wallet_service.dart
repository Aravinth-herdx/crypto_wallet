import 'dart:async';
import 'dart:convert';
import 'package:web3dart/web3dart.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:hex/hex.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hdkey/hdkey.dart';

class GenerateAndImportWalletService {
  static const String ethereumUrl = 'https://sepolia.infura.io/v3/67048bd8b88444cbb4d0aee7adcbffd1';
  static const String bscUrl = 'https://bsc-dataseed.binance.org/';
  static const String polygonUrl = 'https://polygon-rpc.com';

  final Web3Client _ethereumClient;
  final Web3Client _bscClient;
  final Web3Client _polygonClient;
  final FlutterSecureStorage _secureStorage;
  static const String _walletKey = 'wallet_data';

  GenerateAndImportWalletService()
      : _ethereumClient = Web3Client(ethereumUrl, http.Client()),
        _bscClient = Web3Client(bscUrl, http.Client()),
        _polygonClient = Web3Client(polygonUrl, http.Client()),
        _secureStorage = const FlutterSecureStorage();

  Future<Map<String, String>> generateWalletAddress({String? passphrase, required String mnemonic}) async {
    final seed = bip39.mnemonicToSeed(mnemonic, passphrase: passphrase ?? '');
    final hdKey = HDKey.fromMasterSeed(seed);

    final existingData = await _secureStorage.read(key: _walletKey);
    List<Map<String, dynamic>> accounts = [];

    if (existingData != null) {
      final decodedData = jsonDecode(existingData);
      if (decodedData is List) {
        accounts = List<Map<String, dynamic>>.from(decodedData);
      } else if (decodedData is Map) {
        accounts = [Map<String, dynamic>.from(decodedData)];
      }
    }

    int index = accounts.length;
    String newAddress = '';
    String newPrivateKey = '';

    while (true) {
      final derivedWallet = hdKey.derive("m/44'/61'/0'/0/$index");
      newPrivateKey = HEX.encode(derivedWallet.privateKey!);

      final credentials = EthPrivateKey.fromHex(newPrivateKey);
      newAddress = credentials.address.hex;

      if (!accounts.any((account) => account["address"] == newAddress)) {
        break;
      }
      index++;
    }

    final newAliasName = 'Account_${accounts.length + 1}';

    accounts.add({
      "mnemonic": mnemonic,
      "privateKey": newPrivateKey,
      "address": newAddress,
      "passphrase": passphrase,
      "aliasName": newAliasName,
    });

    await _secureStorage.write(
      key: _walletKey,
      value: jsonEncode(accounts),
    );

    return {'mnemonic': mnemonic, 'address': newAddress, 'aliasName': newAliasName};
  }

  Future<Map<String, String>> importWalletAddress({
    required String privateKey,
    String? passphrase,
  }) async {
    final credentials = EthPrivateKey.fromHex(privateKey);
    final address = credentials.address.hex;

    // Read the existing accounts from secure storage
    final existingData = await _secureStorage.read(key: _walletKey);
    List<Map<String, dynamic>> accounts = [];

    if (existingData != null) {
      final decodedData = jsonDecode(existingData);

      if (decodedData is List) {
        accounts = List<Map<String, dynamic>>.from(decodedData);
      } else if (decodedData is Map) {
        accounts = [Map<String, dynamic>.from(decodedData)];
      }
    }

    // Check if the wallet already exists
    if (accounts.any((account) => account['address'] == address)) {
      throw Exception('Wallet with this address already exists.');
    }

    final newAliasName = 'Account_${accounts.length + 1}';

    print({
      "privateKey": privateKey,
      "address": address,
      "passphrase": passphrase,
      "aliasName": newAliasName,
    });

    // Add the new wallet details
    accounts.add({
      "privateKey": privateKey,
      "address": address,
      "passphrase": passphrase,
      "aliasName": newAliasName,
    });

    // Store updated accounts in secure storage
    await _secureStorage.write(
      key: _walletKey,
      value: jsonEncode(accounts),
    );

    return {'privateKey': privateKey, 'address': address, 'aliasName': newAliasName};
  }


  void dispose() {
    _ethereumClient.dispose();
    _bscClient.dispose();
    _polygonClient.dispose();
  }
}
