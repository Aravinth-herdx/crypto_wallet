import 'package:crypto_wallet/core/services/websocket/wallet_balance_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/text_widget.dart';
import '../../../../core/localization/localization_provider.dart';
import '../../../../providers/accouns_provider.dart';
import '../../../new/wallet_creation.dart';
import '../../../new/wallet_provider.dart';
import '../../detail/account_detail.dart';
import '../../wallet_import/screen/wallet_import_screen.dart';
import '../models/account.dart';

class AccountSelector extends ConsumerStatefulWidget {
  const AccountSelector({super.key});

  @override
  ConsumerState<AccountSelector> createState() => _AccountSelectorState();
}

class _AccountSelectorState extends ConsumerState<AccountSelector> {
  void _showAccountMenu(BuildContext context) {
    final accountState = ref.read(accountProvider);

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground,
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: CupertinoColors.separator,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const TextWidget(
                      textKey: 'my_accounts',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const TextWidget(
                        textKey: 'done',
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    _buildActionButton(
                      'create_account',
                      CupertinoIcons.plus_circle_fill,
                      () {
                        Navigator.pop(context);
                        _showCreateAccountDialog(context);
                      },
                    ),
                    _buildActionButton(
                      'import_account',
                      CupertinoIcons.arrow_down_circle_fill,
                      () {
                        Navigator.pop(context);
                        _showImportAccountDialog(context);
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: const TextWidget(
                        textKey: 'my_wallets',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ),
                    ...accountState.accounts.asMap().entries.map((entry) {
                      final int idx = entry.key;
                      final AccountNew account = entry.value;
                      return _buildAccountItem(idx, account);
                    }).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountItem(int index, AccountNew account) {
    final accountState = ref.watch(accountProvider);
    final isSelected = accountState.selectedAccount?.address == account.address;
    final formattedAddress =
        '${account.address.substring(0, 6)}...${account.address.substring(account.address.length - 4)}';

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        ref.read(accountProvider.notifier).selectAccount(account);
        ref.read(walletBalanceProvider.notifier).fetchTransactions(
            ref.watch(accountProvider).selectedAccount?.address ?? '');
        ref.read(walletBalanceProvider.notifier).fetchBalanceHttp(
            ref.watch(accountProvider).selectedAccount?.address ?? '');
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? CupertinoColors.systemGrey6 : null,
          border: const Border(
            bottom: BorderSide(
              color: CupertinoColors.separator,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey5,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                account.isImported
                    ? CupertinoIcons.arrow_down_circle_fill
                    : CupertinoIcons.person_circle_fill,
                color: CupertinoColors.systemGrey,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      if (account.isImported)
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: CupertinoColors.systemGrey5,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const TextWidget(
                              textKey: 'imported',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: CupertinoColors.systemGrey,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedAddress,
                    style: const TextStyle(
                      color: CupertinoColors.systemGrey,
                      fontSize: 13,
                    ),
                    maxLines: 1, // Restrict the address to a single line
                    overflow: TextOverflow
                        .ellipsis, // Handle long addresses gracefully
                  ),
                ],
              ),
            ),

            // const Spacer(),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(
                CupertinoIcons.eye,
                color: CupertinoColors.systemGrey, // Changed color
                size: 20.0, // Reduced size
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) =>
                        AccountDetailsScreen(account: account),
                  ),
                );
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${account.balance.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const Text(
                  'USD',
                  style: TextStyle(
                    color: CupertinoColors.systemGrey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      String title, IconData icon, VoidCallback onPressed) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(
            icon,
            color: CupertinoColors.activeBlue,
          ),
          const SizedBox(width: 12),
          TextWidget(
            textKey: title,
            style: const TextStyle(
              color: CupertinoColors.activeBlue,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateAccountDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const TextWidget(
          textKey: 'create_new_account',
        ),
        // content: const Text('Enter account name'),
        actions: [
          CupertinoDialogAction(
            child: const TextWidget(
              textKey: 'cancel',
            ),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            child: const TextWidget(
              textKey: 'create',
            ),
            onPressed: () async {
              // final amount = BigInt.from(0.001 * 1e18);
              // print(amount);// Convert 0.01 ETH to wei
              // await ref.read(walletCreationProvider.notifier).sendTransaction(
              //   toAddress: '0x49534011FB6caC5aaDA5E5C993E256fB2AeA391D',
              //   amount: amount,
              //   fromAddress: '0xbEdd0E92F555A369Db152A0dA500628d721faD56',
              // );
              // Navigator.pop(context);
              // Implement account creation logic
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewWalletScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showImportAccountDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const TextWidget(
          textKey: 'import_account',
        ),
        // content: const Text('Enter private key'),
        actions: [
          CupertinoDialogAction(
            child: const TextWidget(
              textKey: 'cancel',
            ),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            child: const TextWidget(
              textKey: 'import',
            ),
            onPressed: () {
              // Implement account import logic
              Navigator.pop(context);
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) =>
                      const WalletImportScreen(), // Navigate to WalletImportScreen using CupertinoPageRoute
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accountState = ref.watch(accountProvider);
    final accounts = accountState.accounts;
    final selectedAccount = accountState.selectedAccount;

    if (accounts.isEmpty) {
      return Row(
        children: [
          _buildActionButton(
            'create_account',
            CupertinoIcons.plus_circle_fill,
            () => _showCreateAccountDialog(context),
          ),
          _buildActionButton(
            'import_account',
            CupertinoIcons.arrow_down_circle_fill,
            () => _showImportAccountDialog(context),
          ),
        ],
      );
    }
    if (selectedAccount == null) {
      return const SizedBox.shrink(); // or loading indicator
    }

    final formattedAddress =
        '${selectedAccount.address.substring(0, 6)}...${selectedAccount.address.substring(selectedAccount.address.length - 4)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Consumer(
              builder: (context, ref, child) {
                ref.watch(languageProvider);
                return Text(
                  localizedText('current_account'),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.systemGrey,
                  ),
                );
              },
            )),
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => _showAccountMenu(context),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: CupertinoColors.systemGrey4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey5,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        selectedAccount.isImported
                            ? CupertinoIcons.arrow_down_circle_fill
                            : CupertinoIcons.person_circle_fill,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              selectedAccount.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            if (selectedAccount.isImported)
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: CupertinoColors.systemGrey5,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'Imported',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: CupertinoColors.systemGrey,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formattedAddress,
                          style: const TextStyle(
                            color: CupertinoColors.systemGrey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Icon(CupertinoIcons.chevron_down),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
