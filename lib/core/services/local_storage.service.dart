import 'dart:convert';

import 'package:boxtobikers/features/history/data/models/destination.model.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service de persistance locale pour les données fréquemment utilisées
/// Utilise SharedPreferencesWithCache pour de meilleures performances
class LocalStorageService {
  static const String _keyDestinations = 'user_destinations';

  final dynamic _prefs;

  LocalStorageService(this._prefs);

  /// Factory pour créer une instance du service avec cache (PRODUCTION)
  static Future<LocalStorageService> create() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: {
          _keyDestinations,
        },
      ),
    );
    return LocalStorageService(prefs);
  }

  /// Factory pour créer une instance du service pour les TESTS
  static Future<LocalStorageService> createForTesting() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService(prefs);
  }

  // ============ Destinations Management ============

  /// Sauvegarde la liste des destinations
  Future<void> saveDestinations(List<Destination> destinations) async {
    try {
      final destinationsJson = destinations.map((d) => d.toJson()).toList();
      final jsonString = json.encode(destinationsJson);
      await _prefs.setString(_keyDestinations, jsonString);
      debugPrint('✅ LocalStorageService: ${destinations.length} destinations sauvegardées');
    } catch (e) {
      debugPrint('❌ LocalStorageService: Erreur lors de la sauvegarde des destinations: $e');
      rethrow;
    }
  }

  /// Charge la liste des destinations sauvegardées
  /// Retourne une liste vide si aucune destination n'est sauvegardée
  Future<List<Destination>> loadDestinations() async {
    try {
      final jsonString = _prefs.getString(_keyDestinations);

      if (jsonString == null || jsonString.isEmpty) {
        debugPrint('ℹ️ LocalStorageService: Aucune destination sauvegardée');
        return [];
      }

      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      final destinations = jsonList
          .map((json) => Destination.fromJson(json as Map<String, dynamic>))
          .toList();

      debugPrint('✅ LocalStorageService: ${destinations.length} destinations chargées');
      return destinations;
    } catch (e) {
      debugPrint('❌ LocalStorageService: Erreur lors du chargement des destinations: $e');
      // Si erreur de parsing, supprimer les données corrompues
      await clearDestinations();
      return [];
    }
  }

  /// Supprime la liste des destinations sauvegardées
  Future<void> clearDestinations() async {
    try {
      await _prefs.remove(_keyDestinations);
      debugPrint('✅ LocalStorageService: Destinations supprimées');
    } catch (e) {
      debugPrint('❌ LocalStorageService: Erreur lors de la suppression des destinations: $e');
      rethrow;
    }
  }

  /// Vérifie si des destinations sont sauvegardées
  bool hasDestinations() {
    final jsonString = _prefs.getString(_keyDestinations);
    return jsonString != null && jsonString.isNotEmpty;
  }

  // ============ Utility Methods ============

  /// Supprime toutes les données locales
  Future<void> clearAll() async {
    await clearDestinations();
    debugPrint('✅ LocalStorageService: Toutes les données supprimées');
  }
}

