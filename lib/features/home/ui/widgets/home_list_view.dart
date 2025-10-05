import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';
import '../../models/home_items_data.dart';

class HomeListView extends StatelessWidget {
  const HomeListView({super.key});

  @override
  Widget build(BuildContext context) {
    final listItems = HomeItemsData.getHomeItems(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: listItems.length,
        itemBuilder: (context, index) {
          final item = listItems[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: _buildItems(
              context,
              icon: item.icon,
              title: _getLocalizedString(context, item.titleKey),
              description: _getLocalizedString(context, item.descriptionKey),
              onTap: item.onTap,
            ),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ListTile(
            leading: Icon(
              icon,
              size: 24.0,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              size: 24.0,
              color: Theme.of(context).colorScheme.primary,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}
