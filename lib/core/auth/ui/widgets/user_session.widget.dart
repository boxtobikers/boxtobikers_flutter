import 'package:boxtobikers/core/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Widget pour afficher les informations de la session utilisateur
/// Utilisation typique : dans un Drawer ou une AppBar
class UserSessionWidget extends StatelessWidget {
  const UserSessionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final session = authProvider.currentSession;

        if (session == null) {
          return const _NoSessionWidget();
        }

        if (session.isAnonymous) {
          return _AnonymousSessionWidget(onLogin: () {
            Navigator.of(context).pushNamed('/login');
          });
        }

        return _AuthenticatedSessionWidget(
          session: session,
          onLogout: () async {
            final confirmed = await _showLogoutConfirmation(context);
            if (confirmed == true) {
              await authProvider.signOut();
            }
          },
          onProfile: () {
            Navigator.of(context).pushNamed('/profil');
          },
        );
      },
    );
  }

  Future<bool?> _showLogoutConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );
  }
}

/// Widget affiché quand aucune session n'existe
class _NoSessionWidget extends StatelessWidget {
  const _NoSessionWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.account_circle, size: 48, color: Colors.grey),
          SizedBox(height: 8),
          Text(
            'Aucune session',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

/// Widget affiché pour une session anonyme
class _AnonymousSessionWidget extends StatelessWidget {
  final VoidCallback onLogin;

  const _AnonymousSessionWidget({required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.secondaryContainer,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 32,
            child: Icon(Icons.person_outline, size: 32),
          ),
          const SizedBox(height: 12),
          const Text(
            'Visiteur',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Mode anonyme',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onLogin,
            icon: const Icon(Icons.login),
            label: const Text('Se connecter'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(40),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget affiché pour une session authentifiée
class _AuthenticatedSessionWidget extends StatelessWidget {
  final UserSession session;
  final VoidCallback onLogout;
  final VoidCallback onProfile;

  const _AuthenticatedSessionWidget({
    required this.session,
    required this.onLogout,
    required this.onProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.secondaryContainer,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              _getInitials(session.profile.fullName),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            session.profile.fullName.isEmpty
                ? session.email
                : session.profile.fullName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          if (session.profile.fullName.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              session.email,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
          const SizedBox(height: 4),
          _RoleBadge(role: session.role),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onProfile,
                  icon: const Icon(Icons.person, size: 16),
                  label: const Text('Profil'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onLogout,
                  icon: const Icon(Icons.logout, size: 16),
                  label: const Text('Sortir'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getInitials(String fullName) {
    if (fullName.isEmpty) return '?';

    final parts = fullName.trim().split(' ');
    if (parts.isEmpty) return '?';

    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }

    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }
}

/// Badge pour afficher le rôle de l'utilisateur
class _RoleBadge extends StatelessWidget {
  final UserRole role;

  const _RoleBadge({required this.role});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    IconData icon;

    switch (role) {
      case UserRole.admin:
        backgroundColor = Colors.red.shade100;
        icon = Icons.admin_panel_settings;
        break;
      case UserRole.client:
        backgroundColor = Colors.green.shade100;
        icon = Icons.verified_user;
        break;
      case UserRole.visitor:
        backgroundColor = Colors.grey.shade200;
        icon = Icons.visibility;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 4),
          Text(
            role.value,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

