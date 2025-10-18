import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'generated/l10n.dart';
import 'features/home/ui/pages/home.pages.dart';
import 'features/about/ui/pages/about.pages.dart';
import 'features/settings/ui/pages/settings.pages.dart';
import 'features/riding/ui/pages/riding.pages.dart';
import 'features/shared/business/app_constants.dart';
import 'features/shared/business/app_launcher.dart';
import 'features/shared/business/providers/app_state_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configuration pour améliorer le rendu des polices sur Android
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Initialiser l'application avec AppLauncher
  final appStateProvider = await AppLauncher.initialize();

  runApp(MyApp(appStateProvider: appStateProvider));
}

class MyApp extends StatelessWidget {
  final AppStateProvider appStateProvider;

  const MyApp({super.key, required this.appStateProvider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: appStateProvider,
      child: Consumer<AppStateProvider>(
        builder: (context, appState, child) {
          // Initialiser depuis le device si pas encore fait
          if (!appState.isInitialized) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              appState.initializeFromDevice();
            });
          }

          return MaterialApp(
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            locale: appState.locale,
            title: AppConstants.appTitle,
            // The Big stone, light theme
            theme: FlexThemeData.light(
              scheme: FlexScheme.bigStone,
              fontFamily: 'NotoSans',
              useMaterial3: true,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              // Configuration pour améliorer le rendu des polices sur Android
              subThemesData: const FlexSubThemesData(
                useMaterial3Typography: true,
                defaultRadius: 8.0,
              ),
            ),
            // The Big stone, dark theme
            darkTheme: FlexThemeData.dark(
              scheme: FlexScheme.bigStone,
              fontFamily: 'NotoSans',
              useMaterial3: true,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              // Configuration pour améliorer le rendu des polices sur Android
              subThemesData: const FlexSubThemesData(
                useMaterial3Typography: true,
                defaultRadius: 8.0,
              ),
            ),
            themeMode: appState.themeMode,
            initialRoute: '/home',
            routes: {
              '/home': (context) => HomePages(title: S.of(context).homeTitle),
              '/about': (context) => const AboutPages(),
              '/settings': (context) => const SettingsPages(),
              '/riding': (context) => const RidingPages(),
            },
            home: Builder(
              builder: (context) => HomePages(title: S.of(context).homeTitle),
            ),
          );
        },
      ),
    );
  }
}
