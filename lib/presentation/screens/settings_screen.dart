import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/text_widget.dart';
import '../../core/localization/localization_provider.dart';
import '../../core/theme/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProviderNotifier);
    final themeNotifier = ref.read(themeProviderNotifier.notifier);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: TextWidget(
          textKey: 'settings',
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          children: [
            CupertinoListSection(
              header: const TextWidget(
                textKey: 'appearance',
              ),
              children: [
                CupertinoListTile(
                  title: const TextWidget(
                    textKey: 'dark_mode',
                  ),
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
              header: const TextWidget(
                textKey: 'language',
              ),
              children: [
                CupertinoListTile(
                  title: const TextWidget(
                    textKey: 'selected_language',
                  ),
                  trailing: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => _showLanguagePicker(context, ref),
                    child: Row(
                      children: [
                        Consumer(
                          builder: (context, ref, child) {
                            return Text(
                              ref.watch(languageProvider) == 'en'
                                  ? 'English'
                                  : 'தமிழ்',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: CupertinoColors.systemGrey,
                              ),
                            );
                          },
                        ),

                        const SizedBox(width: 4),
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

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: const TextWidget(
          textKey: 'choose_language',
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              setLanguage('en');
              ref.read(languageProvider.notifier).state = 'en';
            },
            child: const Text('English'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              setLanguage('ta');
              ref.read(languageProvider.notifier).state = 'ta';
            },
            child: const Text('தமிழ்'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const TextWidget(
            textKey: 'cancel',
          ),
        ),
      ),
    );
  }
}
