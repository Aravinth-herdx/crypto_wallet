import 'package:crypto_wallet/presentation/new/wallet_setup.dart';
import 'package:crypto_wallet/presentation/screens/auth/biometric_auth_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/localization/app_localizations.dart';
import 'core/services/auth/auth_service.dart';
import 'core/theme/theme_provider.dart';
import 'presentation/navigation/app_router.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProviderNotifier);

    return  CupertinoApp(
      title: 'Crypto Wallet',
      supportedLocales: [
        Locale('en'),
        Locale('es'),
      ],
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // theme: CupertinoThemeData(brightness: Brightness.light),
      theme: isDarkMode
          ? const CupertinoThemeData(brightness: Brightness.dark)
          : const CupertinoThemeData(brightness: Brightness.light),
      home: const BiometricAuthScreen(),
      // home: WalletSetupScreen (),
    );
  }
}


class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
