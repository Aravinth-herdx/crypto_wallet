// import 'dart:math';
// import 'package:bip39/bip39.dart' as bip39;
// import 'package:crypto_wallet/core/services/wallet/secure_storage_service.dart';
//
// import '../../models/wallet_credentials.dart';
//
// class WalletService {
//   final SecureStorageService _secureStorage;
//
//   WalletService(this._secureStorage);
//
//   Future<WalletCredentials> createWallet() async {
//     // In real implementation, use proper wallet creation logic
//     final mnemonic = bip39.generateMnemonic();
//     // Generate proper key pairs based on mnemonic
//     final credentials = WalletCredentials(
//       mnemonic: mnemonic,
//       privateKey: 'generated_private_key',
//       publicKey: 'generated_public_key',
//       walletAddress: 'generated_wallet_address',
//     );
//
//     await _secureStorage.saveWalletCredentials(credentials);
//     return credentials;
//   }
//
//   Future<WalletCredentials> importWallet(String mnemonic) async {
//     // Validate mnemonic and generate wallet
//     if (!bip39.validateMnemonic(mnemonic)) {
//       throw Exception('Invalid mnemonic phrase');
//     }
//
//     // Generate proper key pairs based on mnemonic
//     final credentials = WalletCredentials(
//       mnemonic: mnemonic,
//       privateKey: 'imported_private_key',
//       publicKey: 'imported_public_key',
//       walletAddress: 'imported_wallet_address',
//     );
//
//     await _secureStorage.saveWalletCredentials(credentials);
//     return credentials;
//   }
// }

// import 'dart:convert';
//
// import 'package:web3dart/web3dart.dart';
// import 'package:bip39/bip39.dart' as bip39;
// import 'package:ed25519_hd_key/ed25519_hd_key.dart';
// import 'package:hex/hex.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class WalletService {
//   static const String _infuraUrl = 'https://mainnet.infura.io/v3/98a0c3711b7646d39bdb249029f70c21'; // Replace with your Infura project ID
//   final Web3Client _client;
//   final FlutterSecureStorage _secureStorage;
//   static const String _walletKey = 'wallet_data';
//
//   WalletService() :
//         _client = Web3Client(_infuraUrl, http.Client()),
//         _secureStorage = const FlutterSecureStorage();
//
//   // Generate new wallet
//   Future<Map<String, String>> createWallet() async {
//     // Generate mnemonic
//     final mnemonic = bip39.generateMnemonic();
//
//     // Convert mnemonic to seed
//     final seed = bip39.mnemonicToSeed(mnemonic);
//
//     // Derive private key
//     final masterKey = await ED25519_HD_KEY.getMasterKeyFromSeed(seed);
//     final privateKey = HEX.encode(masterKey.key);
//
//     // Generate Ethereum address
//     final credentials = EthPrivateKey.fromHex(privateKey);
//     final address = credentials.address.hex;
//
//     // Store securely on device
//     await _secureStorage.write(
//         key: _walletKey,
//         value: '''
//       {
//         "mnemonic": "$mnemonic",
//         "privateKey": "$privateKey",
//         "address": "$address"
//       }
//       '''
//     );
//
//     return {
//       'mnemonic': mnemonic,
//       'address': address,
//     };
//   }
//
//   // Import wallet from mnemonic
//   Future<String> importWallet(String mnemonic) async {
//     if (!bip39.validateMnemonic(mnemonic)) {
//       throw Exception('Invalid mnemonic phrase');
//     }
//
//     final seed = bip39.mnemonicToSeed(mnemonic);
//     final masterKey = await ED25519_HD_KEY.getMasterKeyFromSeed(seed);
//     final privateKey = HEX.encode(masterKey.key);
//     final credentials = EthPrivateKey.fromHex(privateKey);
//     final address = credentials.address.hex;
//
//     // Store securely on device
//     await _secureStorage.write(
//         key: _walletKey,
//         value: '''
//       {
//         "mnemonic": "$mnemonic",
//         "privateKey": "$privateKey",
//         "address": "$address"
//       }
//       '''
//     );
//
//     return address;
//   }
//
//   // Get wallet balance
//   Future<EtherAmount> getBalance(String address) async {
//     final ethAddress = EthereumAddress.fromHex(address);
//     return await _client.getBalance(ethAddress);
//   }
//
//   // Send transaction
//   Future<String> sendTransaction({
//     required String toAddress,
//     required BigInt amount,
//   }) async {
//     final walletData = await _secureStorage.read(key: _walletKey);
//     if (walletData == null) throw Exception('No wallet found');
//
//     final data = Map<String, dynamic>.from(json.decode(walletData));
//     final credentials = EthPrivateKey.fromHex(data['privateKey']);
//
//     final transaction = Transaction(
//       to: EthereumAddress.fromHex(toAddress),
//       value: EtherAmount.fromBigInt(EtherUnit.wei, amount),
//       maxGas: 21000, // Standard gas limit for ETH transfers
//     );
//
//     final txHash = await _client.sendTransaction(
//       credentials,
//       transaction,
//       chainId: 1, // 1 for mainnet
//     );
//
//     return txHash;
//   }
//
//   // Get transaction details
//   Future<TransactionInformation?> getTransaction(String txHash) async {
//     return await _client.getTransactionByHash(txHash);
//   }
//
//   // Get current gas price
//   Future<EtherAmount> getGasPrice() async {
//     return await _client.getGasPrice();
//   }
//
//   // Check if wallet exists
//   Future<bool> hasWallet() async {
//     final data = await _secureStorage.read(key: _walletKey);
//     return data != null;
//   }
//
//   // Get current wallet address
//   Future<String?> getCurrentAddress() async {
//     final data = await _secureStorage.read(key: _walletKey);
//     if (data == null) return null;
//     return Map<String, dynamic>.from(json.decode(data))['address'];
//   }
//
//   void dispose() {
//     _client.dispose();
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:web3dart/web3dart.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:hex/hex.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'balance_event.dart';
import 'package:hdkey/hdkey.dart';

class WalletService {
  static const String ethereumUrl =
      'https://sepolia.infura.io/v3/67048bd8b88444cbb4d0aee7adcbffd1';
  static const String ethereumWsUrl =
      'wss://sepolia.infura.io/ws/v3/67048bd8b88444cbb4d0aee7adcbffd1';
  static const String bscUrl = 'https://bsc-dataseed.binance.org/';
  static const String polygonUrl = 'https://polygon-rpc.com';

  final Web3Client _ethereumClient;
  final Web3Client _bscClient;
  final Web3Client _polygonClient;
  final FlutterSecureStorage _secureStorage;
  static const String _walletKey = 'wallet_data';

  // late final WebSocketChannel _wsChannel;
  // StreamSubscription? _wsSubscription;
  // final _transactionController = StreamController<TransactionEvent>.broadcast();
  // final _balanceController = StreamController<BalanceEvent>.broadcast();

  WalletService()
      : _ethereumClient = Web3Client(ethereumUrl, http.Client()),
        _bscClient = Web3Client(bscUrl, http.Client()),
        _polygonClient = Web3Client(polygonUrl, http.Client()),
        _secureStorage = const FlutterSecureStorage();

  Future<String> getMnemonic() async {
    const mnemonicKey = "mnemonic";
    final existingMnemonic = await _secureStorage.read(key: mnemonicKey);

    if (existingMnemonic != null) {
      print("Existing mnemonic found in secure storage. $existingMnemonic");
      return existingMnemonic;
    }

    final newMnemonic = bip39.generateMnemonic(strength: 128);

    if (!bip39.validateMnemonic(newMnemonic)) {
      throw Exception("Generated mnemonic is invalid. Please retry.");
    }

    print("Generated new mnemonic: $newMnemonic");
    await _secureStorage.write(key: mnemonicKey, value: newMnemonic);

    return newMnemonic;
  }

  Future<void> generateWallet({
    required String mnemonic,
    String? passphrase,
  }) async {
    if (!bip39.validateMnemonic(mnemonic)) {
      throw Exception('Invalid mnemonic phrase');
    }

    // Generate seed from mnemonic
    final seed = bip39.mnemonicToSeed(mnemonic, passphrase: passphrase ?? '');

    // Derive the HD wallet and the specific path
    final hdKey = HDKey.fromMasterSeed(seed);
    final derivedWallet = hdKey.derive("m/44'/61'/0'/0/0");

    // Get private key
    final privateKey = HEX.encode(derivedWallet.privateKey!);

    // Create Ethereum credentials
    final credentials = EthPrivateKey.fromHex(privateKey);
    final address = credentials.address.hex;

    print('Address: $address');
    print('Private Key: $privateKey');
  }

  Future<void> generateMultipleWallets({
    required String mnemonic,
    String? passphrase,
    int numberOfAddresses = 10,
  }) async {
    if (!bip39.validateMnemonic(mnemonic)) {
      throw Exception('Invalid mnemonic phrase');
    }

    // Generate seed from mnemonic
    final seed = bip39.mnemonicToSeed(mnemonic, passphrase: passphrase ?? '');

    for (int i = 0; i < numberOfAddresses; i++) {
      // Derive the HD wallet for each address with a different index
      final hdKey = HDKey.fromMasterSeed(seed);
      final derivationPath =
          "m/44'/61'/0'/0/$i"; // Vary the index for each address
      final derivedWallet = hdKey.derive(derivationPath);

      // Get private key
      final privateKey = HEX.encode(derivedWallet.privateKey!);

      // Create Ethereum credentials
      final credentials = EthPrivateKey.fromHex(privateKey);
      final address = credentials.address.hex;

      print('Address $i: $address');
      print('Private Key $i: $privateKey');
    }
  }

  Future<Map<String, String>> generateWalletAddress(
      {String? passphrase, required String mnemonic}) async {
    final seed = bip39.mnemonicToSeed(mnemonic, passphrase: passphrase ?? '');
    final hdKey = HDKey.fromMasterSeed(seed);

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

    // Start with the first derived address
    int index = accounts.length;
    String newAddress = '';
    String newPrivateKey = '';

    while (true) {
      // Derive the next address using the index
      final derivedWallet = hdKey.derive("m/44'/61'/0'/0/$index");
      newPrivateKey = HEX.encode(derivedWallet.privateKey!);

      final credentials = EthPrivateKey.fromHex(newPrivateKey);
      newAddress = credentials.address.hex;

      // Check if the address already exists in local storage
      if (!accounts.any((account) => account["address"] == newAddress)) {
        break;
      }

      // Increment index and try again if the address exists
      index++;
    }

    final newAliasName = 'Account_${accounts.length + 1}';

    print('Account creation');
    print({
      "mnemonic": mnemonic,
      "privateKey": newPrivateKey,
      "address": newAddress,
      "passphrase": passphrase,
      "aliasName": newAliasName,
    });

    // Add the new account details
    accounts.add({
      "mnemonic": mnemonic,
      "privateKey": newPrivateKey,
      "address": newAddress,
      "passphrase": passphrase,
      "aliasName": newAliasName,
    });

    // Store updated accounts in secure storage
    await _secureStorage.write(
      key: _walletKey,
      value: jsonEncode(accounts),
    );

    // await deleteAllAccounts();


    return {
      'mnemonic': mnemonic,
      'address': newAddress,
      'aliasName': newAliasName,
      "privateKey": newPrivateKey,
    };
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

    // Print all accounts to debug
    print('List of all accounts: $accounts');

    // Check if the wallet already exists
    final existingAccount = accounts.firstWhere(
          (account) {
        print('Checking if account address exists:');
        print('Account address: ${account['address']}');
        print('Address being checked: $address');
        return account['address'] == address;
      },
      orElse: () => {}, // Return an empty map if no match is found
    );

    if (existingAccount.isNotEmpty) {
      print('Wallet with this address already exists.');
      print('Duplicate account address: $address');
      throw Exception('Wallet with this address already exists.');
    }


    final newAliasName = 'Account_${accounts.length + 1}';

    // Add the new wallet details
    accounts.add({
      "privateKey": privateKey,
      "address": address,
      "passphrase": passphrase,
      "aliasName": newAliasName,
      'mnemonic': '',
    });

    // Store updated accounts in secure storage
    await _secureStorage.write(
      key: _walletKey,
      value: jsonEncode(accounts),
    );

    print('Before Return ');
    print({
      'privateKey': privateKey,
      'address': address,
      'aliasName': newAliasName
    });

    return {
      'privateKey': privateKey,
      'address': address,
      'mnemonic': '',
      'aliasName': newAliasName
    };
  }

  Future<List<Map<String, String>>> createMultipleWallets({
    String? passphrase,
    required String mnemonic,
    int numberOfAddresses = 10,
    String coinType = "61",
  }) async {
    if (!bip39.validateMnemonic(mnemonic)) {
      throw Exception('Invalid mnemonic phrase');
    }

    final seed = bip39.mnemonicToSeed(mnemonic, passphrase: passphrase ?? '');
    print('Seed generated: ${seed.length} bytes');

    final List<Map<String, String>> wallets = [];

    for (int i = 0; i < numberOfAddresses; i++) {
      final derivationPath = "m/44'/$coinType'/$i'/0/0";

      try {
        if (!RegExp(r"^(m\/)?(\d+'?\/)*\d+'?$").hasMatch(derivationPath)) {
          throw FormatException(
              'Invalid derivation path format: $derivationPath');
        }

        print('Deriving key for path: $derivationPath');
        final key = await ED25519_HD_KEY.derivePath(derivationPath, seed);

        final privateKey = HEX.encode(key.key);
        print('Private key derived for path $derivationPath: $privateKey');

        final credentials = EthPrivateKey.fromHex(privateKey);
        final address = credentials.address.hex;
        print('Address derived for path $derivationPath: $address');

        wallets.add({
          'index': i.toString(),
          'address': address,
          'derivationPath': derivationPath,
          'privateKey': privateKey,
        });
      } catch (e, stackTrace) {
        print('Error deriving address $i: ${e.toString()}');
        print('Stack trace: $stackTrace');
      }
    }

    return wallets;
  }

  Future<List<Map<String, dynamic>>> getAccounts() async {
    print("Reading accounts from secure storage...");
    final existingData = await _secureStorage.read(key: _walletKey);
    List<Map<String, dynamic>> accounts = [];

    if (existingData != null) {
      print("Existing data found in storage.");
      final decodedData = jsonDecode(existingData);

      if (decodedData is List) {
        print("Decoded data is a List.");
        accounts = List<Map<String, dynamic>>.from(decodedData);
      } else if (decodedData is Map) {
        print("Decoded data is a single Map. Wrapping it in a List.");
        accounts = [Map<String, dynamic>.from(decodedData)];
      } else {
        print(
            "Decoded data has an unexpected type: ${decodedData.runtimeType}");
      }
    } else {
      print("No existing data found.");
    }

    // print(accounts.first.values);

    return accounts;
  }

  Future<void> deleteAllAccounts() async {
    try {
      // Delete all accounts data from secure storage
      await _secureStorage.delete(key: _walletKey);
      await _secureStorage.delete(key: 'mnemonicKey');
      await _secureStorage.delete(key: 'mnemonic'); // Add this line to delete mnemonic
      print("All accounts deleted successfully.");
    } catch (e) {
      print("Failed to delete accounts: $e");
    }
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

  Future<Map<String, dynamic>> fetchBalances(String address) async {
    final ethAddress = EthereumAddress.fromHex(address);
    try {
      final ethBalance = await _ethereumClient.getBalance(ethAddress);
      final bnbBalance = await _bscClient.getBalance(ethAddress);
      final maticBalance = await _polygonClient.getBalance(ethAddress);

      return {
        "ETH": ethBalance.getValueInUnit(EtherUnit.ether),
        "BNB": bnbBalance.getValueInUnit(EtherUnit.ether),
        "MATIC": maticBalance.getValueInUnit(EtherUnit.ether),
      };
    } catch (e) {
      throw Exception('Error fetching balances: $e');
    }
  }

  Future<EtherAmount> getBalance(String address, {String chain = 'ETH'}) async {
    final ethAddress = EthereumAddress.fromHex(address);
    Web3Client client;
    print(await _bscClient.getBalance(ethAddress));
    print(await _polygonClient.getBalance(ethAddress));
    print(await _ethereumClient.getBalance(ethAddress));
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
    return await client.getBalance(ethAddress);
  }

  Future<String> sendTransaction({
    required String toAddress,
    required BigInt amount,
    String chain = 'ETH',
  }) async {
    final walletData = await _secureStorage.read(key: _walletKey);
    if (walletData == null) throw Exception('No wallet found');

    final data = jsonDecode(walletData);
    final credentials = EthPrivateKey.fromHex(data['privateKey']);
    final ethAddress = EthereumAddress.fromHex(toAddress);

    Web3Client client;
    int chainId;
    switch (chain) {
      case 'BNB':
        client = _bscClient;
        chainId = 56; // BSC Mainnet
        break;
      case 'MATIC':
        client = _polygonClient;
        chainId = 137; // Polygon Mainnet
        break;
      default:
        client = _ethereumClient;
        chainId = 1; // Ethereum Mainnet
    }

    final transaction = Transaction(
      to: ethAddress,
      value: EtherAmount.fromBigInt(EtherUnit.wei, amount),
      maxGas: 21000,
    );

    return await client.sendTransaction(credentials, transaction,
        chainId: chainId);
  }

  Future<void> fetchTransactions(String walletAddress) async {
    final String apiUrl = "https://api-sepolia.etherscan.io/api"
        "?module=account"
        "&action=txlist"
        "&address=$walletAddress"
        "&startblock=0"
        "&endblock=99999999"
        "&page=1"
        "&offset=10"
        "&sort=desc"
        "&apikey=HDAGTQ9FMQ7GKCI3ERRJYER5GBN75VB974";

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == '1') {
          // setState(() {
          //   transactions = data['result'];
          //   isLoading = false;
          // });
        }
      }
    } catch (e) {
      print('Error fetching transactions: $e');
    }
  }

  Future<bool> hasWallet() async {
    return await _secureStorage.read(key: _walletKey) != null;
  }

  Future<String?> getCurrentAddress() async {
    final walletData = await _secureStorage.read(key: _walletKey);
    if (walletData == null) return null;
    return jsonDecode(walletData)['address'];
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
