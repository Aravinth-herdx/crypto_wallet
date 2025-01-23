import 'package:crypto_wallet/core/services/account/cccount_service_extension.dart';
import 'package:crypto_wallet/presentation/new/wallet_creation_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/account/account_service.dart';
import '../../core/services/wallet/secure_storage_service.dart';
import '../../core/services/wallet/wallet_service.dart';
import '../../providers/accouns_provider.dart';

class WalletCreationNotifier extends StateNotifier<WalletCreationState> {
  final WalletService _walletService;
  final SecureStorageService _secureStorage;

  WalletCreationNotifier(this._walletService, this._secureStorage)
      : super(WalletCreationState());

  void togglePassphrase(bool value) {
    state = state.copyWith(isPassphraseEnabled: value);
  }



  Future<void> getMnemonic({String? passphrase}) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final walletData = await _walletService.getMnemonic();

      state = state.copyWith(
        isLoading: false,
        mnemonic: walletData,
        mnemonicWords: walletData?.split(' '),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to create wallet: ${e.toString()}',
      );
    }
  }


  Future<void> createWallet(WidgetRef ref,{String? passphrase}) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final walletData = await _walletService.generateWalletAddress(
          passphrase: passphrase,
          mnemonic: state.mnemonic!
      );
      print('address created');
      print(walletData['address']);
      print(walletData['mnemonic']?.split(' '));
      print(walletData['privateKey']);

      // Add the new wallet address to accounts
      await ref.read(accountProvider.notifier).addWalletAccount(walletData['address']!,walletData['privateKey']!);
      print('account added created');
      print(walletData['address']);
      print(walletData['mnemonic']?.split(' '));
      // await _walletService.deleteAllAccounts();
      state = state.copyWith(
        isLoading: false,
        address: walletData['address'],
        mnemonicWords: walletData['mnemonic']?.split(' '),
      );
    } catch (e) {
      print('---------- Error -----------');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to create wallet: ${e.toString()}',
      );
    }
  }
}
