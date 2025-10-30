import 'package:boxtobikers/core/services/local_storage.service.dart';
import 'package:boxtobikers/features/history/data/models/destination.model.dart';
import 'package:boxtobikers/features/history/data/repositories/destination.repository.dart';
import 'package:flutter/foundation.dart';

/// Provider pour gérer l'état des destinations de l'utilisateur
/// - Dependency Inversion : dépend des abstractions Repository et LocalStorageService
class DestinationsProvider extends ChangeNotifier {
  final DestinationRepository _repository;
  final LocalStorageService _storageService;

  List<Destination> _destinations = [];
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _errorMessage;

  DestinationsProvider({
    required DestinationRepository repository,
    required LocalStorageService storageService,
  })  : _repository = repository,
        _storageService = storageService;

  // ============ Getters ============

  /// Liste des destinations de l'utilisateur
  List<Destination> get destinations => List.unmodifiable(_destinations);

  /// Indique si le chargement est en cours
  bool get isLoading => _isLoading;

  /// Indique si le provider a été initialisé
  bool get isInitialized => _isInitialized;

  /// Message d'erreur si échec du chargement
  String? get errorMessage => _errorMessage;

  /// Nombre de destinations
  int get count => _destinations.length;

  // ============ Initialisation ============

  /// Initialise les destinations au démarrage
  /// 1. Charge depuis le cache local (instantané)
  /// 2. Rafraîchit depuis Supabase si un userId est fourni
  Future<void> initialize({String? userId}) async {
    if (_isInitialized) {
      debugPrint('ℹ️ DestinationsProvider: Déjà initialisé');
      return;
    }

    try {
      debugPrint('🚀 DestinationsProvider: Initialisation...');

      // 1. Charger depuis le cache local
      _destinations = await _storageService.loadDestinations();
      _isInitialized = true;
      notifyListeners();

      debugPrint('✅ DestinationsProvider: ${_destinations.length} destinations chargées depuis le cache');

      // 2. Rafraîchir depuis Supabase si userId fourni
      if (userId != null && userId.isNotEmpty) {
        await refreshFromSupabase(userId, silent: true);
      }
    } catch (e) {
      debugPrint('❌ DestinationsProvider: Erreur lors de l\'initialisation: $e');
      _errorMessage = 'Erreur lors du chargement des destinations';
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// Rafraîchit les destinations depuis Supabase
  /// [userId] L'identifiant de l'utilisateur
  /// [silent] Si true, ne change pas l'état de chargement (pour rafraîchissement en arrière-plan)
  Future<void> refreshFromSupabase(String userId, {bool silent = false}) async {
    try {
      if (!silent) {
        _isLoading = true;
        _errorMessage = null;
        notifyListeners();
      }

      debugPrint('🔄 DestinationsProvider: Rafraîchissement depuis Supabase...');

      final destinations = await _repository.getDestinationsByUserId(userId);

      if (destinations != null) {
        _destinations = destinations;
        await _storageService.saveDestinations(_destinations);
        _errorMessage = null;

        debugPrint('✅ DestinationsProvider: ${_destinations.length} destinations rafraîchies');
      } else {
        _errorMessage = 'Impossible de charger les destinations';
        debugPrint('⚠️ DestinationsProvider: Échec du rafraîchissement');
      }
    } catch (e) {
      debugPrint('❌ DestinationsProvider: Erreur lors du rafraîchissement: $e');
      _errorMessage = 'Erreur lors du rafraîchissement des destinations';
    } finally {
      if (!silent) {
        _isLoading = false;
      }
      notifyListeners();
    }
  }

  /// Charge les destinations pour un utilisateur
  /// Utile lors du changement d'utilisateur
  Future<void> loadForUser(String userId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      debugPrint('🔄 DestinationsProvider: Chargement pour l\'utilisateur $userId...');

      final destinations = await _repository.getDestinationsByUserId(userId);

      if (destinations != null) {
        _destinations = destinations;
        await _storageService.saveDestinations(_destinations);
        _errorMessage = null;

        debugPrint('✅ DestinationsProvider: ${_destinations.length} destinations chargées');
      } else {
        _errorMessage = 'Impossible de charger les destinations';
        debugPrint('⚠️ DestinationsProvider: Échec du chargement');
      }
    } catch (e) {
      debugPrint('❌ DestinationsProvider: Erreur lors du chargement: $e');
      _errorMessage = 'Erreur lors du chargement des destinations';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Efface toutes les destinations
  /// Utile lors de la déconnexion
  Future<void> clear() async {
    try {
      _destinations = [];
      await _storageService.clearDestinations();
      _errorMessage = null;
      debugPrint('✅ DestinationsProvider: Destinations effacées');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ DestinationsProvider: Erreur lors de l\'effacement: $e');
    }
  }

  /// Réinitialise le provider
  Future<void> reset() async {
    _destinations = [];
    _isLoading = false;
    _isInitialized = false;
    _errorMessage = null;
    await _storageService.clearDestinations();
    notifyListeners();
    debugPrint('🔄 DestinationsProvider: Provider réinitialisé');
  }
}

