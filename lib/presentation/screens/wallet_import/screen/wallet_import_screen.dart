import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/websocket/wallet_balance_state.dart';
import '../../../../providers/accouns_provider.dart';
import '../provider/import_wallet_provider.dart'; // The provider we just created

class WalletImportScreen extends ConsumerStatefulWidget {
  const WalletImportScreen({super.key});

  @override
  ConsumerState<WalletImportScreen> createState() => _WalletImportScreenState();
}

class _WalletImportScreenState extends ConsumerState<WalletImportScreen> {
  final _mnemonicController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final importState = ref.watch(walletImportProvider);
    final _messangerKey = GlobalKey<ScaffoldMessengerState>();

    ref.listen<WalletImportState>(walletImportProvider, (prev, next) {
      if (next.errorMessage != null) {
        _showErrorDialog();
      } else if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
        // _handleSuccess();
      }
    });

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Import Wallet'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Enter your 12-word recovery phrase',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              CupertinoTextField(
                controller: _mnemonicController,
                placeholder: 'Enter mnemonic phrase',
                maxLines: 3,
                padding: const EdgeInsets.all(12),
              ),
              const SizedBox(height: 24),
              if (importState.isLoading)
                const CupertinoActivityIndicator()
              else
                CupertinoButton.filled(
                  onPressed: _importWallet,
                  child: const Text('Import Wallet'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _importWallet() async {
    final mnemonic = _mnemonicController.text.trim();
    final result = await ref
        .read(walletImportProvider.notifier)
        .importWallet(mnemonic.trim(), ref);
    if (result) {
      _handleSuccess();
    }
  }

  void _showErrorDialog([String? errorMessage]) {
    final message = errorMessage ??
        'Sorry, Account not imported. Maybe the private key is invalid or the account already exists. Please check.';

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Import Error'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _handleSuccess() {
    _mnemonicController.clear();
    Future.delayed(const Duration(seconds: 1), () {
      ref.read(walletBalanceProvider.notifier).fetchTransactions(
          ref.watch(accountProvider).selectedAccount?.address ?? '');
      ref.read(walletBalanceProvider.notifier).fetchBalanceHttp(
          ref.watch(accountProvider).selectedAccount?.address ?? '');
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _mnemonicController.dispose();
    super.dispose();
  }
}
