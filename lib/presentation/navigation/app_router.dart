import 'package:crypto_wallet/core/localization/localization_provider.dart';
import 'package:crypto_wallet/core/services/websocket/wallet_balance_state.dart';
import 'package:crypto_wallet/providers/accouns_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../new/wallet_setup.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/models/currency_model.dart';
import '../screens/home_screen.dart';
import '../screens/send_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/transaction_history_screen.dart';

class AppRouter extends ConsumerStatefulWidget {
  const AppRouter({super.key});

  @override
  ConsumerState<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends ConsumerState<AppRouter> {
  @override
  void initState() {
    super.initState();
    getBalance();
  }

  Future<void> getBalance() async {
    await Future.delayed(const Duration(seconds: 0));
    ref.read(walletBalanceProvider.notifier).setLoading();
    await Future.delayed(const Duration(seconds: 2));
    final account = ref.read(accountProvider).selectedAccount?.address;
    ref.read(walletBalanceProvider.notifier).fetchBalanceHttp(account ?? '');
    ref.read(walletBalanceProvider.notifier).fetchTransactions(account ?? '');
    final currency = await getFilteredCurrencies();
    ref.read(walletBalanceProvider.notifier).setCurrency(currency);
    // ref.read(walletBalanceProvider.notifier).connect('0x49534011FB6caC5aaDA5E5C993E256fB2AeA391D');
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.home),
            label: language == 'en' ? 'Home' : 'வீடு',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.account_balance_wallet_outlined,),
          //   label: 'Balance',
          // ),

          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.clock),
            label: language == 'en' ? 'History' : 'வரலாறு',
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.arrow_right_arrow_left),
            label: language == 'en' ? 'Send' : 'அனுப்பு',
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.settings),
            label: language == 'en' ? 'Settings' : 'அமைப்புகள்',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            // return const HomeScreen();
            return HomeScreenNew();
          // case 1:
          //   return const WalletSetupScreen();
          // case 2:
          //   return const SendScreen();
          case 1:
            return const TransactionHistoryScreen();
          case 2:
            return const SendScreen();
          case 3:
            return const SettingsScreen();
          default:
            return HomeScreen();
        }
      },
    );
  }
}
