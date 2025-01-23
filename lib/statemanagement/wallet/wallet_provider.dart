import 'package:crypto_wallet/statemanagement/wallet/wallet_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/wallet.dart';
import '../../core/services/wallet/wallet_service.dart';

// final walletProvider = StateNotifierProvider<WalletNotifier, AsyncValue<Wallet?>>((ref) {
//   return WalletNotifier();
// });


final walletProvider = StateNotifierProvider<WalletNotifier, WalletState>((ref) {
  final walletService = WalletService();
  return WalletNotifier(walletService);
});