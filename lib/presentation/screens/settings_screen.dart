import 'package:crypto_wallet/presentation/screens/wallet_import/screen/wallet_import_screen.dart';
import 'package:crypto_wallet/presentation/screens/wallet_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProviderNotifier);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Settings'),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            CupertinoListTile(
              title: const Text('Dark Mode'),
              trailing: CupertinoSwitch(
                value: isDarkMode,
                onChanged: (value) {
                  ref.read(themeProviderNotifier.notifier).toggleTheme();
                },
              ),
            ),
            CupertinoListTile(
              title: const Text('Import Wallet'),
              trailing: const Icon(CupertinoIcons.right_chevron),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const WalletImportScreen(), // Navigate to WalletImportScreen using CupertinoPageRoute
                  ),
                );
              },
            ),
             CupertinoListTile(
              title: Text('Security'),
              trailing: Icon(CupertinoIcons.right_chevron),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const WalletScreen(), // Navigate to WalletImportScreen using CupertinoPageRoute
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
