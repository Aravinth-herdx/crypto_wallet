import 'package:crypto_wallet/core/services/websocket/wallet_balance_state.dart';
import 'package:crypto_wallet/presentation/screens/home/widgets/account_selector.dart';
import 'package:crypto_wallet/presentation/screens/home/widgets/network_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/accouns_provider.dart';
import '../../widgets/balance_card.dart';
import '../../widgets/token_list.dart';

class HomeScreenNew extends ConsumerWidget {
  const HomeScreenNew({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(accountProvider);

    final List<Map<String, String>> tokens = [
      {
        'symbol': 'ETH',
        'name': 'Ethereum',
        'balance': '2.5',
        'value': '4,500.00',
        'change': '+2.5%',
        'icon': '🌐',
      },
      {
        'symbol': 'BNB',
        'name': 'Binance Coin',
        'balance': '10.0',
        'value': '3,000.00',
        'change': '-1.2%',
        'icon': '💎',
      },
      {
        'symbol': 'MATIC',
        'name': 'Polygon',
        'balance': '1000.0',
        'value': '1,200.00',
        'change': '+5.7%',
        'icon': '⚡',
      },
      {
        'symbol': 'SOL',
        'name': 'Solana',
        'balance': '50.0',
        'value': '5,000.00',
        'change': '-0.8%',
        'icon': '☀️',
      },
      {
        'symbol': 'USDT',
        'name': 'Tether',
        'balance': '1000.0',
        'value': '1,000.00',
        'change': '0.0%',
        'icon': '💵',
      },
    ];

    // Calculate total balance
    double totalBalance = 0;
    for (var token in tokens) {
      totalBalance += double.parse(token['value']!.replaceAll(',', ''));
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('CryptoVault'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.settings),
          onPressed: () {
            // Navigate to settings
          },
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const AccountSelector(),
            const SizedBox(height: 16),
            const NetworkSelector(),
            const SizedBox(height: 20),
            BalanceCard(
              currency: 'ETH',
              totalBalance: ref.watch(walletBalanceProvider).balance.toString(),
            ),
            const SizedBox(height: 20),
            if (ref.watch(walletBalanceProvider).isLoading) ...[
              const SizedBox(
                height: 80,
                width: 20,
              ),
              Center(
                child: CupertinoActivityIndicator(),
              ),
            ] else ...[
              TokenList(
                tokens: ref.watch(walletBalanceProvider).currency,
              ),
            ]
          ],
        ),
      ),
    );
  }
}
