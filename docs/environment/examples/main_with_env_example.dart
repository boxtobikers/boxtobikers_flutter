/// Exemple d'intégration de EnvConfig dans main.dart
///
/// Ce fichier montre comment utiliser les variables d'environnement
/// dans votre application BoxToBikers.
///
/// ⚠️ CECI EST UN EXEMPLE - Ne remplacez pas votre main.dart actuel !
/// Copiez uniquement les parties dont vous avez besoin.
library;

import 'package:boxtobikers/core/app/app_launcher.dart';
import 'package:boxtobikers/core/app/providers/app_state.provider.dart';
import 'package:boxtobikers/core/config/env_config.dart';
import 'package:boxtobikers/generated/l10n.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

/// Point d'entrée de l'application avec validation de la configuration
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ═══════════════════════════════════════════════════════════
  // 🔧 AJOUTEZ CETTE SECTION POUR VALIDER LA CONFIGURATION
  // ═══════════════════════════════════════════════════════════
  try {
    // Valider que toutes les variables requises sont définies
    EnvConfig.validate();

    // Afficher les informations de configuration (en dev uniquement)
    EnvConfig.printInfo();
  } catch (e) {
    // Si la configuration est invalide, afficher l'erreur et arrêter
    debugPrint('❌ Erreur de configuration : $e');
    rethrow;
  }

  // Configuration pour améliorer le rendu des polices sur Android
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Initialiser l'application avec AppLauncher
  final appStateProvider = await AppLauncher.initialize();

  runApp(MyApp(appStateProvider: appStateProvider));
}

/// Widget principal de l'application
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
            // 💡 Personnaliser selon l'environnement
            title: EnvConfig.isDevelopment
                ? 'BoxToBikers [DEV]'
                : 'BoxToBikers',

            // Debug banner uniquement en dev
            debugShowCheckedModeBanner: EnvConfig.isDevelopment,

            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            locale: appState.locale,

            theme: FlexThemeData.light(
              scheme: FlexScheme.blue,
              surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
              blendLevel: 7,
            ),

            darkTheme: FlexThemeData.dark(
              scheme: FlexScheme.blue,
              surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
              blendLevel: 13,
            ),

            themeMode: appState.themeMode,

            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}

/// Exemple de HomeScreen qui utilise EnvConfig
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BoxToBikers'),
        // Afficher l'environnement en dev
        actions: [
          if (EnvConfig.isDevelopment)
            Chip(
              label: Text(EnvConfig.environment.toUpperCase()),
              backgroundColor: Colors.orange,
            ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Bienvenue sur BoxToBikers !'),
            const SizedBox(height: 20),

            // Afficher les infos de config en dev
            if (EnvConfig.isDevelopment) ...[
              const Divider(),
              const Text('Configuration (DEV uniquement):'),
              const SizedBox(height: 10),
              Text('Environnement: ${EnvConfig.environment}'),
              Text('Supabase: ${EnvConfig.supabaseUrl}'),
              Text('Config valide: ${EnvConfig.isValid}'),
            ],
          ],
        ),
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════════════════════
/// 📝 EXEMPLES D'UTILISATION
/// ═══════════════════════════════════════════════════════════════════════

/// Exemple 1 : URLs différentes par environnement
String getApiBaseUrl() {
  if (EnvConfig.isProduction) {
    return 'https://api.boxtobikers.com';
  } else {
    return EnvConfig.apiUrl.isNotEmpty
        ? EnvConfig.apiUrl
        : 'http://localhost:3000';
  }
}

/// Exemple 2 : Logger uniquement en développement
void debugLog(String message) {
  if (EnvConfig.isDevelopment) {
    debugPrint('🔍 [DEBUG] $message');
  }
}

/// Exemple 3 : Fonctionnalités dev uniquement
Widget buildDevTools() {
  if (!EnvConfig.isDevelopment) {
    return const SizedBox.shrink();
  }

  return Container(
    padding: const EdgeInsets.all(8),
    color: Colors.orange,
    child: const Text('🛠️ Outils de développement'),
  );
}

