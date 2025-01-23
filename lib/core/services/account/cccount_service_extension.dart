import 'package:web3dart/web3dart.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:hex/hex.dart';
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import 'account_service.dart';

// Constants that will be used across the extension
const String walletKey = 'wallet_data';
const storage = FlutterSecureStorage();

class WalletCreationResult {
  final String address;
  final String privateKey;
  final int index;
  final String derivationPath;

  WalletCreationResult({
    required this.address,
    required this.privateKey,
    required this.index,
    required this.derivationPath,
  });

  Map<String, dynamic> toJson() => {
    'address': address,
    'privateKey': privateKey,
    'index': index,
    'derivationPath': derivationPath,
  };
}

extension AccountServiceExtension on AccountService {
  Future<List<WalletCreationResult>> createWalletFromMnemonic({
    required String mnemonic,
    String? passphrase,
    int numberOfAddresses = 1,
    String coinType = "60", // 60 for Ethereum
  }) async {
    if (!bip39.validateMnemonic(mnemonic)) {
      throw Exception('Invalid mnemonic phrase');
    }

    print("Mnemonic validated successfully.");

    final seed = bip39.mnemonicToSeed(mnemonic, passphrase: passphrase ?? '');
    print("Seed generated for mnemonic with passphrase: ${passphrase ?? 'None'}");

    final List<WalletCreationResult> wallets = [];

    for (int i = 0; i < numberOfAddresses; i++) {
      final derivationPath = "m/44'/$coinType'/$i'/0/0";
      print("Deriving wallet at index $i using path: $derivationPath");

      try {
        final key = await ED25519_HD_KEY.derivePath(derivationPath, seed);
        if (key.key.isEmpty) {
          throw Exception('Derived key is empty');
        }

        final privateKey = HEX.encode(key.key);
        if (privateKey.isEmpty) {
          throw Exception('Private key generation failed');
        }

        final credentials = EthPrivateKey.fromHex(privateKey);
        final address = credentials.address.hex;
        if (address.isEmpty) {
          throw Exception('Address generation failed');
        }

        wallets.add(WalletCreationResult(
          address: address,
          privateKey: privateKey,
          index: i,
          derivationPath: derivationPath,
        ));

        print("Wallet $i added with address: $address");
      } catch (e, stackTrace) {
        print("Error generating wallet at index $i: $e\n$stackTrace");
        throw Exception('Error generating wallet at index $i: $e');
      }

    }

    print("All wallets generated successfully. Preparing to store them in secure storage.");

    final existingData = await storage.read(key: walletKey);
    List<Map<String, dynamic>> accounts = existingData != null
        ? List<Map<String, dynamic>>.from(jsonDecode(existingData))
        : [];

    print("Existing accounts retrieved: ${accounts.length}");

    for (var wallet in wallets) {
      final newAliasName = 'Account_${accounts.length + 1}';
      print("Assigning alias name: $newAliasName");

      accounts.add({
        "mnemonic": mnemonic,
        "privateKey": wallet.privateKey,
        "address": wallet.address,
        "passphrase": passphrase,
        "aliasName": newAliasName,
        "derivationPath": wallet.derivationPath,
        "index": wallet.index,
      });

      print("Wallet with alias $newAliasName added to accounts.");
    }

    print("Storing updated accounts list to secure storage.");
    await storage.write(key: walletKey, value: jsonEncode(accounts));
    print("Wallets stored successfully.");

    return wallets;
  }


  Future<WalletCreationResult> getAddressAtIndex({
    required String mnemonic,
    required int index,
    String? passphrase,
    String coinType = "60",
  }) async {
    if (!bip39.validateMnemonic(mnemonic)) {
      throw Exception('Invalid mnemonic phrase');
    }

    final seed = bip39.mnemonicToSeed(mnemonic, passphrase: passphrase ?? '');
    final derivationPath = "m/44'/$coinType'/$index'/0/0";

    try {
      final key = await ED25519_HD_KEY.derivePath(
        derivationPath,
        seed,
      );

      final privateKey = HEX.encode(key.key);
      final credentials = EthPrivateKey.fromHex(privateKey);
      final address = credentials.address.hex;

      return WalletCreationResult(
        address: address,
        privateKey: privateKey,
        index: index,
        derivationPath: derivationPath,
      );
    } catch (e) {
      throw Exception('Error generating wallet at index $index: ${e.toString()}');
    }
  }
}