import 'package:crypto_wallet/presentation/new/wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';

import '../../core/constants/text_widget.dart';
import '../../core/services/websocket/wallet_balance_state.dart';
import '../../providers/accouns_provider.dart';

class NewWalletScreen extends ConsumerStatefulWidget {
  const NewWalletScreen({super.key});

  @override
  ConsumerState<NewWalletScreen> createState() => _NewWalletScreenState();
}

class _NewWalletScreenState extends ConsumerState<NewWalletScreen> {
  final TextEditingController _passphraseController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  @override
  void dispose() {
    _passphraseController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(walletCreationProvider.notifier).getMnemonic();
    });
    // TODO: implement initState
    super.initState();
  }

  void _handleCreate() async {
    final state = ref.read(walletCreationProvider);

    if (state.isPassphraseEnabled) {
      if (_passphraseController.text != _confirmController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passphrases do not match')),
        );
        return;
      }
      if (_passphraseController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a passphrase')),
        );
        return;
      }
    }

    print(_passphraseController.text);

    await ref.read(walletCreationProvider.notifier).createWallet(
          ref,
          passphrase:
              state.isPassphraseEnabled ? _passphraseController.text : null,
        );

    if (mounted && context.mounted) {
      ref.read(walletBalanceProvider.notifier).fetchTransactions(
          ref.watch(accountProvider).selectedAccount?.address ?? '');
      ref.read(walletBalanceProvider.notifier).fetchBalanceHttp(
          ref.watch(accountProvider).selectedAccount?.address ?? '');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(walletCreationProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const TextWidget(
            textKey: 'cancel',
            style: TextStyle(
              color: Colors.red,
              fontSize: 17,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (state.isLoading)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: CupertinoActivityIndicator(),
            )
          else
            CupertinoButton(
              padding: const EdgeInsets.only(right: 16),
              onPressed: _handleCreate,
              child: const TextWidget(
                textKey: 'create',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 17,
                ),
              ),
            ),
        ],
        title: const TextWidget(
          textKey: 'new_wallet',
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.error != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${state.error!}  error',
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ),

              // Mnemonic Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: ListTile(
                  title: const TextWidget(
                    textKey: 'mnemonic',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 17,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '12 ',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 17,
                        ),
                      ),
                      TextWidget(
                        textKey: 'words',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 17,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Mnemonic Words Grid
              if (state.mnemonicWords != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                state.mnemonicWords![index],
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),

              // Passphrase Toggle
              // Container(
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(10),
              //     border: Border.all(color: Colors.grey.shade200),
              //   ),
              //   child: ListTile(
              //     title: const Text(
              //       'Passphrase',
              //       style: TextStyle(
              //         color: Colors.black87,
              //         fontSize: 17,
              //       ),
              //     ),
              //     trailing: CupertinoSwitch(
              //       value: state.isPassphraseEnabled,
              //       activeColor: Colors.red,
              //       onChanged: (value) {
              //         ref.read(walletCreationProvider.notifier).togglePassphrase(value);
              //       },
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 16),
              //
              // // Passphrase Fields
              // if (state.isPassphraseEnabled) ...[
              //   CupertinoTextField(
              //     controller: _passphraseController,
              //     placeholder: 'Passphrase',
              //     padding: const EdgeInsets.all(16),
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(10),
              //       border: Border.all(color: Colors.grey.shade200),
              //     ),
              //   ),
              //   const SizedBox(height: 16),
              //   CupertinoTextField(
              //     controller: _confirmController,
              //     placeholder: 'Confirm',
              //     padding: const EdgeInsets.all(16),
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(10),
              //       border: Border.all(color: Colors.grey.shade200),
              //     ),
              //   ),
              //   const SizedBox(height: 16),
              // ],
              //
              // // Help Text
              // Text(
              //   'Passphrases add an additional security layer to the wallets, enabling users to create multiple independent multi-coin wallets using a single mnemonic recovery phrase, but associated with different passwords.',
              //   style: TextStyle(
              //     color: Colors.grey[600],
              //     fontSize: 14,
              //     height: 1.5,
              //   ),
              // ),
              // const SizedBox(height: 16),
              // Text(
              //   'To restore these wallets, a user will require a mnemonic recovery phrase as well as a password for each to be restored wallet.',
              //   style: TextStyle(
              //     color: Colors.grey[600],
              //     fontSize: 14,
              //     height: 1.5,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
