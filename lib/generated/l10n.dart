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

  /// `User profile`
  String get profilTitle {
    return Intl.message(
      'User profile',
      name: 'profilTitle',
      desc: '',
      args: [],
    );
  }

  /// `Personal information`
  String get profilPersonalInfoTitle {
    return Intl.message(
      'Personal information',
      name: 'profilPersonalInfoTitle',
      desc: '',
      args: [],
    );
  }

  /// `Contact`
  String get profilContactTitle {
    return Intl.message(
      'Contact',
      name: 'profilContactTitle',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get profilAddressTitle {
    return Intl.message(
      'Address',
      name: 'profilAddressTitle',
      desc: '',
      args: [],
    );
  }

  /// `First name`
  String get profilFirstNameLabel {
    return Intl.message(
      'First name',
      name: 'profilFirstNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your first name`
  String get profilFirstNameError {
    return Intl.message(
      'Please enter your first name',
      name: 'profilFirstNameError',
      desc: '',
      args: [],
    );
  }

  /// `Last name`
  String get profilLastNameLabel {
    return Intl.message(
      'Last name',
      name: 'profilLastNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your last name`
  String get profilLastNameError {
    return Intl.message(
      'Please enter your last name',
      name: 'profilLastNameError',
      desc: '',
      args: [],
    );
  }

  /// `Date of birth`
  String get profilBirthDateLabel {
    return Intl.message(
      'Date of birth',
      name: 'profilBirthDateLabel',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get profilEmailLabel {
    return Intl.message(
      'Email',
      name: 'profilEmailLabel',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email`
  String get profilEmailError {
    return Intl.message(
      'Please enter your email',
      name: 'profilEmailError',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email`
  String get profilEmailInvalidError {
    return Intl.message(
      'Please enter a valid email',
      name: 'profilEmailInvalidError',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get profilPhoneLabel {
    return Intl.message(
      'Phone',
      name: 'profilPhoneLabel',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your phone number`
  String get profilPhoneError {
    return Intl.message(
      'Please enter your phone number',
      name: 'profilPhoneError',
      desc: '',
      args: [],
    );
  }

  /// `Full address`
  String get profilAddressLabel {
    return Intl.message(
      'Full address',
      name: 'profilAddressLabel',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your address`
  String get profilAddressError {
    return Intl.message(
      'Please enter your address',
      name: 'profilAddressError',
      desc: '',
      args: [],
    );
  }

  /// `Edit profile`
  String get profilEditButton {
    return Intl.message(
      'Edit profile',
      name: 'profilEditButton',
      desc: '',
      args: [],
    );
  }

  /// `Profile updated successfully`
  String get profilSaveSuccess {
    return Intl.message(
      'Profile updated successfully',
      name: 'profilSaveSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Photo modification coming soon`
  String get profilPhotoChangeInfo {
    return Intl.message(
      'Photo modification coming soon',
      name: 'profilPhotoChangeInfo',
      desc: '',
      args: [],
    );
  }

  /// `Danger zone`
  String get profilDangerZoneTitle {
    return Intl.message(
      'Danger zone',
      name: 'profilDangerZoneTitle',
      desc: '',
      args: [],
    );
  }

  /// `Irreversible actions concerning your account`
  String get profilDangerZoneSubtitle {
    return Intl.message(
      'Irreversible actions concerning your account',
      name: 'profilDangerZoneSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Delete account`
  String get profilDeleteAccountButton {
    return Intl.message(
      'Delete account',
      name: 'profilDeleteAccountButton',
      desc: '',
      args: [],
    );
  }

  /// `Account deletion feature coming soon`
  String get profilDeleteAccountInfo {
    return Intl.message(
      'Account deletion feature coming soon',
      name: 'profilDeleteAccountInfo',
      desc: '',
      args: [],
    );
  }

  /// `Delete your account?`
  String get profilDeleteDialogTitle {
    return Intl.message(
      'Delete your account?',
      name: 'profilDeleteDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to permanently delete your account? This action is irreversible.`
  String get profilDeleteDialogMessage {
    return Intl.message(
      'Are you sure you want to permanently delete your account? This action is irreversible.',
      name: 'profilDeleteDialogMessage',
      desc: '',
      args: [],
    );
  }

  /// `All your data will be permanently deleted`
  String get profilDeleteDialogWarning {
    return Intl.message(
      'All your data will be permanently deleted',
      name: 'profilDeleteDialogWarning',
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

  /// `About us`
  String get aboutTitle {
    return Intl.message(
      'About us',
      name: 'aboutTitle',
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

  /// `General`
  String get settingsGeneralTitle {
    return Intl.message(
      'General',
      name: 'settingsGeneralTitle',
      desc: '',
      args: [],
    );
  }

  /// `Configure your application preferences and settings`
  String get settingsGeneralSubTitle {
    return Intl.message(
      'Configure your application preferences and settings',
      name: 'settingsGeneralSubTitle',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get settingsNotificationsTitle {
    return Intl.message(
      'Notifications',
      name: 'settingsNotificationsTitle',
      desc: '',
      args: [],
    );
  }

  /// `disabled currently`
  String get settingsNotificationsText {
    return Intl.message(
      'disabled currently',
      name: 'settingsNotificationsText',
      desc: '',
      args: [],
    );
  }

  /// `enabled currently`
  String get settingsNotificationsTextEnabled {
    return Intl.message(
      'enabled currently',
      name: 'settingsNotificationsTextEnabled',
      desc: '',
      args: [],
    );
  }

  /// `Profil`
  String get settingsProfilTitle {
    return Intl.message(
      'Profil',
      name: 'settingsProfilTitle',
      desc: '',
      args: [],
    );
  }

  /// `Display`
  String get settingsDisplayTitle {
    return Intl.message(
      'Display',
      name: 'settingsDisplayTitle',
      desc: '',
      args: [],
    );
  }

  /// `Distance`
  String get settingsDistanceTitle {
    return Intl.message(
      'Distance',
      name: 'settingsDistanceTitle',
      desc: '',
      args: [],
    );
  }

  /// `Currency`
  String get settingsDeviseTitle {
    return Intl.message(
      'Currency',
      name: 'settingsDeviseTitle',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get settingsThemeTitle {
    return Intl.message(
      'Theme',
      name: 'settingsThemeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get settingsThemeLight {
    return Intl.message(
      'Light',
      name: 'settingsThemeLight',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get settingsThemeDark {
    return Intl.message(
      'Dark',
      name: 'settingsThemeDark',
      desc: '',
      args: [],
    );
  }

  /// `System`
  String get settingsThemeSystem {
    return Intl.message(
      'System',
      name: 'settingsThemeSystem',
      desc: '',
      args: [],
    );
  }

  /// `Legal notices T&Cs`
  String get settingsLegalTitle {
    return Intl.message(
      'Legal notices T&Cs',
      name: 'settingsLegalTitle',
      desc: '',
      args: [],
    );
  }

  /// `Regulatory documents`
  String get settingsLegalDocumentsTitle {
    return Intl.message(
      'Regulatory documents',
      name: 'settingsLegalDocumentsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Access all important legal information`
  String get settingsLegalSubTitle {
    return Intl.message(
      'Access all important legal information',
      name: 'settingsLegalSubTitle',
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

  /// `Download`
  String get commonDownload {
    return Intl.message(
      'Download',
      name: 'commonDownload',
      desc: '',
      args: [],
    );
  }

  /// `Consult`
  String get commonView {
    return Intl.message(
      'Consult',
      name: 'commonView',
      desc: '',
      args: [],
    );
  }

  /// `Personalize`
  String get commonPersonalize {
    return Intl.message(
      'Personalize',
      name: 'commonPersonalize',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get commonUpdate {
    return Intl.message(
      'Update',
      name: 'commonUpdate',
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
