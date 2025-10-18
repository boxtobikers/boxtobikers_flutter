import 'package:flutter/material.dart';
import 'services/preferences_service.dart';
import 'providers/app_state_provider.dart';

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

    // 1. Créer le service de préférences
    final preferencesService = await PreferencesService.create();
    debugPrint('✅ AppLauncher: Service de préférences initialisé');

    // 2. Créer le provider d'état
    _appStateProvider = AppStateProvider(preferencesService);
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
}

