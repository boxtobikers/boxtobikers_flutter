// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `en`
  String get flag {
    return Intl.message(
      'en',
      name: 'flag',
      desc: '',
      args: [],
    );
  }

  /// `What about us ?`
  String get appDrawerAboutTitle {
    return Intl.message(
      'What about us ?',
      name: 'appDrawerAboutTitle',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get appDrawerHomeTitle {
    return Intl.message(
      'Home',
      name: 'appDrawerHomeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Let's go !`
  String get appDrawerRidingTitle {
    return Intl.message(
      'Let\'s go !',
      name: 'appDrawerRidingTitle',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get appDrawerSettingsTitle {
    return Intl.message(
      'Settings',
      name: 'appDrawerSettingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `BoxtoBikers`
  String get appTitle {
    return Intl.message(
      'BoxtoBikers',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to my site`
  String get homeTitle {
    return Intl.message(
      'Welcome to my site',
      name: 'homeTitle',
      desc: '',
      args: [],
    );
  }

  /// `You have pushed the button this many times:`
  String get homeCounterLabel {
    return Intl.message(
      'You have pushed the button this many times:',
      name: 'homeCounterLabel',
      desc: '',
      args: [],
    );
  }

  /// `Increment`
  String get homeIncrementTooltip {
    return Intl.message(
      'Increment',
      name: 'homeIncrementTooltip',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get homeLoginButton {
    return Intl.message(
      'Login',
      name: 'homeLoginButton',
      desc: '',
      args: [],
    );
  }

  /// `Hello {userName}`
  String homeHello(Object userName) {
    return Intl.message(
      'Hello $userName',
      name: 'homeHello',
      desc: 'A message with a single parameter',
      args: [userName],
    );
  }

  /// `Explore the site`
  String get homeItemExploreTitle {
    return Intl.message(
      'Explore the site',
      name: 'homeItemExploreTitle',
      desc: '',
      args: [],
    );
  }

  /// `Make a tour to discover, it's here !`
  String get homeItemExploreDescription {
    return Intl.message(
      'Make a tour to discover, it\'s here !',
      name: 'homeItemExploreDescription',
      desc: '',
      args: [],
    );
  }

  /// `Who am I ?`
  String get homeItemWhoAmITitle {
    return Intl.message(
      'Who am I ?',
      name: 'homeItemWhoAmITitle',
      desc: '',
      args: [],
    );
  }

  /// `We tell you everything... or almost !`
  String get homeItemWhoAmIDescription {
    return Intl.message(
      'We tell you everything... or almost !',
      name: 'homeItemWhoAmIDescription',
      desc: '',
      args: [],
    );
  }

  /// `Your settings`
  String get homeItemSettingsTitle {
    return Intl.message(
      'Your settings',
      name: 'homeItemSettingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Cookies, notifications, ...`
  String get homeItemSettingsDescription {
    return Intl.message(
      'Cookies, notifications, ...',
      name: 'homeItemSettingsDescription',
      desc: '',
      args: [],
    );
  }

  /// `My rides`
  String get ridingTitle {
    return Intl.message(
      'My rides',
      name: 'ridingTitle',
      desc: '',
      args: [],
    );
  }

  /// `Start a ride`
  String get ridingStartButton {
    return Intl.message(
      'Start a ride',
      name: 'ridingStartButton',
      desc: '',
      args: [],
    );
  }

  /// `End ride`
  String get ridingStopButton {
    return Intl.message(
      'End ride',
      name: 'ridingStopButton',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settingsTitle {
    return Intl.message(
      'Settings',
      name: 'settingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get commonCancel {
    return Intl.message(
      'Cancel',
      name: 'commonCancel',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get commonConfirm {
    return Intl.message(
      'Confirm',
      name: 'commonConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get commonSave {
    return Intl.message(
      'Save',
      name: 'commonSave',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
