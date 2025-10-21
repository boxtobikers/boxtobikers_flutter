import 'package:boxtobikers/core/app/models/currency.model.dart';
import 'package:boxtobikers/core/app/models/distance_unit.model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service de gestion des préférences utilisateur
/// Principe SOLID : Single Responsibility - gère uniquement la persistance des données
/// Principe DRY : centralise toutes les opérations de lecture/écriture
///
/// Utilise SharedPreferencesWithCache pour de meilleures performances
class SettingsService {
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyLocale = 'locale';
  static const String _keyCurrency = 'currency';
  static const String _keyDistanceUnit = 'distance_unit';
  static const String _keyIsFirstLaunch = 'is_first_launch';

  final dynamic _prefs; // Peut être SharedPreferences ou SharedPreferencesWithCache

  SettingsService(this._prefs);

  /// Factory pour créer une instance du service avec cache (PRODUCTION)
  /// SharedPreferencesWithCache offre de meilleures performances
  /// car il maintient un cache en mémoire
  static Future<SettingsService> create() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        // Met en cache toutes les clés utilisées par l'app
        allowList: {
          _keyThemeMode,
          _keyLocale,
          _keyCurrency,
          _keyDistanceUnit,
          _keyIsFirstLaunch,
        },
      ),
    );
    return SettingsService(prefs);
  }

  /// Factory pour créer une instance du service pour les TESTS
  /// Utilise SharedPreferences classique compatible avec les mocks
  static Future<SettingsService> createForTesting() async {
    final prefs = await SharedPreferences.getInstance();
    return SettingsService(prefs);
  }

  // ============ Theme Mode ============

  /// Sauvegarde le mode de thème
  Future<void> saveThemeMode(ThemeMode mode) async {
    await _prefs.setString(_keyThemeMode, mode.name);
  }

  /// Récupère le mode de thème sauvegardé
  ThemeMode? getSavedThemeMode() {
    final modeString = _prefs.getString(_keyThemeMode);
    if (modeString == null) return null;

    return ThemeMode.values.firstWhere(
      (mode) => mode.name == modeString,
      orElse: () => ThemeMode.system,
    );
  }

  // ============ Locale ============

  /// Sauvegarde la locale
  Future<void> saveLocale(Locale locale) async {
    await _prefs.setString(_keyLocale, locale.toString());
  }

  /// Récupère la locale sauvegardée
  Locale? getSavedLocale() {
    final localeString = _prefs.getString(_keyLocale);
    if (localeString == null) return null;

    final parts = localeString.split('_');
    if (parts.length == 2) {
      return Locale(parts[0], parts[1]);
    }
    return Locale(parts[0]);
  }

  // ============ Currency ============

  /// Sauvegarde la devise
  Future<void> saveCurrency(CurrencyModel currency) async {
    await _prefs.setString(_keyCurrency, currency.code);
  }

  /// Récupère la devise sauvegardée
  CurrencyModel? getSavedCurrency() {
    final currencyCode = _prefs.getString(_keyCurrency);
    if (currencyCode == null) return null;

    return CurrencyModel.fromCode(currencyCode);
  }

  // ============ Distance Unit ============

  /// Sauvegarde l'unité de distance
  Future<void> saveDistanceUnit(DistanceUnitModel unit) async {
    await _prefs.setString(_keyDistanceUnit, unit.symbol);
  }

  /// Récupère l'unité de distance sauvegardée
  DistanceUnitModel? getSavedDistanceUnit() {
    final unitSymbol = _prefs.getString(_keyDistanceUnit);
    if (unitSymbol == null) return null;

    return DistanceUnitModel.fromSymbol(unitSymbol);
  }

  // ============ First Launch ============

  /// Marque l'application comme lancée
  Future<void> setFirstLaunchComplete() async {
    await _prefs.setBool(_keyIsFirstLaunch, false);
  }

  /// Vérifie si c'est le premier lancement
  bool isFirstLaunch() {
    return _prefs.getBool(_keyIsFirstLaunch) ?? true;
  }

  /// Réinitialise toutes les préférences (utile pour les tests)
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
