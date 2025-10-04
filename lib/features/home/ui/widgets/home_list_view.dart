import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';
import '../../models/home_items_data.dart';

class HomeListView extends StatelessWidget {
  const HomeListView({super.key});

  @override
  Widget build(BuildContext context) {
    final listItems = HomeItemsData.getHomeItems();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.separated(
        itemCount: listItems.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = listItems[index];
          return _buildItems(
            context,
            icon: item.icon,
            title: _getLocalizedString(context, item.titleKey),
            description: _getLocalizedString(context, item.descriptionKey),
            onTap: item.onTap,
          );
        },
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

  Widget _buildItems(BuildContext context, {
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

