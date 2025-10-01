import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';
import 'features/home/ui/pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      title: 'BoxtoBikers',
      // The Big stone, light theme. Other gold
      theme: FlexThemeData.light(scheme: FlexScheme.bigStone, fontFamily: 'CreatoDisplay'),
      // The Big stone, dark theme. Other gold
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.bigStone),
      themeMode: ThemeMode.system,
      home: Builder(
        builder: (context) => MyHomePage(title: S.of(context).title),
      ),
    );
  }
}
