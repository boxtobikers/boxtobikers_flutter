// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:boxtobikers/features/settings/business/services/settings_service.dart';
import 'package:boxtobikers/features/shared/core/models/currency.model.dart';
import 'package:boxtobikers/features/shared/core/providers/app_state.provider.dart';
import 'package:boxtobikers/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // Configuration initiale avant tous les tests
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // Réinitialiser les SharedPreferences avant chaque test
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App should initialize and load home page', (WidgetTester tester) async {
    // Créer le SettingsService pour les tests
    final prefsService = await SettingsService.createForTesting();

    // Créer le AppStateProvider
    final appStateProvider = AppStateProvider(prefsService);

    // Initialiser sans contexte pour les tests
    await appStateProvider.initializeForTesting();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(appStateProvider: appStateProvider));

    // Attendre que l'initialisation se termine
    await tester.pumpAndSettle();

    // Vérifier que l'application charge correctement
    // (cherche des éléments de la page d'accueil)
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  test('AppStateProvider should manage currency changes', () async {
    // Créer le SettingsService pour les tests
    final prefsService = await SettingsService.createForTesting();

    // Créer le AppStateProvider
    final appStateProvider = AppStateProvider(prefsService);

    // Initialiser pour les tests
    await appStateProvider.initializeForTesting();

    // Vérifier la devise par défaut
    expect(appStateProvider.currency.code, 'EUR');

    // Changer la devise
    await appStateProvider.setCurrency(CurrencyModel.dollar);

    // Vérifier que la devise a changé
    expect(appStateProvider.currency.code, 'USD');

    // Vérifier que la valeur est persistée
    final savedCurrency = prefsService.getSavedCurrency();
    expect(savedCurrency?.code, 'USD');
  });

  test('AppStateProvider should manage theme mode changes', () async {
    // Créer le SettingsService pour les tests
    final prefsService = await SettingsService.createForTesting();

    // Créer le AppStateProvider
    final appStateProvider = AppStateProvider(prefsService);

    // Initialiser pour les tests
    await appStateProvider.initializeForTesting();

    // Vérifier le mode de thème par défaut
    expect(appStateProvider.themeMode, ThemeMode.system);

    // Changer le mode de thème
    await appStateProvider.setThemeMode(ThemeMode.dark);

    // Vérifier que le mode a changé
    expect(appStateProvider.themeMode, ThemeMode.dark);

    // Vérifier que la valeur est persistée
    final savedThemeMode = prefsService.getSavedThemeMode();
    expect(savedThemeMode, ThemeMode.dark);
  });

  test('AppStateProvider should manage locale changes', () async {
    // Créer le SettingsService pour les tests
    final prefsService = await SettingsService.createForTesting();

    // Créer le AppStateProvider
    final appStateProvider = AppStateProvider(prefsService);

    // Initialiser pour les tests
    await appStateProvider.initializeForTesting();

    // Vérifier la locale par défaut
    expect(appStateProvider.locale.languageCode, 'fr');

    // Changer la locale
    await appStateProvider.setLocale(const Locale('en', 'US'));

    // Vérifier que la locale a changé
    expect(appStateProvider.locale.languageCode, 'en');
    expect(appStateProvider.locale.countryCode, 'US');

    // Vérifier que la valeur est persistée
    final savedLocale = prefsService.getSavedLocale();
    expect(savedLocale?.languageCode, 'en');
  });

  test('Currency should map correctly from locale', () {
    // Test des mappings langue -> devise
    expect(CurrencyModel.fromLocale('fr_FR'), CurrencyModel.euro);
    expect(CurrencyModel.fromLocale('en_US'), CurrencyModel.dollar);
    expect(CurrencyModel.fromLocale('en_GB'), CurrencyModel.pound);
    expect(CurrencyModel.fromLocale('ja_JP'), CurrencyModel.yen);
    expect(CurrencyModel.fromLocale('de_DE'), CurrencyModel.euro);
    expect(CurrencyModel.fromLocale('es_ES'), CurrencyModel.euro);
  });

  test('SettingsService should persist and retrieve values', () async {
    // Créer le SettingsService pour les tests
    final prefsService = await SettingsService.createForTesting();

    // Sauvegarder des valeurs
    await prefsService.saveThemeMode(ThemeMode.light);
    await prefsService.saveCurrency(CurrencyModel.pound);
    await prefsService.saveLocale(const Locale('en', 'GB'));

    // Récupérer et vérifier
    expect(prefsService.getSavedThemeMode(), ThemeMode.light);
    expect(prefsService.getSavedCurrency(), CurrencyModel.pound);
    expect(prefsService.getSavedLocale()?.languageCode, 'en');
    expect(prefsService.getSavedLocale()?.countryCode, 'GB');
  });
}
