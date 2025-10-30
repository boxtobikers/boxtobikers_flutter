import 'package:boxtobikers/core/services/supabase_service.dart';
import 'package:boxtobikers/features/history/data/models/destination.model.dart';
import 'package:flutter/foundation.dart';

/// Repository pour gérer l'accès aux données des destinations depuis Supabase
class DestinationRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;

  /// Récupère la liste des destinations depuis Supabase
  ///
  /// [limit] Le nombre de destinations à récupérer (par défaut 10)
  /// [offset] Le décalage pour la pagination (par défaut 0)
  /// Retourne une liste de destinations ou null en cas d'erreur
  Future<List<Destination>?> getDestinations({
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final response = await _supabaseService.client
          .from('destinations')
          .select()
          .order('created_at', ascending: false)
          .limit(limit)
          .range(offset, offset + limit - 1);

      // Conversion de la réponse en liste de Destination
      final destinations = (response as List<dynamic>)
          .map((json) => Destination.fromJson(json as Map<String, dynamic>))
          .toList();

      debugPrint('✅ ${destinations.length} destinations récupérées');
      return destinations;
    } catch (e, stackTrace) {
      debugPrint('❌ Erreur lors de la récupération des destinations: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }

  /// Récupère une destination par son ID
  ///
  /// [id] L'identifiant unique de la destination
  /// Retourne la destination ou null en cas d'erreur
  Future<Destination?> getDestinationById(String id) async {
    try {
      final response = await _supabaseService.client
          .from('destinations')
          .select()
          .eq('id', id)
          .single();

      return Destination.fromJson(response);
    } catch (e, stackTrace) {
      debugPrint('❌ Erreur lors de la récupération de la destination: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }

  /// Récupère les destinations filtrées par statut
  ///
  /// [status] Le statut des destinations (OPEN, CLOSED, PAUSED)
  /// [limit] Le nombre de destinations à récupérer
  /// Retourne une liste de destinations ou null en cas d'erreur
  Future<List<Destination>?> getDestinationsByStatus({
    required String status,
    int limit = 10,
  }) async {
    try {
      final response = await _supabaseService.client
          .from('destinations')
          .select()
          .eq('status', status)
          .order('created_at', ascending: false)
          .limit(limit);

      final destinations = (response as List<dynamic>)
          .map((json) => Destination.fromJson(json as Map<String, dynamic>))
          .toList();

      debugPrint('✅ ${destinations.length} destinations avec statut $status récupérées');
      return destinations;
    } catch (e, stackTrace) {
      debugPrint('❌ Erreur lors de la récupération des destinations: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }

  /// Récupère le nombre total de destinations
  Future<int> getDestinationsCount() async {
    try {
      final response = await _supabaseService.client
          .from('destinations')
          .select()
          .count();

      return response.count;
    } catch (e) {
      debugPrint('❌ Erreur lors du comptage des destinations: $e');
      return 0;
    }
  }

  /// Récupère les destinations d'un utilisateur via la table rides
  ///
  /// [userId] L'identifiant de l'utilisateur
  /// Retourne une liste de destinations ou null en cas d'erreur
  Future<List<Destination>?> getDestinationsByUserId(String userId) async {
    try {
      debugPrint('🔍 DestinationRepository: Récupération des destinations pour userId: $userId');

      final response = await _supabaseService.client
          .from('rides')
          .select('destination_id, destinations(*)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      debugPrint('🔍 DestinationRepository: Réponse brute: $response');

      final destinations = (response as List<dynamic>)
          .map((json) {
            final destinationData = json['destinations'] as Map<String, dynamic>;
            return Destination.fromJson(destinationData);
          })
          .toList();

      debugPrint('✅ ${destinations.length} destinations récupérées pour l\'utilisateur $userId');
      return destinations;
    } catch (e, stackTrace) {
      debugPrint('❌ Erreur lors de la récupération des destinations de l\'utilisateur: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }
}

