import 'package:boxtobikers/core/config/env_config.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service Supabase pour BoxToBikers
class SupabaseService {
  // Singleton pattern
  static SupabaseService? _instance;
  static SupabaseService get instance {
    _instance ??= SupabaseService._();
    return _instance!;
  }

  SupabaseService._();

  /// Initialise Supabase avec les variables d'environnement
  static Future<void> initialize() async {
    try {
      // Valider que les variables d'environnement sont définies
      EnvConfig.validate();

      // Initialiser Supabase
      await Supabase.initialize(
        url: EnvConfig.supabaseUrl,
        anonKey: EnvConfig.supabaseAnonKey,
        debug: EnvConfig.isDevelopment,
      );

      if (EnvConfig.isDevelopment) {
        debugPrint('✅ Supabase initialisé : ${EnvConfig.supabaseUrl}');
      }
    } catch (e) {
      debugPrint('❌ Erreur lors de l\'initialisation de Supabase : $e');
      rethrow;
    }
  }

  /// Récupère le client Supabase
  SupabaseClient get client => Supabase.instance.client;

  /// Vérifie si l'utilisateur est connecté
  bool get isAuthenticated => client.auth.currentUser != null;

  /// Récupère l'utilisateur connecté
  User? get currentUser => client.auth.currentUser;

  /// Se connecter avec email/password
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      debugPrint('❌ Erreur de connexion : $e');
      rethrow;
    }
  }

  /// S'inscrire avec email/password
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    try {
      return await client.auth.signUp(
        email: email,
        password: password,
        data: data,
      );
    } catch (e) {
      debugPrint('❌ Erreur d\'inscription : $e');
      rethrow;
    }
  }

  /// Se déconnecter
  Future<void> signOut() async {
    try {
      await client.auth.signOut();
      if (EnvConfig.isDevelopment) {
        debugPrint('✅ Déconnexion réussie');
      }
    } catch (e) {
      debugPrint('❌ Erreur de déconnexion : $e');
      rethrow;
    }
  }

  /// Écouter les changements d'état d'authentification
  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  /// Récupérer des données d'une table
  ///
  /// Exemple :
  /// ```text
  /// final data = await SupabaseService.instance.getTableData('users');
  /// ```
  Future<List<Map<String, dynamic>>> getTableData(
    String tableName, {
    String? orderBy,
    bool ascending = true,
  }) async {
    try {
      dynamic query = client.from(tableName).select();

      if (orderBy != null) {
        query = query.order(orderBy, ascending: ascending);
      }

      final response = await query;
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('❌ Erreur de récupération des données : $e');
      rethrow;
    }
  }

  /// Insérer des données dans une table
  Future<void> insertData(
    String tableName,
    Map<String, dynamic> data,
  ) async {
    try {
      await client.from(tableName).insert(data);
      if (EnvConfig.isDevelopment) {
        debugPrint('✅ Données insérées dans $tableName');
      }
    } catch (e) {
      debugPrint('❌ Erreur d\'insertion : $e');
      rethrow;
    }
  }

  /// Mettre à jour des données
  Future<void> updateData(
    String tableName,
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      await client.from(tableName).update(data).eq('id', id);
      if (EnvConfig.isDevelopment) {
        debugPrint('✅ Données mises à jour dans $tableName');
      }
    } catch (e) {
      debugPrint('❌ Erreur de mise à jour : $e');
      rethrow;
    }
  }

  /// Supprimer des données
  Future<void> deleteData(String tableName, String id) async {
    try {
      await client.from(tableName).delete().eq('id', id);
      if (EnvConfig.isDevelopment) {
        debugPrint('✅ Données supprimées de $tableName');
      }
    } catch (e) {
      debugPrint('❌ Erreur de suppression : $e');
      rethrow;
    }
  }
}

