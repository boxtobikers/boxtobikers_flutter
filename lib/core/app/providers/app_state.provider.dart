import 'package:boxtobikers/core/app/models/currency.model.dart';
import 'package:boxtobikers/core/app/models/distance_unit.model.dart';
import 'package:boxtobikers/features/settings/business/services/settings_service.dart';
import 'package:flutter/material.dart';

/// Provider pour gérer l'état global de l'application
/// - Dependency Inversion : dépend de l'abstraction SettingsService
class AppStateProvider extends ChangeNotifier {
  final SettingsService _settingsService;

  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('fr', 'FR');
  CurrencyModel _currency = CurrencyModel.euro;
  DistanceUnitModel _distanceUnit = DistanceUnitModel.kilometers;
  bool _isInitialized = false;

  AppStateProvider(this._settingsService);

  // ============ Getters ============

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  CurrencyModel get currency => _currency;
  DistanceUnitModel get distanceUnit => _distanceUnit;
  bool get isInitialized => _isInitialized;

  // ============ Setters avec persistance ============

  /// Met à jour le mode de thème
  /// Note : lors du réveil de l'app, cette valeur n'est PAS écrasée
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _settingsService.saveThemeMode(mode);
    // Utiliser addPostFrameCallback pour notifier après la fin du frame actuel
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  /// Met à jour la locale
  /// Note : lors du réveil de l'app, cette valeur n'est PAS écrasée
  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await _settingsService.saveLocale(locale);

    // Si la devise n'a pas été personnalisée, on la met à jour selon la locale
    final savedCurrency = _settingsService.getSavedCurrency();
    if (savedCurrency == null) {
      _currency = CurrencyModel.fromLocale(locale.toString());
    }

    // Si l'unité de distance n'a pas été personnalisée, on la met à jour selon la locale
    final savedDistanceUnit = _settingsService.getSavedDistanceUnit();
    if (savedDistanceUnit == null) {
      _distanceUnit = DistanceUnitModel.fromLocale(locale.toString());
    }

    // Utiliser addPostFrameCallback pour notifier après la fin du frame actuel
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  /// Met à jour la devise
  /// Note : lors du réveil de l'app, cette valeur n'est PAS écrasée
  Future<void> setCurrency(CurrencyModel currency) async {
    _currency = currency;
    await _settingsService.saveCurrency(currency);
    // Utiliser addPostFrameCallback pour notifier après la fin du frame actuel
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  /// Met à jour l'unité de distance
  /// Note : lors du réveil de l'app, cette valeur n'est PAS écrasée
  Future<void> setDistanceUnit(DistanceUnitModel unit) async {
    _distanceUnit = unit;
    await _settingsService.saveDistanceUnit(unit);
    // Utiliser addPostFrameCallback pour notifier après la fin du frame actuel
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // ============ Initialisation ============
  /// Initialise l'état de l'application depuis le device
  Future<void> initializeFromDevice() async {
    // 1. Récupérer la locale du device depuis le système (sans utiliser context)
    final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;

    // 2. Vérifier si des préférences ont été sauvegardées
    final savedThemeMode = _settingsService.getSavedThemeMode();
    final savedLocale = _settingsService.getSavedLocale();
    final savedCurrency = _settingsService.getSavedCurrency();
    final savedDistanceUnit = _settingsService.getSavedDistanceUnit();

    // 3. Définir les valeurs selon la priorité :
    //    - Si l'utilisateur a déjà personnalisé -> utiliser la valeur sauvegardée
    //    - Sinon -> utiliser la valeur du device

    // Theme : utilise la valeur sauvegardée ou système
    _themeMode = savedThemeMode ?? ThemeMode.system;

    // Locale : utilise la valeur sauvegardée ou celle du device
    _locale = savedLocale ?? deviceLocale;

    // Currency : utilise la valeur sauvegardée ou déduit de la locale
    _currency = savedCurrency ?? CurrencyModel.fromLocale(_locale.toString());

    // DistanceUnit : utilise la valeur sauvegardée ou déduit de la locale
    _distanceUnit = savedDistanceUnit ?? DistanceUnitModel.fromLocale(_locale.toString());

    _isInitialized = true;
    notifyListeners();

    // 4. Marquer le premier lancement comme terminé
    if (_settingsService.isFirstLaunch()) {
      await _settingsService.setFirstLaunchComplete();
    }
  }

  /// Initialise l'état de l'application sans contexte (pour les tests)
  /// Charge uniquement depuis les préférences sauvegardées
  Future<void> initializeForTesting() async {
    // Vérifier si des préférences ont été sauvegardées
    final savedThemeMode = _settingsService.getSavedThemeMode();
    final savedLocale = _settingsService.getSavedLocale();
    final savedCurrency = _settingsService.getSavedCurrency();
    final savedDistanceUnit = _settingsService.getSavedDistanceUnit();

    // Définir les valeurs avec des valeurs par défaut si rien n'est sauvegardé
    _themeMode = savedThemeMode ?? ThemeMode.system;
    _locale = savedLocale ?? const Locale('fr', 'FR');
    _currency = savedCurrency ?? CurrencyModel.euro;
    _distanceUnit = savedDistanceUnit ?? DistanceUnitModel.kilometers;

    _isInitialized = true;
    notifyListeners();
  }

  /// Réinitialise toutes les préférences (redémarre l'app)
  Future<void> resetAllPreferences() async {
    await _settingsService.clearAll();
    _isInitialized = false;
    notifyListeners();
  }
}
