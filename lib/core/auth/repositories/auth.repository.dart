import 'package:boxtobikers/core/auth/models/user_role.enum.dart';
import 'package:boxtobikers/core/auth/models/user_session.model.dart';
import 'package:boxtobikers/core/services/supabase_service.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Repository pour gérer l'authentification via Supabase
/// Principe SOLID : Single Responsibility - gère uniquement les opérations d'authentification
class AuthRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;

  /// UUID fixe du profil VISITOR pré-créé dans la base de données
  /// Ce profil est partagé par tous les utilisateurs non connectés
  static const String _visitorProfileId = '00000000-0000-0000-0000-000000000000';

  /// Crée une session locale VISITOR en utilisant l'utilisateur pré-créé
  /// Utilise le profil VISITOR pré-créé dans la base de données
  /// Retourne une UserSession avec le rôle VISITOR
  Future<UserSession?> signInAnonymously() async {
    try {
      debugPrint('🔐 AuthRepository: Création session VISITOR...');
      debugPrint('ℹ️ AuthRepository: Utilisation du profil VISITOR pré-créé (UUID: $_visitorProfileId)');

      // Vérifier que le profil VISITOR existe dans la base de données
      final visitorProfile = await _fetchVisitorProfile();

      if (visitorProfile == null) {
        debugPrint('❌ AuthRepository: Profil VISITOR pré-créé non trouvé dans la base de données');
        debugPrint('⚠️ AuthRepository: Assurez-vous d\'avoir exécuté: supabase db reset');
        return null;
      }

      debugPrint('✅ AuthRepository: Profil VISITOR trouvé - ${visitorProfile['first_name']} ${visitorProfile['last_name']}');

      // Créer une session VISITOR locale
      // Note: On utilise l'UUID du profil VISITOR comme identifiant de session
      // mais on ne crée pas de vraie session Supabase (pas de token)
      final session = UserSession.createVisitor(
        profileId: _visitorProfileId,
        firstName: visitorProfile['first_name'] as String,
        lastName: visitorProfile['last_name'] as String,
        email: visitorProfile['email'] as String,
      );

      debugPrint('✅ AuthRepository: Session VISITOR créée - ${session.toString()}');
      return session;
    } catch (e, stackTrace) {
      debugPrint('❌ AuthRepository: Erreur lors de la création de la session VISITOR: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }

  /// Récupère le profil VISITOR pré-créé depuis la base de données
  /// Ce profil a un UUID fixe: 00000000-0000-0000-0000-000000000000
  Future<Map<String, dynamic>?> _fetchVisitorProfile() async {
    try {
      final response = await _supabaseService.client
          .from('profiles')
          .select('''
            id,
            first_name,
            last_name,
            email,
            mobile,
            address,
            created_at,
            role_id,
            roles!inner(name)
          ''')
          .eq('id', _visitorProfileId)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      // Extraire le nom du rôle depuis la relation
      final roleName = response['roles']['name'] as String;

      return {
        'id': response['id'],
        'first_name': response['first_name'],
        'last_name': response['last_name'],
        'email': response['email'],
        'mobile': response['mobile'],
        'address': response['address'],
        'role': roleName,
      };
    } catch (e) {
      debugPrint('❌ AuthRepository: Erreur lors de la récupération du profil VISITOR: $e');
      return null;
    }
  }

  /// Se connecte avec email et mot de passe
  /// Retourne une UserSession avec le rôle récupéré depuis la BDD
  Future<UserSession?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('🔐 AuthRepository: Connexion avec email: $email');

      final response = await _supabaseService.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        debugPrint('❌ AuthRepository: Échec de la connexion');
        return null;
      }

      debugPrint('✅ AuthRepository: Connexion réussie - User ID: ${response.user!.id}');

      // Récupérer le profil et le rôle depuis la BDD
      final profile = await _fetchUserProfile(response.user!.id);

      if (profile == null) {
        debugPrint('❌ AuthRepository: Profil non trouvé pour l\'utilisateur');
        return null;
      }

      debugPrint('✅ AuthRepository: Profil récupéré - Role: ${profile['role']}');

      // Créer la session authentifiée
      final session = UserSession.createAuthenticated(
        supabaseUserId: response.user!.id,
        email: response.user!.email ?? email,
        role: UserRole.fromString(profile['role'] as String),
        supabaseToken: response.session?.accessToken,
        firstName: profile['first_name'] as String?,
        lastName: profile['last_name'] as String?,
        phone: profile['mobile'] as String?,
        address: profile['address'] as String?,
      );

      debugPrint('✅ AuthRepository: Session créée - ${session.toString()}');
      return session;
    } catch (e, stackTrace) {
      debugPrint('❌ AuthRepository: Erreur lors de la connexion: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }

  /// Inscrit un nouvel utilisateur avec email et mot de passe
  /// Le trigger Supabase créera automatiquement un profil avec le rôle VISITOR
  Future<UserSession?> signUpWithEmail({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    try {
      debugPrint('🔐 AuthRepository: Inscription avec email: $email');

      final response = await _supabaseService.client.auth.signUp(
        email: email,
        password: password,
        data: {
          'first_name': firstName ?? '',
          'last_name': lastName ?? '',
        },
      );

      if (response.user == null) {
        debugPrint('❌ AuthRepository: Échec de l\'inscription');
        return null;
      }

      debugPrint('✅ AuthRepository: Inscription réussie - User ID: ${response.user!.id}');

      // Attendre un peu que le trigger crée le profil
      await Future.delayed(const Duration(milliseconds: 500));

      // Récupérer le profil créé par le trigger
      final profile = await _fetchUserProfile(response.user!.id);

      if (profile == null) {
        debugPrint('⚠️ AuthRepository: Profil non encore créé, utilisation des valeurs par défaut');
        // Créer une session avec le rôle VISITOR par défaut
        return UserSession.createAuthenticated(
          supabaseUserId: response.user!.id,
          email: email,
          role: UserRole.visitor,
          supabaseToken: response.session?.accessToken,
          firstName: firstName,
          lastName: lastName,
        );
      }

      // Créer la session avec les données du profil
      final session = UserSession.createAuthenticated(
        supabaseUserId: response.user!.id,
        email: response.user!.email ?? email,
        role: UserRole.fromString(profile['role'] as String),
        supabaseToken: response.session?.accessToken,
        firstName: profile['first_name'] as String?,
        lastName: profile['last_name'] as String?,
        phone: profile['mobile'] as String?,
        address: profile['address'] as String?,
      );

      debugPrint('✅ AuthRepository: Session créée après inscription - ${session.toString()}');
      return session;
    } catch (e, stackTrace) {
      debugPrint('❌ AuthRepository: Erreur lors de l\'inscription: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }

  /// Se déconnecte de Supabase
  Future<bool> signOut() async {
    try {
      debugPrint('🔐 AuthRepository: Déconnexion...');
      await _supabaseService.client.auth.signOut();
      debugPrint('✅ AuthRepository: Déconnexion réussie');
      return true;
    } catch (e, stackTrace) {
      debugPrint('❌ AuthRepository: Erreur lors de la déconnexion: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  /// Récupère la session Supabase actuelle si elle existe
  /// Retourne null si aucune session active
  /// Note: Si null est retourné, le AuthProvider créera automatiquement une session VISITOR locale
  Future<UserSession?> getCurrentSession() async {
    try {
      final session = _supabaseService.client.auth.currentSession;
      final user = _supabaseService.client.auth.currentUser;

      if (session == null || user == null) {
        debugPrint('ℹ️ AuthRepository: Aucune session Supabase active');
        debugPrint('ℹ️ AuthRepository: Une session VISITOR locale sera créée par le provider');
        return null;
      }

      debugPrint('ℹ️ AuthRepository: Session Supabase trouvée - User ID: ${user.id}');

      // Vérifier si c'est un utilisateur anonyme Supabase (legacy)
      // Note: Avec le nouveau système VISITOR, cette branche ne devrait plus être utilisée
      if (user.isAnonymous) {
        debugPrint('⚠️ AuthRepository: Utilisateur anonyme Supabase détecté (legacy)');
        debugPrint('ℹ️ AuthRepository: Considéré comme déconnecté, une session VISITOR sera créée');
        // On se déconnecte de l'utilisateur anonyme Supabase
        await signOut();
        return null;
      }

      // Récupérer le profil depuis la BDD
      final profile = await _fetchUserProfile(user.id);

      if (profile == null) {
        debugPrint('⚠️ AuthRepository: Profil non trouvé, session invalide');
        return null;
      }

      // Créer la session authentifiée
      return UserSession.createAuthenticated(
        supabaseUserId: user.id,
        email: user.email ?? '',
        role: UserRole.fromString(profile['role'] as String),
        supabaseToken: session.accessToken,
        firstName: profile['first_name'] as String?,
        lastName: profile['last_name'] as String?,
        phone: profile['mobile'] as String?,
        address: profile['address'] as String?,
      );
    } catch (e, stackTrace) {
      debugPrint('❌ AuthRepository: Erreur lors de la récupération de la session: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }

  /// Écoute les changements d'état d'authentification Supabase
  Stream<AuthState> get authStateChanges => _supabaseService.client.auth.onAuthStateChange;

  /// Récupère le profil utilisateur depuis la BDD
  /// Inclut le rôle en joignant la table roles
  Future<Map<String, dynamic>?> _fetchUserProfile(String userId) async {
    try {
      final response = await _supabaseService.client
          .from('profiles')
          .select('''
            id,
            first_name,
            last_name,
            email,
            mobile,
            address,
            created_at,
            role_id,
            roles!inner(name)
          ''')
          .eq('id', userId)
          .single();

      // Extraire le nom du rôle depuis la relation
      final roleName = response['roles']['name'] as String;

      return {
        'id': response['id'],
        'first_name': response['first_name'],
        'last_name': response['last_name'],
        'email': response['email'],
        'mobile': response['mobile'],
        'address': response['address'],
        'role': roleName,
      };
    } catch (e) {
      debugPrint('❌ AuthRepository: Erreur lors de la récupération du profil: $e');
      return null;
    }
  }

  /// Met à jour le profil utilisateur dans la BDD
  Future<bool> updateProfile({
    required String userId,
    String? firstName,
    String? lastName,
    String? phone,
    String? address,
  }) async {
    try {
      debugPrint('🔐 AuthRepository: Mise à jour du profil pour User ID: $userId');

      final updates = <String, dynamic>{};
      if (firstName != null) updates['first_name'] = firstName;
      if (lastName != null) updates['last_name'] = lastName;
      if (phone != null) updates['mobile'] = phone;
      if (address != null) updates['address'] = address;

      if (updates.isEmpty) {
        debugPrint('⚠️ AuthRepository: Aucune mise à jour à effectuer');
        return true;
      }

      await _supabaseService.client
          .from('profiles')
          .update(updates)
          .eq('id', userId);

      debugPrint('✅ AuthRepository: Profil mis à jour avec succès');
      return true;
    } catch (e, stackTrace) {
      debugPrint('❌ AuthRepository: Erreur lors de la mise à jour du profil: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }
}

