import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';
import 'features/home/ui/pages/home.pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Configuration pour améliorer le rendu des polices sur Android
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      title: 'BoxtoBikers',
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
      themeMode: ThemeMode.system,
      home: Builder(
        builder: (context) => HomePages(title: S.of(context).homeTitle),
      ),
    );
  }
}
