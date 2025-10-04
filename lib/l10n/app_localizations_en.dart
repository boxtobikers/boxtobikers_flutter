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
  String get homeTitle => 'BoxToBikers, let\'s go ! ';

  @override
  String get homeSubTitle => 'Let\'s go ! ';

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
