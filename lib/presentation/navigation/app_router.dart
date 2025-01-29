import 'package:crypto_wallet/core/constants/device_token.dart';
import 'package:crypto_wallet/core/localization/localization_provider.dart';
import 'package:crypto_wallet/core/services/websocket/wallet_balance_state.dart';
import 'package:crypto_wallet/providers/accouns_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:crypto_wallet/core/localization/app_notification.dart';
import 'package:crypto_wallet/core/localization/notification_service.dart';
import '../screens/coins/coins_page.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/models/currency_model.dart';
import '../screens/home_screen.dart';
import 'package:crypto_wallet/presentation/screens/send_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/transaction_history_screen.dart';

class AppRouter extends ConsumerStatefulWidget {
  const AppRouter({super.key});

  @override
  ConsumerState<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends ConsumerState<AppRouter>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getBalance();
    setNotification();
    connectWebSocket();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    disconnectWebSocket();
    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       connectWebSocket();
  //       break;
  //     case AppLifecycleState.paused:
  //       break;
  //     case AppLifecycleState.detached:
  //       disconnectWebSocket();
  //       break;
  //     default:
  //       break;
  //   }
  // }

  Future<void> connectWebSocket() async {
    await Future.delayed(Duration.zero);
    final account = ref.read(accountProvider).selectedAccount?.address;
    // if (account != null) {
    // ref.read(walletBalanceProvider.notifier).reconnect(account);
    ref.read(walletBalanceProvider.notifier).ioConnect();
  }

  void disconnectWebSocket() {
    // ref.read(walletBalanceProvider.notifier).disconnect();
    ref.read(walletBalanceProvider.notifier).ioDisconnect();
  }

  Future<void> getBalance() async {
    await Future.delayed(const Duration(seconds: 0));
    ref.read(walletBalanceProvider.notifier).setLoading();
    await Future.delayed(const Duration(seconds: 2));
    final account = ref.read(accountProvider).selectedAccount?.address;
    ref.read(walletBalanceProvider.notifier).setAddress(account ?? '');
    ref.read(walletBalanceProvider.notifier).updateDeviceToken(account ?? '');
    ref
        .read(walletBalanceProvider.notifier)
        .fetchBalanceHttpBackend(account ?? '');
    ref
        .read(walletBalanceProvider.notifier)
        .fetchTransactionsBackend(account ?? '');
    ref.read(walletBalanceProvider.notifier).setEthPrice();

    final currency =
        await ref.read(currencyProvider.notifier).getFilteredCurrencies();
    ref.read(walletBalanceProvider.notifier).setCurrency(currency);
  }

  Future<void> setNotification() async {
    NotificationService().initializeFCM();
    await AppNotification.initializeNotification();
    AppNotification.setupForegroundNotificationListener();
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
          BottomNavigationBarItem(
            icon: const Icon(Icons.public),
            label: language == 'en' ? 'Coins' : 'நாணயங்கள்',
          ),
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
            return const HomeScreenNew();
          case 1:
            return const CoinsPage();
          case 2:
            return const TransactionHistoryScreen();
          case 3:
            return const SendScreen();
          case 4:
            return const SettingsScreen();
          default:
            return const HomeScreen();
        }
      },
    );
  }
}
