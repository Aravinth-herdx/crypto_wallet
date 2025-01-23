import 'package:crypto_wallet/core/services/account/account_service.dart';
import 'package:crypto_wallet/core/services/account/cccount_service_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:bip39/bip39.dart' as bip39;
// import 'package:ed25519_hd_key/ed25519_hd_key.dart';
// import 'package:hex/hex.dart';

import '../../core/models/wallet.dart';


// class WalletNotifier extends StateNotifier<AsyncValue<Wallet?>> {
//   WalletNotifier() : super(const AsyncValue.data(null));
//
//   Future<void> createWallet() async {
//     try {
//       state = const AsyncValue.loading();
//       final mnemonic = bip39.generateMnemonic();
//       final wallet = await _createWalletFromMnemonic(mnemonic);
//       state = AsyncValue.data(wallet);
//     } catch (e, stack) {
//       state = AsyncValue.error(e, stack);
//     }
//   }
//
//   Future<void> importWallet(String mnemonic) async {
//     try {
//       state = const AsyncValue.loading();
//       if (!bip39.validateMnemonic(mnemonic)) {
//         throw Exception('Invalid mnemonic phrase');
//       }
//       final wallet = await _createWalletFromMnemonic(mnemonic);
//       state = AsyncValue.data(wallet);
//     } catch (e, stack) {
//       state = AsyncValue.error(e, stack);
//     }
//   }
//
//   Future<Wallet> _createWalletFromMnemonic(String mnemonic) async {
//     final seed = bip39.mnemonicToSeed(mnemonic);
//     final master = await ED25519_HD_KEY.getMasterKeyFromSeed(seed);
//     final privateKey = HEX.encode(master.key);
//     // Note: In a real implementation, you would derive the public key and address
//     // using the specific blockchain's derivation path and encoding
//     final publicKey = 'dummy_public_key_${privateKey.substring(0, 10)}';
//     final address = 'dummy_address_${privateKey.substring(0, 10)}';
//
//     return Wallet(
//       address: address,
//       publicKey: publicKey,
//       privateKey: privateKey,
//       mnemonic: mnemonic,
//     );
//   }
// }


import 'package:web3dart/web3dart.dart';

import '../../core/services/wallet/wallet_service.dart';

class WalletState {
  final String? address;
  final EtherAmount? balance;
  final bool isLoading;
  final String? error;

  WalletState({
    this.address,
    this.balance,
    this.isLoading = false,
    this.error,
  });

  WalletState copyWith({
    String? address,
    EtherAmount? balance,
    bool? isLoading,
    String? error,
  }) {
    return WalletState(
      address: address ?? this.address,
      balance: balance ?? this.balance,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class WalletNotifier extends StateNotifier<WalletState> {
  final WalletService _walletService;

  WalletNotifier(this._walletService) : super(WalletState()) {
    _initializeWallet();
  }

  Future<void> _initializeWallet() async {
    try {
      state = state.copyWith(isLoading: true);

      final address = await _walletService.getCurrentAddress();
      if (address != null) {
        final balance = await _walletService.getBalance(address);
        state = state.copyWith(
          address: address,
          balance: balance,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> createWallet() async {
    try {
      print("Starting wallet creation...");
      state = state.copyWith(isLoading: true);
      print("State set to loading: $state");

      final walletData = await _walletService.generateWalletAddress(mnemonic: '');

      print("Wallet data received: $walletData");

      final balance = await _walletService.getBalance(walletData['address']!);
      print("Balance fetched: $balance");

      state = state.copyWith(
        address: walletData['address'],
        balance: balance,
        isLoading: false,
      );
      print("State updated with new wallet data: $state");
    } catch (e) {
      print("Error occurred: $e");
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      print("State updated with error: $state");
    }
  }


  Future<void> importWallet(String mnemonic) async {
    try {
      state = state.copyWith(isLoading: true);

      final address = await _walletService.importWallet(mnemonic);
      final balance = await _walletService.getBalance(address);

      state = state.copyWith(
        address: address,
        balance: balance,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> refreshBalance() async {
    if (state.address == null) return;

    try {
      final balance = await _walletService.getBalance(state.address!);
      state = state.copyWith(balance: balance);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}