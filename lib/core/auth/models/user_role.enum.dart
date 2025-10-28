/// Énumération des rôles utilisateur dans l'application
/// Correspond aux valeurs de la table `public.roles` dans Supabase
enum UserRole {
  /// Administrateur - accès complet à l'application
  admin('ADMIN'),

  /// Visiteur - utilisateur anonyme avec accès limité en lecture seule
  visitor('VISITOR'),

  /// Client - utilisateur authentifié avec accès aux fonctionnalités principales
  client('CLIENT');

  final String value;

  const UserRole(this.value);

  /// Créer un UserRole depuis une chaîne de caractères
  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.visitor, // Par défaut VISITOR
    );
  }

  /// Vérifie si le rôle a les permissions d'administration
  bool get isAdmin => this == UserRole.admin;

  /// Vérifie si le rôle est un visiteur anonyme
  bool get isVisitor => this == UserRole.visitor;

  /// Vérifie si le rôle est un client authentifié
  bool get isClient => this == UserRole.client;

  /// Vérifie si le rôle est authentifié (client ou admin)
  bool get isAuthenticated => this == UserRole.client || this == UserRole.admin;
}

