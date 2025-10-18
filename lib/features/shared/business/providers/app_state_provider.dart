import 'package:flutter/material.dart';
import '../models/currency.dart';
import '../models/distance_unit.dart';
import '../services/preferences_service.dart';

/// Provider pour gérer l'état global de l'application
/// Principe SOLID :
/// - Single Responsibility : gère l'état des préférences utilisateur
/// - Open/Closed : extensible sans modification
/// - Liskov Substitution : hérite de ChangeNotifier
/// - Interface Segregation : expose uniquement les méthodes nécessaires
/// - Dependency Inversion : dépend de l'abstraction PreferencesService
class AppStateProvider extends ChangeNotifier {
  final PreferencesService _preferencesService;

  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('fr', 'FR');
  Currency _currency = Currency.euro;
  DistanceUnit _distanceUnit = DistanceUnit.kilometers;
  bool _isInitialized = false;

  AppStateProvider(this._preferencesService);

  // ============ Getters ============

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  Currency get currency => _currency;
  DistanceUnit get distanceUnit => _distanceUnit;
  bool get isInitialized => _isInitialized;

  // ============ Setters avec persistance ============

  /// Met à jour le mode de thème
  /// Note : lors du réveil de l'app, cette valeur n'est PAS écrasée
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _preferencesService.saveThemeMode(mode);
    // Utiliser addPostFrameCallback pour notifier après la fin du frame actuel
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  /// Met à jour la locale
  /// Note : lors du réveil de l'app, cette valeur n'est PAS écrasée
  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await _preferencesService.saveLocale(locale);

    // Si la devise n'a pas été personnalisée, on la met à jour selon la locale
    final savedCurrency = _preferencesService.getSavedCurrency();
    if (savedCurrency == null) {
      _currency = Currency.fromLocale(locale.toString());
    }

    // Si l'unité de distance n'a pas été personnalisée, on la met à jour selon la locale
    final savedDistanceUnit = _preferencesService.getSavedDistanceUnit();
    if (savedDistanceUnit == null) {
      _distanceUnit = DistanceUnit.fromLocale(locale.toString());
    }

    // Utiliser addPostFrameCallback pour notifier après la fin du frame actuel
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  /// Met à jour la devise
  /// Note : lors du réveil de l'app, cette valeur n'est PAS écrasée
  Future<void> setCurrency(Currency currency) async {
    _currency = currency;
    await _preferencesService.saveCurrency(currency);
    // Utiliser addPostFrameCallback pour notifier après la fin du frame actuel
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  /// Met à jour l'unité de distance
  /// Note : lors du réveil de l'app, cette valeur n'est PAS écrasée
  Future<void> setDistanceUnit(DistanceUnit unit) async {
    _distanceUnit = unit;
    await _preferencesService.saveDistanceUnit(unit);
    // Utiliser addPostFrameCallback pour notifier après la fin du frame actuel
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // ============ Initialisation ============

  /// Initialise l'état de l'application depuis le device
  /// Principe DRY : centralise toute la logique d'initialisation
  Future<void> initializeFromDevice() async {
    // 1. Récupérer la locale du device depuis le système (sans utiliser context)
    final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;

    // 2. Vérifier si des préférences ont été sauvegardées
    final savedThemeMode = _preferencesService.getSavedThemeMode();
    final savedLocale = _preferencesService.getSavedLocale();
    final savedCurrency = _preferencesService.getSavedCurrency();
    final savedDistanceUnit = _preferencesService.getSavedDistanceUnit();

    // 3. Définir les valeurs selon la priorité :
    //    - Si l'utilisateur a déjà personnalisé -> utiliser la valeur sauvegardée
    //    - Sinon -> utiliser la valeur du device

    // Theme : utilise la valeur sauvegardée ou système
    _themeMode = savedThemeMode ?? ThemeMode.system;

    // Locale : utilise la valeur sauvegardée ou celle du device
    _locale = savedLocale ?? deviceLocale;

    // Currency : utilise la valeur sauvegardée ou déduit de la locale
    _currency = savedCurrency ?? Currency.fromLocale(_locale.toString());

    // DistanceUnit : utilise la valeur sauvegardée ou déduit de la locale
    _distanceUnit = savedDistanceUnit ?? DistanceUnit.fromLocale(_locale.toString());

    _isInitialized = true;
    notifyListeners();

    // 4. Marquer le premier lancement comme terminé
    if (_preferencesService.isFirstLaunch()) {
      await _preferencesService.setFirstLaunchComplete();
    }
  }

  /// Initialise l'état de l'application sans contexte (pour les tests)
  /// Charge uniquement depuis les préférences sauvegardées
  Future<void> initializeForTesting() async {
    // Vérifier si des préférences ont été sauvegardées
    final savedThemeMode = _preferencesService.getSavedThemeMode();
    final savedLocale = _preferencesService.getSavedLocale();
    final savedCurrency = _preferencesService.getSavedCurrency();
    final savedDistanceUnit = _preferencesService.getSavedDistanceUnit();

    // Définir les valeurs avec des valeurs par défaut si rien n'est sauvegardé
    _themeMode = savedThemeMode ?? ThemeMode.system;
    _locale = savedLocale ?? const Locale('fr', 'FR');
    _currency = savedCurrency ?? Currency.euro;
    _distanceUnit = savedDistanceUnit ?? DistanceUnit.kilometers;

    _isInitialized = true;
    notifyListeners();
  }

  /// Réinitialise toutes les préférences (redémarre l'app)
  Future<void> resetAllPreferences() async {
    await _preferencesService.clearAll();
    _isInitialized = false;
    notifyListeners();
  }
}
