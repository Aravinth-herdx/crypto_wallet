import 'dart:async';
import 'dart:convert';
import 'package:web3dart/web3dart.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:hex/hex.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AccountService {
  static const String ethereumUrl = 'https://sepolia.infura.io/v3/67048bd8b88444cbb4d0aee7adcbffd1';
  static const String bscUrl = 'https://bsc-dataseed.binance.org/';
  static const String polygonUrl = 'https://polygon-rpc.com';

  final Web3Client _ethereumClient;
  final Web3Client _bscClient;
  final Web3Client _polygonClient;
  final FlutterSecureStorage _secureStorage;
  static const String _walletKey = 'wallet_data';

  AccountService()
      : _ethereumClient = Web3Client(ethereumUrl, http.Client()),
        _bscClient = Web3Client(bscUrl, http.Client()),
        _polygonClient = Web3Client(polygonUrl, http.Client()),
        _secureStorage = const FlutterSecureStorage();

  Future<String> getMnemonic() async {
    const mnemonicKey = "mnemonic";
    final existingMnemonic = await _secureStorage.read(key: mnemonicKey);

    if (existingMnemonic != null) return existingMnemonic;

    final newMnemonic = bip39.generateMnemonic(strength: 128);

    if (!bip39.validateMnemonic(newMnemonic)) {
      throw Exception("Generated mnemonic is invalid. Please retry.");
    }

    await _secureStorage.write(key: mnemonicKey, value: newMnemonic);
    return newMnemonic;
  }

  Future<Map<String, String>> createWallet({
    String? passphrase,
    required String mnemonic,
  }) async {
    final seed = bip39.mnemonicToSeed(mnemonic, passphrase: passphrase ?? '');
    print(seed);
    final masterKey = await ED25519_HD_KEY.getMasterKeyFromSeed(seed);
    final privateKey = HEX.encode(masterKey.key);
    final credentials = EthPrivateKey.fromHex(privateKey);
    final address = credentials.address.hex;

    final existingData = await _secureStorage.read(key: _walletKey);
    List<Map<String, dynamic>> accounts = existingData != null
        ? List<Map<String, dynamic>>.from(jsonDecode(existingData))
        : [];

    final newAliasName = 'Account_${accounts.length + 1}';

    accounts.add({
      "mnemonic": mnemonic,
      "privateKey": privateKey,
      "address": address,
      "passphrase": passphrase,
      "aliasName": newAliasName,
    });

    await _secureStorage.write(key: _walletKey, value: jsonEncode(accounts));

    return {'mnemonic': mnemonic, 'address': address, 'aliasName': newAliasName};
  }

  Future<List<Map<String, dynamic>>> getAccounts() async {
    final existingData = await _secureStorage.read(key: _walletKey);
    if (existingData != null) {
      return List<Map<String, dynamic>>.from(jsonDecode(existingData));
    }
    return [];
  }

  Future<void> deleteAllAccounts() async {
    await _secureStorage.delete(key: _walletKey);
  }

  Future<String> importWallet(String mnemonic) async {
    if (!bip39.validateMnemonic(mnemonic)) {
      throw Exception('Invalid mnemonic phrase');
    }

    final seed = bip39.mnemonicToSeed(mnemonic);
    final masterKey = await ED25519_HD_KEY.getMasterKeyFromSeed(seed);
    final privateKey = HEX.encode(masterKey.key);
    final credentials = EthPrivateKey.fromHex(privateKey);
    final address = credentials.address.hex;

    await _secureStorage.write(
      key: _walletKey,
      value: jsonEncode({
        "mnemonic": mnemonic,
        "privateKey": privateKey,
        "address": address,
      }),
    );

    return address;
  }

  Future<EtherAmount> getGasPrice({String chain = 'ETH'}) async {
    Web3Client client;
    switch (chain) {
      case 'BNB':
        client = _bscClient;
        break;
      case 'MATIC':
        client = _polygonClient;
        break;
      default:
        client = _ethereumClient;
    }
    return await client.getGasPrice();
  }

  void dispose() {
    _ethereumClient.dispose();
    _bscClient.dispose();
    _polygonClient.dispose();
  }
}
