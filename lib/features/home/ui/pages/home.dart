import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';
import '../../models/home_items_data.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final stackHeight = screenHeight * 0.5;

    // Récupérer les éléments de la liste depuis la classe de données
    final listItems = HomeItemsData.getHomeItems();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: stackHeight,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'assets/btb_sea.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 16,
                        left: 16,
                        right: 16,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            S.of(context).homeTitle,
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  offset: const Offset(0, 2),
                                  blurRadius: 4.0,
                                  color: Colors.black.withValues(alpha: 0.5),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.separated(
                      itemCount: listItems.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = listItems[index];
                        return _buildListItem(
                          context,
                          icon: item.icon,
                          title: _getLocalizedString(context, item.titleKey),
                          description: _getLocalizedString(context, item.descriptionKey),
                          onTap: item.onTap,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FilledButton.icon(
                  onPressed: () {
                    // TODO: Implement login functionality
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  ),
                  icon: const Icon(
                    Icons.login,
                    weight: 700,
                  ),
                  label: Text(
                    S.of(context).homeLoginButton,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLocalizedString(BuildContext context, String key) {
    final localizations = S.of(context);
    switch (key) {
      case 'homeItemExploreTitle':
        return localizations.homeItemExploreTitle;
      case 'homeItemExploreDescription':
        return localizations.homeItemExploreDescription;
      case 'homeItemWhoAmITitle':
        return localizations.homeItemWhoAmITitle;
      case 'homeItemWhoAmIDescription':
        return localizations.homeItemWhoAmIDescription;
      case 'homeItemSettingsTitle':
        return localizations.homeItemSettingsTitle;
      case 'homeItemSettingsDescription':
        return localizations.homeItemSettingsDescription;
      default:
        return key;
    }
  }

  Widget _buildListItem(BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, size: 28.0, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 28.0),
          ],
        ),
      ),
    );
  }
}