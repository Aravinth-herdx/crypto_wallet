import 'package:web3dart/web3dart.dart';

class WalletAccount {
  final String address;
  final String name;
  final EtherAmount balance;
  final int index;

  WalletAccount({
    required this.address,
    required this.name,
    required this.balance,
    required this.index,
  });

  WalletAccount copyWith({
    String? address,
    String? name,
    EtherAmount? balance,
    int? index,
  }) {
    return WalletAccount(
      address: address ?? this.address,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      index: index ?? this.index,
    );
  }
}

class WalletState {
  final List<WalletAccount> accounts;
  final int selectedAccountIndex;
  final bool isLoading;
  final String? error;
  final bool hasBackup;

  WalletState({
    this.accounts = const [],
    this.selectedAccountIndex = 0,
    this.isLoading = false,
    this.error,
    this.hasBackup = false,
  });

  WalletAccount? get selectedAccount =>
      accounts.isNotEmpty ? accounts[selectedAccountIndex] : null;

  WalletState copyWith({
    List<WalletAccount>? accounts,
    int? selectedAccountIndex,
    bool? isLoading,
    String? error,
    bool? hasBackup,
  }) {
    return WalletState(
      accounts: accounts ?? this.accounts,
      selectedAccountIndex: selectedAccountIndex ?? this.selectedAccountIndex,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasBackup: hasBackup ?? this.hasBackup,
    );
  }
}
