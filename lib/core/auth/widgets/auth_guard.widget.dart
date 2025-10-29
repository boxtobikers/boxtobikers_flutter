import 'package:boxtobikers/core/auth/models/user_role.enum.dart';
import 'package:boxtobikers/core/auth/providers/app_auth.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Widget Guard pour protéger l'accès aux pages selon le rôle utilisateur
/// Principe SOLID : Open/Closed - extensible sans modifier les pages protégées
class AuthGuard extends StatelessWidget {
  /// Widget enfant à afficher si l'utilisateur a les bonnes permissions
  final Widget child;

  /// Liste des rôles autorisés à accéder à cette page
  final List<UserRole> allowedRoles;

  /// Widget à afficher si l'utilisateur n'a pas les permissions
  /// Si null, affiche un message par défaut
  final Widget? fallback;

  /// Message personnalisé à afficher dans le fallback par défaut
  final String? deniedMessage;

  const AuthGuard({
    super.key,
    required this.child,
    required this.allowedRoles,
    this.fallback,
    this.deniedMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppAuthProvider>(
      builder: (context, authProvider, _) {
        final session = authProvider.currentSession;

        // Si pas de session, afficher le fallback
        if (session == null) {
          return fallback ?? _buildDefaultFallback(context, 'Aucune session active');
        }

        // Vérifier si le rôle de l'utilisateur est autorisé
        final hasPermission = allowedRoles.contains(session.role);

        if (hasPermission) {
          return child;
        }

        // Afficher le fallback si pas autorisé
        return fallback ?? _buildDefaultFallback(
          context,
          deniedMessage ?? 'Accès refusé. Vous n\'avez pas les permissions nécessaires.',
        );
      },
    );
  }

  /// Construit le fallback par défaut avec un message d'erreur
  Widget _buildDefaultFallback(BuildContext context, String message) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accès refusé'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 24),
              Text(
                message,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Retour'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Extension helper pour faciliter l'utilisation du AuthGuard
extension AuthGuardExtension on Widget {
  /// Enveloppe le widget dans un AuthGuard
  Widget withAuthGuard({
    required List<UserRole> allowedRoles,
    Widget? fallback,
    String? deniedMessage,
  }) {
    return AuthGuard(
      allowedRoles: allowedRoles,
      fallback: fallback,
      deniedMessage: deniedMessage,
      child: this,
    );
  }
}

