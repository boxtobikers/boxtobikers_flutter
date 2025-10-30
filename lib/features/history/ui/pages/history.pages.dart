import 'package:boxtobikers/core/auth/providers/app_auth.provider.dart';
import 'package:boxtobikers/features/history/business/providers/destinations.provider.dart';
import 'package:boxtobikers/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryPages extends StatefulWidget {
  const HistoryPages({super.key});

  @override
  State<StatefulWidget> createState() => _HistoryPagesState();
}

class _HistoryPagesState extends State<HistoryPages> {
  @override
  void initState() {
    super.initState();
    // Différer le chargement après la construction complète du widget
    Future.microtask(() {
      _refreshDestinations();
    });
  }

  /// Rafraîchit les destinations de l'utilisateur connecté
  Future<void> _refreshDestinations() async {
    final authProvider = context.read<AppAuthProvider>();
    final destinationsProvider = context.read<DestinationsProvider>();

    final session = authProvider.currentSession;
    if (session == null) return;

    // Pour les VISITOR, utiliser session.id (profileId)
    // Pour les utilisateurs authentifiés, utiliser supabaseUserId
    final userId = session.supabaseUserId ?? session.id;

    if (userId.isNotEmpty) {
      await destinationsProvider.refreshFromSupabase(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    final double headerImageHeight = MediaQuery.of(context).size.height / 4;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      body: SafeArea(
        child: Column(
          children: [
            // Section supérieure avec icône Flutter et titre
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: headerImageHeight,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/btb_header_paris.jpg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16.0),
                        bottomRight: Radius.circular(16.0),
                      ),
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8.0,
                    left: 8.0,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Zone de contenu scrollable
            Expanded(
              child: Consumer<DestinationsProvider>(
                builder: (context, destinationsProvider, child) {
                  if (destinationsProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (destinationsProvider.errorMessage != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            destinationsProvider.errorMessage!,
                            style: TextStyle(color: Theme.of(context).colorScheme.error),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _refreshDestinations,
                            child: Text(l10n.commonRetry),
                          ),
                        ],
                      ),
                    );
                  }

                  final destinations = destinationsProvider.destinations;

                  if (destinations.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history,
                            size: 64,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Aucune destination dans votre historique',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Vos destinations visitées apparaîtront ici',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: _refreshDestinations,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: destinations.length,
                      itemBuilder: (context, index) {
                        final destination = destinations[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: destination.status == 'OPEN'
                                  ? Theme.of(context).colorScheme.primaryContainer
                                  : Theme.of(context).colorScheme.errorContainer,
                              child: Icon(
                                destination.type == 'BUSINESS'
                                    ? Icons.business
                                    : Icons.home,
                                color: destination.status == 'OPEN'
                                    ? Theme.of(context).colorScheme.onPrimaryContainer
                                    : Theme.of(context).colorScheme.onErrorContainer,
                              ),
                            ),
                            title: Text(
                              destination.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                if (destination.address != null)
                                  Text('📍 ${destination.address}'),
                                Text('${destination.typeLabel} • ${destination.statusLabel}'),
                                Text('🔒 ${destination.lockerCount} casiers disponibles'),
                              ],
                            ),
                            isThreeLine: true,
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            onTap: () {
                              // TODO: Navigation vers les détails de la destination
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}