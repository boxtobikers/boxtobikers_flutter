import 'dart:io';
import 'package:flutter/foundation.dart';

/// Configuration des variables d'environnement de l'application.
///
/// Cette classe permet d'accéder aux variables d'environnement définies
/// lors du lancement de l'application avec --dart-define-from-file.
///
/// Supporte 3 environnements :
/// - **local** : Docker local (http://localhost:54321 ou 10.0.2.2 pour Android)
/// - **development** : Supabase.io de développement
/// - **production** : Supabase.io de production
///
/// Exemple d'utilisation :
/// ```dart
/// // Vérifier la configuration
/// EnvConfig.validate();
///
/// // Accéder aux variables (détection automatique de la plateforme)
/// String url = EnvConfig.supabaseUrl;
/// String key = EnvConfig.supabaseAnonKey;
///
/// // Vérifier l'environnement
/// if (EnvConfig.isLocal) {
///   print('Mode local (Docker)');
/// }
/// ```
class EnvConfig {
  /// Clé anonyme de Supabase locale (Docker)
  /// Cette clé est la clé par défaut fournie par Supabase CLI
  static const String _localAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0';

  /// Environnement d'exécution (local, development, production)
  static const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'development',
  );

  // Helpers pour vérifier l'environnement

  /// Retourne true si l'application est en mode local (Docker)
  static bool get isLocal => environment == 'local';

  /// Retourne true si l'application est en mode développement (Supabase.io)
  static bool get isDevelopment => environment == 'development';

  /// Retourne true si l'application est en mode production
  static bool get isProduction => environment == 'production';

  /// URL de l'instance Supabase
  ///
  /// En mode local : détecte automatiquement la plateforme
  /// - Android : http://10.0.2.2:54321
  /// - iOS/Desktop/Web : http://localhost:54321
  ///
  /// En mode development/production : utilise l'URL du fichier de config
  static String get supabaseUrl {
    if (isLocal) {
      // Détection automatique de la plateforme pour le mode local
      if (!kIsWeb && Platform.isAndroid) {
        return 'http://10.0.2.2:54321'; // Émulateur Android
      }
      return 'http://localhost:54321'; // iOS Simulator, Desktop, Web
    }

    // Pour development et production, lire depuis dart-define
    const url = String.fromEnvironment('SUPABASE_URL', defaultValue: '');
    return url;
  }

  /// Clé anonyme (publique) de Supabase
  ///
  /// En mode local : utilise la clé par défaut de Supabase CLI
  /// En mode development/production : utilise la clé du fichier de config
  ///
  /// Cette clé est sécurisée pour être utilisée côté client.
  /// Elle permet l'accès en lecture selon les RLS (Row Level Security).
  static String get supabaseAnonKey {
    if (isLocal) {
      return _localAnonKey;
    }

    const key = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');
    return key;
  }

  /// URL de l'API backend (si nécessaire)
  static String get apiUrl {
    if (isLocal) {
      return 'http://localhost:3000'; // API locale si vous en avez une
    }

    const url = String.fromEnvironment('API_URL', defaultValue: '');
    return url;
  }

  /// Vérifie que toutes les variables requises sont définies
  static bool get isValid {
    return supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
  }

  /// Valide la configuration et lance une exception si invalide
  ///
  /// Cette méthode doit être appelée au démarrage de l'application
  /// pour s'assurer que toutes les variables sont correctement définies.
  ///
  /// Throws [Exception] si la configuration est invalide
  static void validate() {
    // En mode local, la validation est automatique (clés hardcodées)
    if (isLocal) {
      if (kDebugMode) {
        print('✅ Mode local détecté - Configuration automatique');
        print('🐳 Docker Supabase : $supabaseUrl');
      }
      return;
    }

    // En mode development/production, valider les clés
    if (supabaseUrl.isEmpty) {
      throw Exception(
        '❌ Configuration manquante : SUPABASE_URL\n\n'
        '💡 Solutions :\n'
        '   📱 Android Studio : Sélectionnez "main.dart (dev)" en haut à droite\n'
        '   💻 Terminal : flutter run --dart-define-from-file=config/dev.json\n'
        '   🔧 Make : make dev\n\n'
        '📖 Guide complet : docs/development/ANDROID_STUDIO_LAUNCH.md',
      );
    }

    if (supabaseAnonKey.isEmpty) {
      throw Exception(
        '❌ Configuration manquante : SUPABASE_ANON_KEY\n\n'
        '💡 Solutions :\n'
        '   📱 Android Studio : Sélectionnez "main.dart (dev)" en haut à droite\n'
        '   💻 Terminal : flutter run --dart-define-from-file=config/dev.json\n'
        '   🔧 Make : make dev\n\n'
        '📖 Guide complet : docs/development/ANDROID_STUDIO_LAUNCH.md',
      );
    }

    // En production, vérifier que l'URL est bien une URL de production
    if (isProduction && (supabaseUrl.contains('dev') || supabaseUrl.contains('localhost'))) {
      throw Exception(
        '⚠️ Attention : URL de développement/local détectée en production!\n'
        'Vérifiez votre configuration dans config/prod.json',
      );
    }
  }

  /// Affiche les informations de configuration (sans les clés sensibles)
  ///
  /// Utile pour le débogage en développement
  static void printInfo() {
    if (isProduction) return; // Ne pas afficher en production

    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('📋 Configuration de l\'environnement');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🌍 Environnement : $environment');

    if (isLocal) {
      print('🐳 Mode : Docker Local');
      print('📱 Plateforme : ${_getPlatformName()}');
    }

    print('🔗 Supabase URL : $supabaseUrl');
    print('🔑 Supabase Key : ${supabaseAnonKey.isNotEmpty ? "✓ Définie" : "✗ Manquante"}');

    if (!isLocal && apiUrl.isNotEmpty) {
      print('🌐 API URL : $apiUrl');
    }

    print('✅ Configuration valide : ${isValid ? "Oui" : "Non"}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
  }

  /// Retourne le nom de la plateforme actuelle
  static String _getPlatformName() {
    if (kIsWeb) return 'Web';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }
}

