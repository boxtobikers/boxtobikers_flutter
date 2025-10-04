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
      'Make a tour to discover, it\'s here!';

  @override
  String get homeItemWhoAmITitle => 'Who am I?';

  @override
  String get homeItemWhoAmIDescription =>
      'We tell you everything... or almost!';

  @override
  String get homeItemSettingsTitle => 'Settings';

  @override
  String get homeItemSettingsDescription =>
      'Configure cookies, notifications, ...';

  @override
  String get ridingTitle => 'My rides';

  @override
  String get ridingStartButton => 'Start a ride';

  @override
  String get ridingStopButton => 'End ride';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonSave => 'Save';
}
