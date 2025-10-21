import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @flag.
  ///
  /// In en, this message translates to:
  /// **'en'**
  String get flag;

  /// No description provided for @appDrawerAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'What about us ?'**
  String get appDrawerAboutTitle;

  /// No description provided for @appDrawerHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get appDrawerHomeTitle;

  /// No description provided for @appDrawerRidingTitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s go !'**
  String get appDrawerRidingTitle;

  /// No description provided for @appDrawerSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get appDrawerSettingsTitle;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'BoxtoBikers'**
  String get appTitle;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to my site'**
  String get homeTitle;

  /// No description provided for @homeCounterLabel.
  ///
  /// In en, this message translates to:
  /// **'You have pushed the button this many times:'**
  String get homeCounterLabel;

  /// No description provided for @homeIncrementTooltip.
  ///
  /// In en, this message translates to:
  /// **'Increment'**
  String get homeIncrementTooltip;

  /// No description provided for @homeLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get homeLoginButton;

  /// A message with a single parameter
  ///
  /// In en, this message translates to:
  /// **'Hello {userName}'**
  String homeHello(String userName);

  /// No description provided for @homeItemExploreTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore the site'**
  String get homeItemExploreTitle;

  /// No description provided for @homeItemExploreDescription.
  ///
  /// In en, this message translates to:
  /// **'Make a tour to discover, it\'s here !'**
  String get homeItemExploreDescription;

  /// No description provided for @homeItemHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Your past travels...'**
  String get homeItemHistoryTitle;

  /// No description provided for @homeItemHistoryDescription.
  ///
  /// In en, this message translates to:
  /// **'Find all your previous journeys.'**
  String get homeItemHistoryDescription;

  /// No description provided for @homeItemWhoAmITitle.
  ///
  /// In en, this message translates to:
  /// **'Who am I ?'**
  String get homeItemWhoAmITitle;

  /// No description provided for @homeItemWhoAmIDescription.
  ///
  /// In en, this message translates to:
  /// **'We tell you everything... or almost !'**
  String get homeItemWhoAmIDescription;

  /// No description provided for @homeItemSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your settings'**
  String get homeItemSettingsTitle;

  /// No description provided for @homeItemSettingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Cookies, notifications, ...'**
  String get homeItemSettingsDescription;

  /// No description provided for @profilTitle.
  ///
  /// In en, this message translates to:
  /// **'User profile'**
  String get profilTitle;

  /// No description provided for @profilPersonalInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal information'**
  String get profilPersonalInfoTitle;

  /// No description provided for @profilContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get profilContactTitle;

  /// No description provided for @profilAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get profilAddressTitle;

  /// No description provided for @profilFirstNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get profilFirstNameLabel;

  /// No description provided for @profilFirstNameError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your first name'**
  String get profilFirstNameError;

  /// No description provided for @profilLastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get profilLastNameLabel;

  /// No description provided for @profilLastNameError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your last name'**
  String get profilLastNameError;

  /// No description provided for @profilBirthDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get profilBirthDateLabel;

  /// No description provided for @profilEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profilEmailLabel;

  /// No description provided for @profilEmailError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get profilEmailError;

  /// No description provided for @profilEmailInvalidError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get profilEmailInvalidError;

  /// No description provided for @profilPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get profilPhoneLabel;

  /// No description provided for @profilPhoneError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get profilPhoneError;

  /// No description provided for @profilAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Full address'**
  String get profilAddressLabel;

  /// No description provided for @profilAddressError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your address'**
  String get profilAddressError;

  /// No description provided for @profilEditButton.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profilEditButton;

  /// No description provided for @profilSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profilSaveSuccess;

  /// No description provided for @profilPhotoChangeInfo.
  ///
  /// In en, this message translates to:
  /// **'Photo modification coming soon'**
  String get profilPhotoChangeInfo;

  /// No description provided for @profilDangerZoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Danger zone'**
  String get profilDangerZoneTitle;

  /// No description provided for @profilDangerZoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Irreversible actions concerning your account'**
  String get profilDangerZoneSubtitle;

  /// No description provided for @profilDeleteAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get profilDeleteAccountButton;

  /// No description provided for @profilDeleteAccountInfo.
  ///
  /// In en, this message translates to:
  /// **'Account deletion feature coming soon'**
  String get profilDeleteAccountInfo;

  /// No description provided for @profilDeleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete your account?'**
  String get profilDeleteDialogTitle;

  /// No description provided for @profilDeleteDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete your account? This action is irreversible.'**
  String get profilDeleteDialogMessage;

  /// No description provided for @profilDeleteDialogWarning.
  ///
  /// In en, this message translates to:
  /// **'All your data will be permanently deleted'**
  String get profilDeleteDialogWarning;

  /// No description provided for @ridingTitle.
  ///
  /// In en, this message translates to:
  /// **'My rides'**
  String get ridingTitle;

  /// No description provided for @ridingStartButton.
  ///
  /// In en, this message translates to:
  /// **'Start a ride'**
  String get ridingStartButton;

  /// No description provided for @ridingStopButton.
  ///
  /// In en, this message translates to:
  /// **'End ride'**
  String get ridingStopButton;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About us'**
  String get aboutTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsGeneralTitle.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsGeneralTitle;

  /// No description provided for @settingsGeneralSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Configure your application preferences and settings'**
  String get settingsGeneralSubTitle;

  /// No description provided for @settingsNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotificationsTitle;

  /// No description provided for @settingsNotificationsText.
  ///
  /// In en, this message translates to:
  /// **'disabled currently'**
  String get settingsNotificationsText;

  /// No description provided for @settingsNotificationsTextEnabled.
  ///
  /// In en, this message translates to:
  /// **'enabled currently'**
  String get settingsNotificationsTextEnabled;

  /// No description provided for @settingsProfilTitle.
  ///
  /// In en, this message translates to:
  /// **'Profil'**
  String get settingsProfilTitle;

  /// No description provided for @settingsDisplayTitle.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get settingsDisplayTitle;

  /// No description provided for @settingsDistanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get settingsDistanceTitle;

  /// No description provided for @settingsDeviseTitle.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get settingsDeviseTitle;

  /// No description provided for @settingsThemeTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsThemeTitle;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsLegalTitle.
  ///
  /// In en, this message translates to:
  /// **'Legal notices T&Cs'**
  String get settingsLegalTitle;

  /// No description provided for @settingsLegalDocumentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Regulatory documents'**
  String get settingsLegalDocumentsTitle;

  /// No description provided for @settingsLegalSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Access all important legal information'**
  String get settingsLegalSubTitle;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// No description provided for @commonDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get commonDownload;

  /// No description provided for @commonView.
  ///
  /// In en, this message translates to:
  /// **'Consult'**
  String get commonView;

  /// No description provided for @commonPersonalize.
  ///
  /// In en, this message translates to:
  /// **'Personalize'**
  String get commonPersonalize;

  /// No description provided for @commonUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get commonUpdate;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
