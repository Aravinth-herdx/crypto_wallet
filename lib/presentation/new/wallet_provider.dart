import 'package:crypto_wallet/presentation/new/account_model.dart';
import 'package:crypto_wallet/presentation/new/wallet_creation_notifier.dart';
import 'package:crypto_wallet/presentation/new/wallet_creation_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/wallet/secure_storage_service.dart';
import '../../core/services/wallet/wallet_service.dart';

final walletServiceProvider = Provider((ref) => WalletService());
final secureStorageServiceProvider = Provider((ref) => SecureStorageService());

final walletCreationProvider = StateNotifierProvider<WalletCreationNotifier, WalletCreationState>(
      (ref) => WalletCreationNotifier(
    ref.watch(walletServiceProvider),
    ref.watch(secureStorageServiceProvider),
  ),
);

final walletsProvider = FutureProvider<List<WalletAccount>>((ref) async {
  final walletService = ref.watch(walletServiceProvider);
  final accounts = await walletService.getAccounts();
  print(accounts);
  return accounts.map((account) => WalletAccount.fromJson(account)).toList();
});