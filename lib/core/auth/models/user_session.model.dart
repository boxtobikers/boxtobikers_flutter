import 'package:boxtobikers/core/auth/models/user_role.enum.dart';
import 'package:boxtobikers/features/profil/business/models/user_profile.model.dart';

/// Modèle représentant une session utilisateur complète
/// Combine les informations d'authentification Supabase et le profil applicatif
class UserSession {
  /// Identifiant unique de la session (UUID)
  final String id;

  /// Rôle de l'utilisateur dans l'application
  final UserRole role;

  /// Profil utilisateur avec les données personnelles
  final UserProfileModel profile;

  /// ID de l'utilisateur Supabase (null si anonyme)
  final String? supabaseUserId;

  /// Token d'authentification Supabase (null si anonyme)
  final String? supabaseToken;

  /// Date de création de la session
  final DateTime createdAt;

  /// Date de dernière activité
  final DateTime lastActiveAt;

  /// Email de l'utilisateur (peut être vide pour anonymous)
  final String email;

  UserSession({
    required this.id,
    required this.role,
    required this.profile,
    this.supabaseUserId,
    this.supabaseToken,
    required this.createdAt,
    required this.lastActiveAt,
    required this.email,
  });

  /// Vérifie si la session est anonyme
  bool get isAnonymous => role == UserRole.visitor && supabaseUserId == null;

  /// Vérifie si la session est authentifiée
  bool get isAuthenticated => role.isAuthenticated && supabaseUserId != null;

  /// Vérifie si la session est valide (soit VISITOR local, soit authentifié avec Supabase)
  bool get isValid => isAnonymous || (supabaseUserId != null);

  /// Vérifie si c'est une session VISITOR locale (pas d'utilisateur Supabase)
  bool get isVisitorSession => role == UserRole.visitor && supabaseUserId == null;

  /// Crée une copie de la session avec des modifications
  UserSession copyWith({
    String? id,
    UserRole? role,
    UserProfileModel? profile,
    String? supabaseUserId,
    String? supabaseToken,
    DateTime? createdAt,
    DateTime? lastActiveAt,
    String? email,
  }) {
    return UserSession(
      id: id ?? this.id,
      role: role ?? this.role,
      profile: profile ?? this.profile,
      supabaseUserId: supabaseUserId ?? this.supabaseUserId,
      supabaseToken: supabaseToken ?? this.supabaseToken,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      email: email ?? this.email,
    );
  }

  /// Convertit la session en Map pour la persistance
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role.value,
      'profile': profile.toJson(),
      'supabaseUserId': supabaseUserId,
      'supabaseToken': supabaseToken,
      'createdAt': createdAt.toIso8601String(),
      'lastActiveAt': lastActiveAt.toIso8601String(),
      'email': email,
    };
  }

  /// Crée une session depuis un Map (désérialisation)
  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      id: json['id'] as String,
      role: UserRole.fromString(json['role'] as String),
      profile: UserProfileModel.fromJson(json['profile'] as Map<String, dynamic>),
      supabaseUserId: json['supabaseUserId'] as String?,
      supabaseToken: json['supabaseToken'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastActiveAt: DateTime.parse(json['lastActiveAt'] as String),
      email: json['email'] as String? ?? '',
    );
  }

  /// Factory pour créer une session VISITOR locale
  /// Utilise le profil VISITOR pré-créé dans la base de données
  factory UserSession.createVisitor({
    required String profileId,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? address,
    DateTime? birthdate,
  }) {
    final now = DateTime.now();
    return UserSession(
      id: profileId, // UUID du profil VISITOR pré-créé
      role: UserRole.visitor,
      profile: UserProfileModel(
        firstName: firstName ?? 'Visiteur',
        lastName: lastName ?? 'Anonyme',
        email: email ?? '',
        phone: phone ?? '',
        address: address ?? '',
        birthdate: birthdate,
      ),
      supabaseUserId: null, // Pas de session Supabase active
      supabaseToken: null,  // Pas de token
      createdAt: now,
      lastActiveAt: now,
      email: email ?? '',
    );
  }

  /// Factory pour créer une session visiteur anonyme avec utilisateur Supabase
  /// DEPRECATED: Utilisé uniquement si Supabase anonymous auth est utilisé
  /// Préférez createVisitor() pour utiliser le profil VISITOR pré-créé
  @Deprecated('Utilisez createVisitor() à la place pour utiliser le profil VISITOR pré-créé')
  factory UserSession.createAnonymous({
    required String supabaseUserId,
    String? supabaseToken,
  }) {
    final now = DateTime.now();
    return UserSession(
      id: supabaseUserId,
      role: UserRole.visitor,
      profile: UserProfileModel.createVisitor(),
      supabaseUserId: supabaseUserId,
      supabaseToken: supabaseToken,
      createdAt: now,
      lastActiveAt: now,
      email: '',
    );
  }

  /// Factory pour créer une session authentifiée depuis Supabase
  factory UserSession.createAuthenticated({
    required String supabaseUserId,
    required String email,
    required UserRole role,
    String? supabaseToken,
    String? firstName,
    String? lastName,
    String? phone,
    String? address,
  }) {
    final now = DateTime.now();
    return UserSession(
      id: supabaseUserId,
      role: role,
      profile: UserProfileModel(
        firstName: firstName ?? '',
        lastName: lastName ?? '',
        email: email,
        phone: phone ?? '',
        address: address ?? '',
      ),
      supabaseUserId: supabaseUserId,
      supabaseToken: supabaseToken,
      createdAt: now,
      lastActiveAt: now,
      email: email,
    );
  }

  @override
  String toString() {
    return 'UserSession(id: $id, role: ${role.value}, email: $email, isAnonymous: $isAnonymous)';
  }
}

