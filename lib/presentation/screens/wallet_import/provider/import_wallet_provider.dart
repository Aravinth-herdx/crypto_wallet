import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web3dart/web3dart.dart';
import 'package:hex/hex.dart';

import '../../../../core/services/wallet/wallet_service.dart';
import '../../../../core/services/websocket/wallet_balance_state.dart';
import '../../../../providers/accouns_provider.dart';
import '../../../new/wallet_provider.dart';

class WalletImportState {
  final bool isLoading;
  final String? errorMessage;

  WalletImportState({
    this.isLoading = false,
    this.errorMessage,
  });

  WalletImportState copyWith({
    bool? isLoading,
    String? errorMessage,
  }) =>
      WalletImportState(
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}

class WalletImportNotifier extends StateNotifier<WalletImportState> {
  final WalletService _walletService;
  final AccountNotifier _accountNotifier;

  WalletImportNotifier(this._walletService, this._accountNotifier)
      : super(WalletImportState());

  Future<bool> importWallet(String privateKey, WidgetRef ref) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      if (!_validatePrivateKey(privateKey)) {
        throw Exception('Invalid private key format');
      }

      privateKey =
          privateKey.startsWith('0x') ? privateKey.substring(2) : privateKey;

      final result = await _walletService.importWalletAddress(
        privateKey: privateKey,
      );

      await ref.read(accountProvider.notifier).addWalletAccount(
          result['address']!, result['privateKey']!,
          isImported: true);
      ref
          .read(walletBalanceProvider.notifier)
          .setAddress(result['address'] ?? '');

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  bool _validatePrivateKey(String privateKey) {
    try {
      // Remove '0x' prefix if present (Ethereum or Ethereum Classic may have it)
      privateKey =
          privateKey.startsWith('0x') ? privateKey.substring(2) : privateKey;

      // Check if the key is 64 characters long
      if (privateKey.length != 64) {
        return false;
      }

      // Validate hexadecimal characters
      try {
        HEX.decode(privateKey);
      } catch (e) {
        return false;
      }

      // Try creating credentials from the private key
      try {
        EthPrivateKey.fromHex(privateKey);
      } catch (e) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}

final walletImportProvider =
    StateNotifierProvider<WalletImportNotifier, WalletImportState>((ref) {
  return WalletImportNotifier(
    ref.watch(walletServiceProvider),
    ref.watch(accountProvider.notifier),
  );
});
