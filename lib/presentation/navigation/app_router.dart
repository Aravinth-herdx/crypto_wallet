import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../new/wallet_setup.dart';
import '../screens/home/home_screen.dart';
import '../screens/home_screen.dart';
import '../screens/send_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/transaction_history_screen.dart';

class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined,),
            label: 'Balance',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.clock),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.arrow_right_arrow_left),
            label: 'Send',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Settings',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            // return const HomeScreen();
            return  HomeScreenNew ();
          case 1:
            return const WalletSetupScreen();
          // case 2:
          //   return const SendScreen();
          case 2:
            return const TransactionHistoryScreen();
          case 3:
            return const SendScreen();
          case 4:
            return const SettingsScreen();
          default:
            return  HomeScreen();
        }
      },
    );
  }
}