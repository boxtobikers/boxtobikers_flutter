import 'package:boxtobikers/core/auth/models/user_session.model.dart';
import 'package:boxtobikers/features/profil/business/models/user_profile.model.dart';

/// Helpers pour manipuler les données de session utilisateur
/// Principe DRY : Centralise la logique commune de récupération des informations
/// utilisateur depuis l'AuthProvider.currentSession
class AppSessionHelpers {
  /// Extrait les initiales du prénom et nom du profil utilisateur
  ///
  /// Retourne les initiales en majuscules (ex: "Jean Dupont" → "JD")
  /// Retourne "U" si le profil est null ou si les noms sont vides
  ///
  /// Utilisé dans:
  /// - app_navigation_drawer.widget.dart
  /// - profil.pages.dart
  /// - home.pages.dart (ou autres pages affichant l'avatar)
  static String getInitials(UserProfileModel? userProfile) {
    if (userProfile == null) return 'U';

    final firstName = userProfile.firstName;
    final lastName = userProfile.lastName;

    if (firstName.isEmpty && lastName.isEmpty) return 'U';

    final firstInitial = firstName.isNotEmpty ? firstName[0] : '';
    final lastInitial = lastName.isNotEmpty ? lastName[0] : '';

    return '$firstInitial$lastInitial'.toUpperCase();
  }

  /// Retourne le nom complet de l'utilisateur
  ///
  /// Retourne "Utilisateur" si le profil est null
  /// Utilise la propriété fullName du UserProfileModel
  static String getFullName(UserProfileModel? userProfile) {
    if (userProfile == null) return 'Utilisateur';
    return userProfile.fullName;
  }

  /// Retourne l'email de l'utilisateur depuis la session
  ///
  /// Retourne "Non connecté" si la session est null ou l'email vide
  static String getEmail(UserSession? userSession) {
    if (userSession == null || userSession.email.isEmpty) {
      return 'Non connecté';
    }
    return userSession.email;
  }

  /// Vérifie si l'utilisateur a un profil complet
  ///
  /// Un profil est considéré complet si au moins le prénom ou le nom est renseigné
  static bool hasProfileData(UserProfileModel? userProfile) {
    if (userProfile == null) return false;
    return userProfile.firstName.isNotEmpty || userProfile.lastName.isNotEmpty;
  }

  /// Retourne une couleur d'avatar basée sur les initiales
  ///
  /// Génère une couleur déterministe basée sur le hashCode des initiales
  /// pour avoir toujours la même couleur pour le même utilisateur
  static int getAvatarColorSeed(UserProfileModel? userProfile) {
    final initials = getInitials(userProfile);
    return initials.hashCode;
  }

  /// Retourne le prénom ou "Visiteur" par défaut
  static String getFirstName(UserProfileModel? userProfile) {
    if (userProfile == null || userProfile.firstName.isEmpty) {
      return 'Visiteur';
    }
    return userProfile.firstName;
  }

  /// Retourne le rôle de l'utilisateur en texte lisible
  ///
  /// Exemples: "Visiteur", "Utilisateur", "Admin", etc.
  static String getRoleLabel(UserSession? userSession) {
    if (userSession == null) return 'Visiteur';
    if (userSession.isAnonymous) return 'Visiteur';
    return userSession.role.value;
  }

  /// Vérifie si l'utilisateur est authentifié (pas anonyme)
  static bool isAuthenticated(UserSession? userSession) {
    return userSession?.isAuthenticated ?? false;
  }

  /// Vérifie si l'utilisateur est un visiteur anonyme
  static bool isVisitor(UserSession? userSession) {
    return userSession?.isAnonymous ?? true;
  }
}

