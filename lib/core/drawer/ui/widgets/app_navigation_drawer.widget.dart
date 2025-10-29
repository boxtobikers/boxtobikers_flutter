import 'package:boxtobikers/core/app/helpers/app_session.helpers.dart';
import 'package:boxtobikers/core/app/utils/app_constants.utils.dart';
import 'package:boxtobikers/core/auth/providers/app_auth.provider.dart';
import 'package:boxtobikers/core/drawer/business/models/app_drawer_destination.model.dart';
import 'package:boxtobikers/core/drawer/business/models/app_drawer_destinations.model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Widget réutilisable pour le NavigationDrawer de l'application
/// Affiche les informations de l'utilisateur connecté (ou visiteur)
class AppNavigationDrawerWidget extends StatelessWidget {
  final int selectedIndex;
  final String? title;
  final List<AppDrawerDestinationModel>? destinations;

  const AppNavigationDrawerWidget({
    super.key,
    required this.selectedIndex,
    this.title,
    this.destinations,
  });

  void _onDestinationSelected(BuildContext context, int index, List<AppDrawerDestinationModel> destList) {
    if (index == selectedIndex) {
      Navigator.of(context).pop();
      return;
    }

    Navigator.of(context).pop(); // Ferme le drawer
    Navigator.pushReplacementNamed(context, destList[index].route);
  }

  @override
  Widget build(BuildContext context) {
    // Récupérer la session utilisateur depuis le AuthProvider
    final authProvider = context.watch<AppAuthProvider>();
    final userSession = authProvider.currentSession;
    final userProfile = userSession?.profile;

    final destList = destinations ?? getAppDrawerDestinations(context);
    final drawerTitle = title ?? AppConstants.appTitle;

    return NavigationDrawer(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) => _onDestinationSelected(context, index, destList),
      children: [
        // Header avec informations utilisateur
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row avec avatar et badge de même hauteur
              Row(
                children: [
                  // Avatar utilisateur avec initiales
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        AppSessionHelpers.getInitials(userProfile),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Badge pour indiquer le rôle
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: userSession?.isAnonymous == true
                        ? Colors.orange.withValues(alpha: 0.8)
                        : Colors.green.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      userSession?.isAnonymous == true ? Icons.visibility : Icons.verified_user,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Nom de l'utilisateur
              Text(
                AppSessionHelpers.getFullName(userProfile),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              // Email de l'utilisateur
              Text(
                AppSessionHelpers.getEmail(userSession),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 8, 16, 8),
          child: Text(
            drawerTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        ...destList.map((destination) => NavigationDrawerDestination(
              icon: Icon(destination.icon),
              selectedIcon: Icon(destination.selectedIcon),
              label: Text(destination.label),
            )),
      ],
    );
  }
}

