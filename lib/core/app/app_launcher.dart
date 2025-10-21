import 'dart:async';

import 'package:boxtobikers/core/app/providers/app_state.provider.dart';
import 'package:boxtobikers/core/http/http_config.dart';
import 'package:boxtobikers/core/http/http_service.dart';
import 'package:boxtobikers/features/settings/business/services/settings_service.dart';
import 'package:flutter/foundation.dart';

/// Classe responsable de l'initialisation de l'application
/// Principe SOLID : Single Responsibility - gère uniquement le lancement de l'app
/// Principe DRY : centralise la logique de démarrage
class AppLauncher {
  static AppStateProvider? _appStateProvider;

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
  static Future<AppStateProvider> initialize() async {
    // Si déjà initialisé, retourne l'instance existante (réveil)
    if (_appStateProvider != null && _appStateProvider!.isInitialized) {
      debugPrint('🔄 AppLauncher: Application en réveil - conservation des préférences');
      return _appStateProvider!;
    }

    debugPrint('🚀 AppLauncher: Démarrage de l\'application');

    // 1. Initialiser le service HTTP
    _initializeHttpService();
    debugPrint('✅ AppLauncher: Service HTTP initialisé');

    // 2. Créer le service de préférences
    final settingsService = await SettingsService.create();
    debugPrint('✅ AppLauncher: Service de préférences initialisé');

    // 3. Créer le provider d'état
    _appStateProvider = AppStateProvider(settingsService);
    debugPrint('✅ AppLauncher: Provider d\'état créé');

    return _appStateProvider!;
  }

  /// Récupère le provider d'état (doit être appelé après initialize)
  static AppStateProvider? get appStateProvider => _appStateProvider;

  /// Réinitialise complètement l'application (simule un redémarrage)
  static Future<void> reset() async {
    if (_appStateProvider != null) {
      await _appStateProvider!.resetAllPreferences();
      _appStateProvider = null;
      debugPrint('🔄 AppLauncher: Application réinitialisée');
    }
  }

  /// Initialise le service HTTP avec la configuration appropriée
  static void _initializeHttpService() {
    // Utilise la configuration de développement en mode debug, production sinon
    final config = kDebugMode ? HttpConfig.development : HttpConfig.production;

    HttpService.instance.initialize(config);

    debugPrint('🌐 HttpService configuré avec baseUrl: ${config.baseUrl}');
  }
}

