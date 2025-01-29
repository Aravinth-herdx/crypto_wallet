import 'package:crypto_wallet/core/services/websocket/wallet_balance_provider.dart';
import 'package:crypto_wallet/presentation/screens/home/models/currency_model.dart';
import 'package:crypto_wallet/presentation/screens/home/models/transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletBalanceState {
  final String network;
  final String address;
  final bool isLoading;
  final bool isError;
  final String balance;
  final List<Transaction> transaction;
  final List<CurrencyModel> currency;
  final double ethPrice;

  WalletBalanceState({
    required this.network,
    required this.address,
    this.isLoading = false,
    this.isError = false,
    this.balance = '0.0',
    this.transaction = const [],
    this.currency = const [],
    this.ethPrice = 0.0,
  });

  WalletBalanceState copyWith({
    String? network,
    String? address,
    bool? isLoading,
    bool? isError,
    String? balance,
    List<Transaction>? transaction,
    List<CurrencyModel>? currency,
    double? ethPrice,
  }) {
    return WalletBalanceState(
      network: network ?? this.network,
      address: address ?? this.address,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      balance: balance ?? this.balance,
      transaction: transaction ?? this.transaction,
      currency: currency ?? this.currency,
      ethPrice: ethPrice ?? this.ethPrice,
    );
  }
}

final walletBalanceProvider =
    StateNotifierProvider<WalletBalanceProvider, WalletBalanceState>((ref) {
  return WalletBalanceProvider();
});
