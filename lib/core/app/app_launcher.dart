import 'dart:async';

import 'package:boxtobikers/core/app/providers/app_state.provider.dart';
import 'package:boxtobikers/core/auth/providers/app_auth.provider.dart';
import 'package:boxtobikers/core/auth/repositories/app_auth.repository.dart';
import 'package:boxtobikers/core/auth/services/app_session.service.dart';
import 'package:boxtobikers/core/http/http_config.dart';
import 'package:boxtobikers/core/http/http_service.dart';
import 'package:boxtobikers/features/settings/business/services/settings_service.dart';
import 'package:flutter/foundation.dart';

/// Classe responsable de l'initialisation de l'application
/// Principe SOLID : Single Responsibility - gère uniquement le lancement de l'app
/// Principe DRY : centralise la logique de démarrage
class AppLauncher {
  static AppStateProvider? _appStateProvider;
  static AppAuthProvider? _authProvider;

  /// Initialise l'application au démarrage ou au réveil
  ///
  /// Cette méthode est appelée :
  /// 1. Au démarrage de l'application (première fois ou après redémarrage)
  /// 2. Au réveil de l'application (retour depuis le background)
  ///
  /// Comportement :
  /// - Au DÉMARRAGE : charge les préférences du device ou celles sauvegardées
  /// - Au RÉVEIL : conserve les préférences utilisateur (pas d'écrasement)
  /// - Les modifications de l'utilisateur persistent jusqu'au redémarrage complet
  static Future<Map<String, dynamic>> initialize() async {
    // Si déjà initialisé, retourne les instances existantes (réveil)
    if (_appStateProvider != null &&
        _authProvider != null &&
        _appStateProvider!.isInitialized) {
      debugPrint('🔄 AppLauncher: Application en réveil - conservation des préférences');
      return {
        'appStateProvider': _appStateProvider!,
        'authProvider': _authProvider!,
      };
    }

    debugPrint('🚀 AppLauncher: Démarrage de l\'application');

    // 1. Initialiser le service HTTP
    _initializeHttpService();
    debugPrint('✅ AppLauncher: Service HTTP initialisé');

    // 2. Initialiser le service de session
    final sessionService = await AppSessionService.create();
    debugPrint('✅ AppLauncher: Service de session initialisé');

    // 3. Initialiser le repository d'authentification
    final authRepository = AppAuthRepository();
    debugPrint('✅ AppLauncher: Repository d\'authentification créé');

    // 4. Créer le provider d'authentification
    _authProvider = AppAuthProvider(
      authRepository: authRepository,
      sessionService: sessionService,
    );
    debugPrint('✅ AppLauncher: Provider d\'authentification créé');

    // 5. Initialiser l'authentification (crée une session anonyme si nécessaire)
    await _authProvider!.initialize();
    debugPrint('✅ AppLauncher: Authentification initialisée');

    // 6. Créer le service de préférences
    final settingsService = await SettingsService.create();
    debugPrint('✅ AppLauncher: Service de préférences initialisé');

    // 7. Créer le provider d'état
    _appStateProvider = AppStateProvider(settingsService);
    debugPrint('✅ AppLauncher: Provider d\'état créé');

    return {
      'appStateProvider': _appStateProvider!,
      'authProvider': _authProvider!,
    };
  }

  /// Récupère le provider d'état (doit être appelé après initialize)
  static AppStateProvider? get appStateProvider => _appStateProvider;

  /// Récupère le provider d'authentification (doit être appelé après initialize)
  static AppAuthProvider? get authProvider => _authProvider;

  /// Réinitialise complètement l'application (simule un redémarrage)
  static Future<void> reset() async {
    if (_appStateProvider != null) {
      await _appStateProvider!.resetAllPreferences();
      _appStateProvider = null;
      debugPrint('🔄 AppLauncher: AppStateProvider réinitialisé');
    }

    if (_authProvider != null) {
      await _authProvider!.signOut();
      _authProvider = null;
      debugPrint('🔄 AppLauncher: AuthProvider réinitialisé');
    }

    debugPrint('🔄 AppLauncher: Application réinitialisée');
  }

  /// Initialise le service HTTP avec la configuration appropriée
  static void _initializeHttpService() {
    // Utilise la configuration de développement en mode debug, production sinon
    final config = kDebugMode ? HttpConfig.development : HttpConfig.production;

    HttpService.instance.initialize(config);

    debugPrint('🌐 HttpService configuré avec baseUrl: ${config.baseUrl}');
  }
}

