// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get flag => 'en';

  @override
  String get appDrawerAboutTitle => 'What about us ?';

  @override
  String get appDrawerHomeTitle => 'Home';

  @override
  String get appDrawerRidingTitle => 'Let\'s go !';

  @override
  String get appDrawerSettingsTitle => 'Settings';

  @override
  String get appTitle => 'BoxtoBikers';

  @override
  String get homeTitle => 'Welcome to my site';

  @override
  String get homeCounterLabel => 'You have pushed the button this many times:';

  @override
  String get homeIncrementTooltip => 'Increment';

  @override
  String get homeLoginButton => 'Login';

  @override
  String homeHello(String userName) {
    return 'Hello $userName';
  }

  @override
  String get homeItemExploreTitle => 'Explore the site';

  @override
  String get homeItemExploreDescription =>
      'Make a tour to discover, it\'s here !';

  @override
  String get homeItemWhoAmITitle => 'Who am I ?';

  @override
  String get homeItemWhoAmIDescription =>
      'We tell you everything... or almost !';

  @override
  String get homeItemSettingsTitle => 'Your settings';

  @override
  String get homeItemSettingsDescription => 'Cookies, notifications, ...';

  @override
  String get ridingTitle => 'My rides';

  @override
  String get ridingStartButton => 'Start a ride';

  @override
  String get ridingStopButton => 'End ride';

  @override
  String get aboutTitle => 'About us';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsGeneralTitle => 'General';

  @override
  String get settingsGeneralSubTitle =>
      'Configure your application preferences and settings';

  @override
  String get settingsNotificationsTitle => 'Notifications';

  @override
  String get settingsNotificationsText => 'disabled currently';

  @override
  String get settingsNotificationsTextEnabled => 'enabled currently';

  @override
  String get settingsProfilTitle => 'Profil';

  @override
  String get settingsDisplayTitle => 'Display';

  @override
  String get settingsDistanceTitle => 'Distance';

  @override
  String get settingsDeviseTitle => 'Currency';

  @override
  String get settingsThemeTitle => 'Theme';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsLegalTitle => 'Legal notices T&Cs';

  @override
  String get settingsLegalDocumentsTitle => 'Regulatory documents';

  @override
  String get settingsLegalSubTitle => 'Access all important legal information';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonView => 'Consult';

  @override
  String get commonPersonalize => 'Personalize';

  @override
  String get commonUpdate => 'Update';

  @override
  String get commonSave => 'Save';
}
