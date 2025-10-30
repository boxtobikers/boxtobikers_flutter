import 'package:boxtobikers/core/auth/providers/app_auth.provider.dart';
import 'package:boxtobikers/features/history/business/providers/destinations.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Widget qui synchronise les destinations avec l'état d'authentification
/// Charge les destinations lors de la connexion et les efface lors de la déconnexion
class DestinationsSyncWidget extends StatefulWidget {
  final Widget child;

  const DestinationsSyncWidget({
    super.key,
    required this.child,
  });

  @override
  State<DestinationsSyncWidget> createState() => _DestinationsSyncWidgetState();
}

class _DestinationsSyncWidgetState extends State<DestinationsSyncWidget> {
  String? _lastUserId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncDestinations();
  }

  void _syncDestinations() {
    final authProvider = context.watch<AppAuthProvider>();
    final destinationsProvider = context.read<DestinationsProvider>();

    final session = authProvider.currentSession;
    // Pour les VISITOR, utiliser session.id (profileId)
    // Pour les utilisateurs authentifiés, utiliser supabaseUserId
    final currentUserId = session != null ? (session.supabaseUserId ?? session.id) : null;

    // Si l'utilisateur a changé
    if (currentUserId != _lastUserId) {
      _lastUserId = currentUserId;

      if (currentUserId != null && currentUserId.isNotEmpty) {
        // Charger les destinations pour le nouvel utilisateur
        debugPrint('🔄 DestinationsSync: Chargement des destinations pour userId: $currentUserId');
        destinationsProvider.loadForUser(currentUserId);
      } else {
        // Effacer les destinations si déconnexion
        debugPrint('🔄 DestinationsSync: Effacement des destinations');
        destinationsProvider.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

