import 'dart:async';

import 'package:boxtobikers/core/auth/models/auth_status.enum.dart';
import 'package:boxtobikers/core/auth/models/user_session.model.dart';
import 'package:boxtobikers/core/auth/repositories/auth.repository.dart';
import 'package:boxtobikers/core/auth/services/session.service.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Provider pour gérer l'état d'authentification de l'application
/// Principe SOLID :
/// - Single Responsibility : gère l'état d'authentification
/// - Dependency Inversion : dépend des abstractions AuthRepository et SessionService
class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  final SessionService _sessionService;

  AuthStatus _status = AuthStatus.initial;
  UserSession? _currentSession;
  String? _errorMessage;
  StreamSubscription<AuthState>? _authSubscription;

  AuthProvider({
    required AuthRepository authRepository,
    required SessionService sessionService,
  })  : _authRepository = authRepository,
        _sessionService = sessionService {
    _listenToAuthChanges();
  }

  // ============ Getters ============

  /// État actuel de l'authentification
  AuthStatus get status => _status;

  /// Session utilisateur actuelle (peut être null)
  UserSession? get currentSession => _currentSession;

  /// Message d'erreur si l'état est error
  String? get errorMessage => _errorMessage;

  /// Vérifie si l'utilisateur est authentifié
  bool get isAuthenticated =>
      _currentSession != null && _currentSession!.isAuthenticated;

  /// Vérifie si l'utilisateur est anonyme
  bool get isAnonymous =>
      _currentSession != null && _currentSession!.isAnonymous;

  /// Vérifie si une session existe (authentifié ou anonyme)
  bool get hasSession => _currentSession != null;

  // ============ Initialisation ============

  /// Initialise l'authentification au démarrage de l'app
  /// 1. Vérifie s'il y a une session Supabase active
  /// 2. Sinon, vérifie s'il y a une session locale sauvegardée
  /// 3. Sinon, crée une nouvelle session anonyme
  Future<void> initialize() async {
    try {
      _setStatus(AuthStatus.loading);
      debugPrint('🚀 AuthProvider: Initialisation...');

      // 1. Vérifier si une session Supabase existe
      final supabaseSession = await _authRepository.getCurrentSession();

      if (supabaseSession != null) {
        debugPrint('✅ AuthProvider: Session Supabase trouvée');
        _currentSession = supabaseSession;
        await _sessionService.saveSession(supabaseSession);
        _setStatus(supabaseSession.isAnonymous
            ? AuthStatus.anonymous
            : AuthStatus.authenticated);
        return;
      }

      // 2. Vérifier si une session locale existe
      final localSession = await _sessionService.loadSession();

      if (localSession != null && localSession.isValid) {
        debugPrint('✅ AuthProvider: Session locale trouvée mais session Supabase expirée');
        // Session locale existe mais Supabase est déconnecté
        // On recrée une session anonyme
        await _createAnonymousSession();
        return;
      }

      // 3. Créer une nouvelle session anonyme
      debugPrint('ℹ️ AuthProvider: Aucune session trouvée, création d\'une session anonyme');
      await _createAnonymousSession();

    } catch (e) {
      debugPrint('❌ AuthProvider: Erreur lors de l\'initialisation: $e');
      _setError('Erreur lors de l\'initialisation: $e');
    }
  }

  /// Crée une nouvelle session anonyme
  Future<void> _createAnonymousSession() async {
    final session = await _authRepository.signInAnonymously();

    if (session != null) {
      _currentSession = session;
      await _sessionService.saveSession(session);
      _setStatus(AuthStatus.anonymous);
    } else {
      _setError('Impossible de créer une session anonyme');
    }
  }

  // ============ Authentification ============

  /// Connexion avec email et mot de passe
  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      _setStatus(AuthStatus.loading);
      debugPrint('🔐 AuthProvider: Connexion avec email...');

      final session = await _authRepository.signInWithEmail(
        email: email,
        password: password,
      );

      if (session == null) {
        _setError('Email ou mot de passe incorrect');
        return false;
      }

      _currentSession = session;
      await _sessionService.saveSession(session);
      _setStatus(AuthStatus.authenticated);

      debugPrint('✅ AuthProvider: Connexion réussie');
      return true;
    } catch (e) {
      debugPrint('❌ AuthProvider: Erreur lors de la connexion: $e');
      _setError('Erreur lors de la connexion: $e');
      return false;
    }
  }

  /// Inscription avec email et mot de passe
  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    try {
      _setStatus(AuthStatus.loading);
      debugPrint('🔐 AuthProvider: Inscription...');

      final session = await _authRepository.signUpWithEmail(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );

      if (session == null) {
        _setError('Erreur lors de l\'inscription');
        return false;
      }

      _currentSession = session;
      await _sessionService.saveSession(session);
      _setStatus(AuthStatus.authenticated);

      debugPrint('✅ AuthProvider: Inscription réussie');
      return true;
    } catch (e) {
      debugPrint('❌ AuthProvider: Erreur lors de l\'inscription: $e');
      _setError('Erreur lors de l\'inscription: $e');
      return false;
    }
  }

  /// Déconnexion
  /// Supprime la session actuelle et recrée une session anonyme
  Future<void> signOut() async {
    try {
      _setStatus(AuthStatus.loading);
      debugPrint('🔐 AuthProvider: Déconnexion...');

      await _authRepository.signOut();
      await _sessionService.clearSession();

      // Recréer une session anonyme après déconnexion
      await _createAnonymousSession();

      debugPrint('✅ AuthProvider: Déconnexion réussie');
    } catch (e) {
      debugPrint('❌ AuthProvider: Erreur lors de la déconnexion: $e');
      _setError('Erreur lors de la déconnexion: $e');
    }
  }

  /// Met à jour le profil utilisateur
  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? address,
  }) async {
    try {
      if (_currentSession == null || _currentSession!.supabaseUserId == null) {
        debugPrint('⚠️ AuthProvider: Aucune session active pour mise à jour');
        return false;
      }

      debugPrint('🔐 AuthProvider: Mise à jour du profil...');

      final success = await _authRepository.updateProfile(
        userId: _currentSession!.supabaseUserId!,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        address: address,
      );

      if (success) {
        // Mettre à jour la session locale
        final updatedProfile = _currentSession!.profile.copyWith(
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          address: address,
        );

        _currentSession = _currentSession!.copyWith(profile: updatedProfile);
        await _sessionService.saveSession(_currentSession!);
        notifyListeners();

        debugPrint('✅ AuthProvider: Profil mis à jour');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('❌ AuthProvider: Erreur lors de la mise à jour du profil: $e');
      return false;
    }
  }

  // ============ Gestion de l'état ============

  /// Met à jour l'état et notifie les listeners
  void _setStatus(AuthStatus newStatus) {
    _status = newStatus;
    _errorMessage = null;
    notifyListeners();
  }

  /// Met l'état en erreur avec un message
  void _setError(String message) {
    _status = AuthStatus.error;
    _errorMessage = message;
    notifyListeners();
  }

  // ============ Écoute des changements Supabase ============

  /// Écoute les changements d'état d'authentification de Supabase
  void _listenToAuthChanges() {
    _authSubscription = _authRepository.authStateChanges.listen(
      (AuthState authState) async {
        debugPrint('🔔 AuthProvider: Changement d\'état Supabase - ${authState.event}');

        switch (authState.event) {
          case AuthChangeEvent.signedIn:
            // L'utilisateur s'est connecté
            final session = await _authRepository.getCurrentSession();
            if (session != null) {
              _currentSession = session;
              await _sessionService.saveSession(session);
              _setStatus(session.isAnonymous
                  ? AuthStatus.anonymous
                  : AuthStatus.authenticated);
            }
            break;

          case AuthChangeEvent.signedOut:
            // L'utilisateur s'est déconnecté
            _currentSession = null;
            await _sessionService.clearSession();
            _setStatus(AuthStatus.unauthenticated);
            break;

          case AuthChangeEvent.tokenRefreshed:
            // Le token a été rafraîchi
            if (_currentSession != null && authState.session != null) {
              _currentSession = _currentSession!.copyWith(
                supabaseToken: authState.session!.accessToken,
                lastActiveAt: DateTime.now(),
              );
              await _sessionService.saveSession(_currentSession!);
            }
            break;

          default:
            break;
        }
      },
      onError: (error) {
        debugPrint('❌ AuthProvider: Erreur dans le stream d\'auth: $error');
      },
    );
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}

