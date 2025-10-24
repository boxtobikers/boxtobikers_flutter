/// Configuration des variables d'environnement de l'application.
///
/// Cette classe permet d'accéder aux variables d'environnement définies
/// lors du lancement de l'application avec --dart-define-from-file.
///
/// Exemple d'utilisation :
/// ```dart
/// // Vérifier la configuration
/// EnvConfig.validate();
///
/// // Accéder aux variables
/// String url = EnvConfig.supabaseUrl;
/// String key = EnvConfig.supabaseAnonKey;
///
/// // Vérifier l'environnement
/// if (EnvConfig.isDevelopment) {
///   print('Mode développement');
/// }
/// ```
class EnvConfig {
  /// URL de l'instance Supabase
  ///
  /// Exemple: https://votre-projet.supabase.co
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );

  /// Clé anonyme (publique) de Supabase
  ///
  /// Cette clé est sécurisée pour être utilisée côté client.
  /// Elle permet l'accès en lecture selon les RLS (Row Level Security).
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  /// URL de l'API backend (si nécessaire)
  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: '',
  );

  /// Environnement d'exécution (development, staging, production)
  static const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'development',
  );

  // Helpers pour vérifier l'environnement

  /// Retourne true si l'application est en mode développement
  static bool get isDevelopment => environment == 'development';

  /// Retourne true si l'application est en mode staging
  static bool get isStaging => environment == 'staging';

  /// Retourne true si l'application est en mode production
  static bool get isProduction => environment == 'production';

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
    if (supabaseUrl.isEmpty) {
      throw Exception(
        '❌ Configuration manquante : SUPABASE_URL\n'
        '💡 Lancez l\'application avec : flutter run --dart-define-from-file=config/dev.json',
      );
    }

    if (supabaseAnonKey.isEmpty) {
      throw Exception(
        '❌ Configuration manquante : SUPABASE_ANON_KEY\n'
        '💡 Lancez l\'application avec : flutter run --dart-define-from-file=config/dev.json',
      );
    }

    // En production, vérifier que l'URL est bien une URL de production
    if (isProduction && supabaseUrl.contains('dev')) {
      throw Exception(
        '⚠️ Attention : URL de développement détectée en production!\n'
        'Vérifiez votre configuration dans config/prod.json',
      );
    }
  }

  /// Affiche les informations de configuration (sans les clés sensibles)
  ///
  /// Utile pour le débogage en développement
  static void printInfo() {
    if (!isDevelopment) return;

    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('📋 Configuration de l\'environnement');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🌍 Environnement : $environment');
    print('🔗 Supabase URL : $supabaseUrl');
    print('🔑 Supabase Key : ${supabaseAnonKey.isNotEmpty ? "✓ Définie" : "✗ Manquante"}');
    print('🌐 API URL : ${apiUrl.isNotEmpty ? apiUrl : "Non définie"}');
    print('✅ Configuration valide : ${isValid ? "Oui" : "Non"}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
  }
}

