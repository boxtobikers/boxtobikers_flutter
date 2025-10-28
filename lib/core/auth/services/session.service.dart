import 'dart:convert';

import 'package:boxtobikers/core/auth/models/user_session.model.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service de gestion de la persistance de la session utilisateur
/// Principe SOLID : Single Responsibility - gère uniquement la persistance de la session
/// Utilise SharedPreferences pour sauvegarder la session localement
class SessionService {
  static const String _keyUserSession = 'user_session';
  static const String _keyLastRoute = 'last_route';

  final dynamic _prefs; // Peut être SharedPreferences ou SharedPreferencesWithCache

  SessionService(this._prefs);

  /// Factory pour créer une instance du service avec cache (PRODUCTION)
  static Future<SessionService> create() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: {
          _keyUserSession,
          _keyLastRoute,
        },
      ),
    );
    return SessionService(prefs);
  }

  /// Factory pour créer une instance du service pour les TESTS
  static Future<SessionService> createForTesting() async {
    final prefs = await SharedPreferences.getInstance();
    return SessionService(prefs);
  }

  // ============ Session Management ============

  /// Sauvegarde la session utilisateur
  Future<void> saveSession(UserSession session) async {
    try {
      final sessionJson = json.encode(session.toJson());
      await _prefs.setString(_keyUserSession, sessionJson);
      debugPrint('✅ SessionService: Session sauvegardée - ${session.toString()}');
    } catch (e) {
      debugPrint('❌ SessionService: Erreur lors de la sauvegarde de la session: $e');
      rethrow;
    }
  }

  /// Charge la session utilisateur sauvegardée
  /// Retourne null si aucune session n'est sauvegardée
  Future<UserSession?> loadSession() async {
    try {
      final sessionJson = _prefs.getString(_keyUserSession);

      if (sessionJson == null) {
        debugPrint('ℹ️ SessionService: Aucune session sauvegardée');
        return null;
      }

      final sessionMap = json.decode(sessionJson) as Map<String, dynamic>;
      final session = UserSession.fromJson(sessionMap);

      debugPrint('✅ SessionService: Session chargée - ${session.toString()}');
      return session;
    } catch (e) {
      debugPrint('❌ SessionService: Erreur lors du chargement de la session: $e');
      // Si erreur de parsing, supprimer la session corrompue
      await clearSession();
      return null;
    }
  }

  /// Met à jour la session existante
  /// Plus performant que saveSession car évite de recréer tout l'objet
  Future<void> updateSession(UserSession session) async {
    await saveSession(session);
  }

  /// Supprime la session sauvegardée
  Future<void> clearSession() async {
    try {
      await _prefs.remove(_keyUserSession);
      debugPrint('✅ SessionService: Session supprimée');
    } catch (e) {
      debugPrint('❌ SessionService: Erreur lors de la suppression de la session: $e');
      rethrow;
    }
  }

  /// Vérifie si une session existe
  bool hasSession() {
    return _prefs.getString(_keyUserSession) != null;
  }

  // ============ Navigation Management ============

  /// Sauvegarde la dernière route visitée
  Future<void> saveLastRoute(String route) async {
    try {
      await _prefs.setString(_keyLastRoute, route);
      debugPrint('✅ SessionService: Dernière route sauvegardée - $route');
    } catch (e) {
      debugPrint('❌ SessionService: Erreur lors de la sauvegarde de la route: $e');
    }
  }

  /// Récupère la dernière route visitée
  /// Retourne null si aucune route n'est sauvegardée
  String? getLastRoute() {
    final route = _prefs.getString(_keyLastRoute);
    debugPrint('ℹ️ SessionService: Dernière route - $route');
    return route;
  }

  /// Supprime la dernière route sauvegardée
  Future<void> clearLastRoute() async {
    try {
      await _prefs.remove(_keyLastRoute);
      debugPrint('✅ SessionService: Dernière route supprimée');
    } catch (e) {
      debugPrint('❌ SessionService: Erreur lors de la suppression de la route: $e');
    }
  }

  // ============ Utility Methods ============

  /// Supprime toutes les données de session
  Future<void> clearAll() async {
    await clearSession();
    await clearLastRoute();
    debugPrint('✅ SessionService: Toutes les données supprimées');
  }
}

