import 'package:crypto_wallet/presentation/screens/home/models/account.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/wallet/wallet_service.dart';
import '../presentation/new/wallet_provider.dart';

class AccountState {
  final List<AccountNew> accounts;
  final AccountNew? selectedAccount;

  AccountState({
    this.accounts = const [],
    this.selectedAccount,
  });

  AccountState copyWith({
    List<AccountNew>? accounts,
    AccountNew? selectedAccount,
  }) {
    return AccountState(
      accounts: accounts ?? this.accounts,
      selectedAccount: selectedAccount ?? this.selectedAccount,
    );
  }
}

class AccountNotifier extends StateNotifier<AccountState> {
  final WalletService _walletService;

  AccountNotifier(this._walletService) : super(AccountState()) {
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    try {
      final storedAccounts = await _walletService.getAccounts();

      final accounts = storedAccounts.map((account) {
        return AccountNew(
          name: account['aliasName'] ?? 'Account',
          address: account['address'],
          balance: 0.0, // You might want to fetch real balance here
          isImported: account['mnemonic'] != '' ? false : true,
          privateKey: account['privateKey']
        );
      }).toList();

      if (accounts.isNotEmpty) {
        state = state.copyWith(
          accounts: accounts,
          selectedAccount: accounts.first,
        );
      }
    } catch (e) {
      print('Failed to load accounts: $e');
    }
  }

  Future<void> addWalletAccount(String address,String privateKey,{bool? isImported}) async {
    print('inside Add Wallet');
    try {
      final balance = await _walletService.getBalance(address);

      final newAccount = AccountNew(
        isImported: isImported ?? false,
        name: 'Account ${state.accounts.length + 1}',
        address: address,
        balance: 0.0,
        privateKey: privateKey
      );

      final updatedAccounts = [...state.accounts, newAccount];

      state = state.copyWith(
        accounts: updatedAccounts,
        selectedAccount: newAccount,
      );
    } catch (e) {
      print('Failed to add account: $e');
    }
  }

  void selectAccount(AccountNew account) {
    state = state.copyWith(selectedAccount: account);
  }
}

// Provider setup remains the same
final accountProvider = StateNotifierProvider<AccountNotifier, AccountState>((ref) {
  return AccountNotifier(
    ref.watch(walletServiceProvider),
  );
});