import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProviderNotifier);
    final themeNotifier = ref.read(themeProviderNotifier.notifier);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Settings'),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          children: [
            CupertinoListSection(
              header: const Text('Appearance'),
              children: [
                CupertinoListTile(
                  title: const Text('Dark Mode'),
                  trailing: CupertinoSwitch(
                    value: isDarkMode,
                    activeColor: CupertinoColors.activeBlue,
                    onChanged: (_) => themeNotifier.toggleTheme(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            CupertinoListSection(
              header: const Text('Language'),
              children: [
                CupertinoListTile(
                  title: const Text('Language'),
                  trailing: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: (){},
                    // onPressed: () => _showLanguagePicker(context),
                    child: const Row(
                      children: [
                        Text('English'),
                        SizedBox(width: 4),
                        // Icon(CupertinoIcons.chevron_forward, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: const Text('Choose Language'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              // Handle language change to English
            },
            child: const Text('English'),
          ),
          // CupertinoActionSheetAction(
          //   onPressed: () {
          //     Navigator.pop(context);
          //     // Handle language change to Spanish
          //   },
          //   child: const Text('Spanish'),
          // ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }
}
