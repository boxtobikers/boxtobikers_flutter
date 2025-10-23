// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get flag => 'fr';

  @override
  String get appDrawerAboutTitle => 'Qui sommes-nous ?';

  @override
  String get appDrawerHomeTitle => 'Accueil';

  @override
  String get appDrawerRidingTitle => 'En route !';

  @override
  String get appDrawerSettingsTitle => 'Vos préférences';

  @override
  String get appTitle => 'BoxtoBikers';

  @override
  String get homeTitle => 'BoxToBikers, en route !';

  @override
  String get homeCounterLabel =>
      'Vous avez appuyé sur le bouton ce nombre de fois :';

  @override
  String get homeIncrementTooltip => 'Incrémenter';

  @override
  String get homeLoginButton => 'Se connecter';

  @override
  String homeHello(String userName) {
    return 'Bonjour $userName';
  }

  @override
  String get homeItemExploreTitle => 'Visiter le site';

  @override
  String get homeItemExploreDescription => 'Envie de découvrir, c\'est ici !';

  @override
  String get homeItemHistoryTitle => 'Vos voyages passés...';

  @override
  String get homeItemHistoryDescription => 'Retrouvez vos anciens trajets';

  @override
  String get homeItemWhoAmITitle => 'Qui sommes-nous ?';

  @override
  String get homeItemWhoAmIDescription => 'On vous dit tout… ou presque !';

  @override
  String get homeItemSettingsTitle => 'Vos paramètres';

  @override
  String get homeItemSettingsDescription => 'Vos cookies, notifications…';

  @override
  String get profilTitle => 'Profil';

  @override
  String get profilPersonalInfoTitle => 'Informations personnelles';

  @override
  String get profilContactTitle => 'Contact';

  @override
  String get profilAddressTitle => 'Adresse';

  @override
  String get profilFirstNameLabel => 'Prénom';

  @override
  String get profilFirstNameError => 'Veuillez entrer votre prénom';

  @override
  String get profilLastNameLabel => 'Nom';

  @override
  String get profilLastNameError => 'Veuillez entrer votre nom';

  @override
  String get profilBirthDateLabel => 'Date de naissance';

  @override
  String get profilEmailLabel => 'Email';

  @override
  String get profilEmailError => 'Veuillez entrer votre email';

  @override
  String get profilEmailInvalidError => 'Veuillez entrer un email valide';

  @override
  String get profilPhoneLabel => 'Téléphone';

  @override
  String get profilPhoneError => 'Veuillez entrer votre téléphone';

  @override
  String get profilAddressLabel => 'Adresse complète';

  @override
  String get profilAddressError => 'Veuillez entrer votre adresse';

  @override
  String get profilEditButton => 'Modifier le profil';

  @override
  String get profilSaveSuccess => 'Profil mis à jour avec succès';

  @override
  String get profilPhotoChangeInfo => 'Modification de la photo à venir';

  @override
  String get profilDangerZoneTitle => 'Zone de danger';

  @override
  String get profilDangerZoneSubtitle =>
      'Actions irréversibles concernant votre compte';

  @override
  String get profilDeleteAccountButton => 'Supprimer le compte';

  @override
  String get profilDeleteAccountInfo =>
      'Fonctionnalité de suppression de compte à venir';

  @override
  String get profilDeleteDialogTitle => 'Supprimer votre compte ?';

  @override
  String get profilDeleteDialogMessage =>
      'Êtes-vous sûr de vouloir supprimer définitivement votre compte ? Cette action est irréversible.';

  @override
  String get profilDeleteDialogWarning =>
      'Toutes vos données seront définitivement supprimées';

  @override
  String get ridingTitle => 'Mes trajets';

  @override
  String get ridingStartButton => 'Commencer un trajet';

  @override
  String get ridingStopButton => 'Terminer le trajet';

  @override
  String get aboutTitle => 'À propos de nous';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsGeneralTitle => 'Général';

  @override
  String get settingsGeneralSubTitle =>
      'Configurez vos préférences et paramètres de l\'application';

  @override
  String get settingsNotificationsTitle => 'Notifications';

  @override
  String get settingsNotificationsText => 'Actuellement désactivées';

  @override
  String get settingsNotificationsTextEnabled => 'Actuellement activées';

  @override
  String get settingsProfilTitle => 'Profil';

  @override
  String get settingsDisplayTitle => 'Affichage';

  @override
  String get settingsDistanceTitle => 'Distance';

  @override
  String get settingsDeviseTitle => 'Devise';

  @override
  String get settingsThemeTitle => 'Thème';

  @override
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get settingsThemeSystem => 'Système';

  @override
  String get settingsLegalTitle => 'Mentions légales CGU';

  @override
  String get settingsLegalDocumentsTitle => 'Documents règlementaires';

  @override
  String get settingsLegalSubTitle =>
      'Accéder à toutes les informations importantes';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonConfirm => 'Confirmer';

  @override
  String get commonDownload => 'Télécharger';

  @override
  String get commonView => 'Consulter';

  @override
  String get commonPersonalize => 'Personnaliser';

  @override
  String get commonUpdate => 'Modifier';

  @override
  String get commonRetry => 'Réessayer';

  @override
  String get commonSave => 'Enregistrer';
}
