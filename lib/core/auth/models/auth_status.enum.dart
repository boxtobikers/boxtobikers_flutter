/// Énumération des états d'authentification possibles
enum AuthStatus {
  /// État initial - vérification en cours
  initial,

  /// Chargement - authentification en cours
  loading,

  /// Utilisateur connecté en mode anonyme (VISITOR)
  anonymous,

  /// Utilisateur authentifié (CLIENT ou ADMIN)
  authenticated,

  /// Erreur lors de l'authentification
  error,

  /// Utilisateur non connecté
  unauthenticated,
}

