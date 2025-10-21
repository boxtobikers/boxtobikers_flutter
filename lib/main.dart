import 'package:boxtobikers/features/home/ui/pages/home.pages.dart';
import 'package:boxtobikers/features/shared/core/app_launcher.dart';
import 'package:boxtobikers/features/shared/core/app_router.dart';
import 'package:boxtobikers/features/shared/core/providers/app_state.provider.dart';
import 'package:boxtobikers/features/shared/core/utils/app_constants.utils.dart';
import 'package:boxtobikers/generated/l10n.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

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
            initialRoute: AppRouter.initialRoute,
            routes: AppRouter.getRoutes(context),
            home: Builder(
              builder: (context) => HomePages(title: S.of(context).homeTitle),
            ),
          );
        },
      ),
    );
  }
}
